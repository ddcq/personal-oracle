import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class VideoPlayerWithCacheAndPingPong extends StatefulWidget {
  final String videoUrl;
  final String placeholderAsset;

  const VideoPlayerWithCacheAndPingPong({
    super.key,
    required this.videoUrl,
    required this.placeholderAsset,
  });

  @override
  State<VideoPlayerWithCacheAndPingPong> createState() => _VideoPlayerWithCacheAndPingPongState();
}

class _VideoPlayerWithCacheAndPingPongState extends State<VideoPlayerWithCacheAndPingPong> {
  late VideoPlayerController _videoPlayerController;
  Future<void>? _initializeVideoPlayerFuture;
  bool _playingForward = true;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayerFuture = _loadAndInitializeVideo();
  }

  Future<void> _loadAndInitializeVideo() async {
    try {
      // 1. Vérifier le cache
      FileInfo? fileInfo = await DefaultCacheManager().getFileFromCache(widget.videoUrl);
      File videoFile;

      if (fileInfo != null && fileInfo.file.existsSync()) {
        // Fichier trouvé en cache
        videoFile = fileInfo.file;
        print('Video loaded from cache: ${videoFile.path}');
      } else {
        // Fichier non trouvé en cache, télécharger
        print('Video not in cache, downloading...');
        fileInfo = await DefaultCacheManager().downloadFile(widget.videoUrl);
        videoFile = fileInfo.file;
        print('Video downloaded to: ${videoFile.path}');
      }

      // 2. Initialiser le contrôleur vidéo
      _videoPlayerController = VideoPlayerController.file(videoFile);
      await _videoPlayerController.initialize();

      // 3. Configurer les listeners pour le ping-pong
      _videoPlayerController.addListener(_pingPongListener);

      // 4. Démarrer la lecture
      _videoPlayerController.setLooping(false); // Géré manuellement
      _videoPlayerController.play();
      _videoPlayerController.setVolume(0.0); // Silencieux par défaut

      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      print('Error loading or initializing video: $e');
      // Gérer l'erreur, par exemple afficher un message à l'utilisateur
      setState(() {
        _isInitialized = false; // Indiquer que l'initialisation a échoué
      });
    }
  }

  void _pingPongListener() {
    if (!_videoPlayerController.value.isInitialized) {
      return;
    }

    final currentPosition = _videoPlayerController.value.position;
    final duration = _videoPlayerController.value.duration;

    if (_playingForward) {
      if (currentPosition >= duration) {
        _playingForward = false;
        _videoPlayerController.seekTo(duration - const Duration(milliseconds: 100)); // Reculer légèrement
        _videoPlayerController.setPlaybackSpeed(-1.0);
      }
    } else {
      if (currentPosition <= Duration.zero) {
        _playingForward = true;
        _videoPlayerController.seekTo(const Duration(milliseconds: 100)); // Avancer légèrement
        _videoPlayerController.setPlaybackSpeed(1.0);
      }
    }
  }

  @override
  void dispose() {
    _videoPlayerController.removeListener(_pingPongListener);
    _videoPlayerController.dispose();
    DefaultCacheManager().emptyCache(); // Optionnel: vider le cache à la fermeture
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError || !_isInitialized) {
            // Gérer les erreurs de chargement/initialisation
            return Image.asset(
              widget.placeholderAsset,
              fit: BoxFit.cover,
              // Optionnel: afficher un icône d'erreur sur le placeholder
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
            );
          } else {
            // Afficher la vidéo
            return AspectRatio(
              aspectRatio: _videoPlayerController.value.aspectRatio,
              child: VideoPlayer(_videoPlayerController),
            );
          }
        } else {
          // Afficher le placeholder pendant le chargement
          return Image.asset(
            widget.placeholderAsset,
            fit: BoxFit.cover,
          );
        }
      },
    );
  }
}