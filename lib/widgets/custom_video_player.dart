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
  late video_player.VideoPlayerController _videoPlayerController;
  Future<void>? _initializeVideoPlayerFuture;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayerFuture = _loadAndInitializeVideo();
  }

  Future<void> _loadAndInitializeVideo() async {
    try {
      FileInfo? fileInfo = await DefaultCacheManager().getFileFromCache(widget.videoUrl);
      File videoFile;

      if (fileInfo != null && fileInfo.file.existsSync()) {
        videoFile = fileInfo.file;
      } else {
        fileInfo = await DefaultCacheManager().downloadFile(widget.videoUrl);
        videoFile = fileInfo.file;
      }

      _videoPlayerController = video_player.VideoPlayerController.file(videoFile, videoPlayerOptions: video_player.VideoPlayerOptions(mixWithOthers: true));
      await _videoPlayerController.initialize();

      _videoPlayerController.setLooping(true);
      _videoPlayerController.play();
      _videoPlayerController.setVolume(0.0);

      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      setState(() {
        _isInitialized = false;
      });
    }
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    DefaultCacheManager().emptyCache();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError || !_isInitialized) {
            return Image.asset(
              widget.placeholderAsset,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.error);
              },
            );
          } else {
            return AspectRatio(aspectRatio: _videoPlayerController.value.aspectRatio, child: video_player.VideoPlayer(_videoPlayerController));
          }
        } else {
          return Image.asset(widget.placeholderAsset, fit: BoxFit.cover);
        }
      },
    );
  }
}
