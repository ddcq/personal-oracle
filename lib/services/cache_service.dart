
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  static const String _versionsUrl = 'https://ddcq.github.io/versions.json';
  static const String _cacheVersionsKey = 'cache_versions';

  Map<String, dynamic> _remoteVersions = {};

  Future<void> initialize() async {
    try {
      final response = await http.get(Uri.parse(_versionsUrl)).timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        _remoteVersions = json.decode(response.body) as Map<String, dynamic>;
      } else {
        debugPrint('Failed to fetch versions.json: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Failed to initialize CacheService: $e');
    }
  }

  String? getVersionFor(String path) {
    return _remoteVersions[path];
  }

  Future<void> setVersionFor(String path, String version) async {
    final prefs = await SharedPreferences.getInstance();
    final localVersions = await _getLocalVersions(prefs);
    localVersions[path] = version;
    await _saveLocalVersions(prefs, localVersions);
  }

  Future<void> validateCache() async {
    if (kIsWeb) {
      return;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final localVersions = await _getLocalVersions(prefs);
      final cacheManager = DefaultCacheManager();

      final filesToRemove = <String>[];
      for (var entry in localVersions.entries) {
        final path = entry.key;
        final localVersion = entry.value;
        final remoteVersion = _remoteVersions[path];

        if (remoteVersion == null || remoteVersion != localVersion) {
          filesToRemove.add(path);
        }
      }
      
      // Also check for files no longer in remote versions
      for (var localPath in localVersions.keys) {
        if (!_remoteVersions.containsKey(localPath) && !filesToRemove.contains(localPath)) {
          filesToRemove.add(localPath);
        }
      }

      for (var path in filesToRemove) {
        final fullUrl = 'https://ddcq.github.io$path';
        debugPrint('Removing outdated cache file: $fullUrl');
        await cacheManager.removeFile(fullUrl);
        localVersions.remove(path);
      }

      await _saveLocalVersions(prefs, localVersions);

    } catch (e) {
      debugPrint('Failed to validate cache: $e');
    }
  }

  Future<Map<String, dynamic>> _getLocalVersions(SharedPreferences prefs) async {
    final versionsJson = prefs.getString(_cacheVersionsKey);
    if (versionsJson != null) {
      try {
        return json.decode(versionsJson) as Map<String, dynamic>;
      } catch (e) {
        debugPrint('Could not decode local versions: $e');
        return {};
      }
    }
    return {};
  }

  Future<void> _saveLocalVersions(SharedPreferences prefs, Map<String, dynamic> versions) async {
    await prefs.setString(_cacheVersionsKey, json.encode(versions));
  }
}
