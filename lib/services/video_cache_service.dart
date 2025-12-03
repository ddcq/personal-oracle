import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class VideoCacheService {
  final DefaultCacheManager _cacheManager = DefaultCacheManager();

  Future<void> preloadVideo(String url) async {
    if (url.isEmpty) {
      return;
    }

    try {
      debugPrint('Preloading video: $url');
      await _cacheManager.downloadFile(url);
      debugPrint('Video preloaded: $url');
    } catch (e) {
      debugPrint('Error preloading video $url: $e');
    }
  }

  Future<FileInfo?> getFileFromCache(String url) {
    return _cacheManager.getFileFromCache(url);
  }

  Future<void> clearCache() {
    return _cacheManager.emptyCache();
  }
}
