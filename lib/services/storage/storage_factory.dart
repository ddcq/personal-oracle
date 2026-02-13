import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:oracle_d_asgard/services/storage/storage_adapter.dart';
import 'package:oracle_d_asgard/services/storage/web_storage_adapter.dart';
import 'package:oracle_d_asgard/services/storage/database_storage_adapter.dart';

/// Factory class for creating platform-appropriate storage adapters.
///
/// This factory automatically selects the correct storage implementation
/// based on the current platform:
/// - Web: Uses SharedPreferences via WebStorageAdapter
/// - Mobile/Desktop: Uses SQLite via DatabaseStorageAdapter
class StorageFactory {
  static StorageAdapter? _instance;

  /// Returns a singleton instance of the appropriate storage adapter.
  ///
  /// The adapter is selected based on the platform and cached for
  /// subsequent calls to avoid recreating the adapter.
  static StorageAdapter getAdapter() {
    _instance ??= kIsWeb ? WebStorageAdapter() : DatabaseStorageAdapter();
    return _instance!;
  }

  /// Resets the cached adapter instance.
  ///
  /// This is useful for testing or when you need to force
  /// recreation of the storage adapter.
  static void reset() {
    _instance = null;
  }
}
