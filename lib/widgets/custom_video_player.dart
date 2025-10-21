import 'package:easy_localization/easy_localization.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart' as video_player;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CustomVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final String placeholderAsset;

  const CustomVideoPlayer({super.key, required this.videoUrl, required this.placeholderAsset});

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  video_player.VideoPlayerController? _videoPlayerController;
  Future<void>? _initializeVideoPlayerFuture;
  bool _isInitialized = false;
  bool _hasError = false;
  String? _errorType;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayerFuture = _loadAndInitializeVideo();
  }

  Future<void> _loadAndInitializeVideo() async {
    try {
      debugPrint('Loading video: ${widget.videoUrl}');

      // Add timeout for the entire operation
      await _performVideoLoad().timeout(const Duration(seconds: 15));
    } catch (e) {
      debugPrint('widgets_custom_video_player_error_loading_video'.tr(args: ['$e']));
      if (mounted) {
        // Classify the error type
        String errorType = 'unknown';
        String errorString = e.toString().toLowerCase();

        if (errorString.contains('timeout')) {
          errorType = 'timeout';
        } else if (errorString.contains('network') ||
                   errorString.contains('connection') ||
                   errorString.contains('http')) {
          errorType = 'network';
        } else if (errorString.contains('codec') ||
                   errorString.contains('format') ||
                   errorString.contains('decoder') ||
                   errorString.contains('capabilities')) {
          errorType = 'codec_incompatible';
        }

        setState(() {
          _isInitialized = false;
          _hasError = true;
          _errorType = errorType;
        });
      }
    }
  }

  Future<void> _performVideoLoad() async {
    FileInfo? fileInfo = await DefaultCacheManager().getFileFromCache(widget.videoUrl);
    File videoFile;

    if (fileInfo != null && fileInfo.file.existsSync()) {
      debugPrint('Video found in cache: ${fileInfo.file.path}');
      videoFile = fileInfo.file;
    } else {
      debugPrint('Downloading video: ${widget.videoUrl}');
      fileInfo = await DefaultCacheManager().downloadFile(widget.videoUrl);
      videoFile = fileInfo.file;
      debugPrint('Video downloaded: ${fileInfo.file.path}');
    }

    if (!mounted) return;

    _videoPlayerController = video_player.VideoPlayerController.file(
      videoFile,
      videoPlayerOptions: video_player.VideoPlayerOptions(mixWithOthers: true)
    );

    await _videoPlayerController!.initialize();

    if (!mounted) return;

    // Add error listener for runtime video playback errors
    _videoPlayerController!.addListener(_videoErrorListener);

    _videoPlayerController?.setLooping(true);
    _videoPlayerController?.play();
    _videoPlayerController?.setVolume(0.0);

    if (mounted) {
      setState(() {
        _isInitialized = true;
        _hasError = false;
        _errorType = null;
      });
    }
  }

  void _videoErrorListener() {
    if (_videoPlayerController != null && _videoPlayerController!.value.hasError) {
      final error = _videoPlayerController!.value.errorDescription;
      debugPrint('Video playback error: $error');

      // Classify error type for better handling
      String errorType = 'unknown';
      if (error != null) {
        if (error.toLowerCase().contains('codec') ||
            error.toLowerCase().contains('decoder') ||
            error.toLowerCase().contains('format')) {
          errorType = 'codec_incompatible';
        } else if (error.toLowerCase().contains('network') ||
                   error.toLowerCase().contains('connection')) {
          errorType = 'network';
        } else if (error.toLowerCase().contains('timeout')) {
          errorType = 'timeout';
        }
      }

      if (mounted) {
        setState(() {
          _hasError = true;
          _isInitialized = false;
          _errorType = errorType;
        });
      }
    }
  }

  @override
  void dispose() {
    _videoPlayerController?.removeListener(_videoErrorListener);
    _videoPlayerController?.dispose();
    // Don't empty cache on dispose as it might be used by other instances
    super.dispose();
  }

  IconData _getErrorIcon() {
    switch (_errorType) {
      case 'codec_incompatible':
        return Icons.video_settings;
      case 'network':
        return Icons.wifi_off;
      case 'timeout':
        return Icons.schedule;
      default:
        return Icons.error;
    }
  }

  String _getErrorMessage() {
    switch (_errorType) {
      case 'codec_incompatible':
        return 'widgets_custom_video_player_codec_incompatible'.tr();
      case 'network':
        return 'widgets_custom_video_player_network_error'.tr();
      case 'timeout':
        return 'widgets_custom_video_player_timeout'.tr();
      default:
        return 'widgets_custom_video_player_playback_error'.tr();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (_hasError || !_isInitialized || _videoPlayerController == null) {
            // Show placeholder image when video fails to load
            return Stack(
              children: [
                Image.asset(
                  widget.placeholderAsset,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(Icons.error, color: Colors.grey),
                      ),
                    );
                  },
                ),
                if (_hasError)
                  Positioned(
                    bottom: 8,
                    left: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha(180),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.orange.withAlpha(150), width: 1),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _getErrorIcon(),
                            color: Colors.orange,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              _getErrorMessage(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          } else {
            // Show video player
            return ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: AspectRatio(
                aspectRatio: _videoPlayerController!.value.aspectRatio,
                child: video_player.VideoPlayer(_videoPlayerController!),
              ),
            );
          }
        } else {
          // Show loading state with placeholder
          return Stack(
            children: [
              Image.asset(
                widget.placeholderAsset,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(Icons.error, color: Colors.grey),
                    ),
                  );
                },
              ),
              const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
