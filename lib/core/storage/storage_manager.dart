import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';

/// A service class responsible for handling all secure storage operations.
///
/// This class wraps FlutterSecureStorage and provides a clean API
/// for storing, retrieving, and deleting sensitive data like:
/// - Auth tokens
/// - Refresh tokens
/// - User IDs
/// - Emails
/// - Any confidential data
///
/// All methods are asynchronous because secure storage interacts
/// with platform-specific encrypted storage.
@lazySingleton
class StorageManager {
  /// Singleton instance to ensure only one storage handler exists
  static final StorageManager _instance = StorageManager._internal();

  /// Factory constructor to return the same instance
  factory StorageManager() => _instance;

  /// Private constructor
  StorageManager._internal();

  /// Ensures storage is fresh on first install/run by wiping Keychain on iOS.
  static Future<void> ensureStorageFreshness() async {
    final prefs = await SharedPreferences.getInstance();
    const storage = FlutterSecureStorage();
    const flagKey = 'initial_wipe_completed_v1';

    final isWipeCompleted = prefs.getBool(flagKey) ?? false;

    if (!isWipeCompleted) {
      debugPrint('--- FIRST RUN DETECTED: WIPING STORAGE ---');

      // 1. Wipe secure storage
      await storage.deleteAll(aOptions: _androidOptions, iOptions: _iosOptions);

      // 2. Wipe shared preferences (optional but usually desired)
      await prefs.clear();

      // 3. Re-set flag so this runs only once
      await prefs.setBool(flagKey, true);

      debugPrint('--- STORAGE WIPE COMPLETED ---');
    }
  }

  /// Underlying secure storage instance
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  /// Default Android encryption options
  static const AndroidOptions _androidOptions = AndroidOptions();

  /// Default iOS encryption options
  static const IOSOptions _iosOptions = IOSOptions(
    accessibility: KeychainAccessibility.first_unlock,
  );

  /// Writes a value securely.
  ///
  /// [key] Unique identifier for stored value
  /// [value] Data to store securely
  Future<void> write(String key, String value) async {
    await _storage.write(
      key: key,
      value: value,
      aOptions: _androidOptions,
      iOptions: _iosOptions,
    );
  }

  /// Reads a value securely.
  ///
  /// Returns the stored value if found, otherwise null.
  Future<String?> read(String key) async {
    return await _storage.read(
      key: key,
      aOptions: _androidOptions,
      iOptions: _iosOptions,
    );
  }

  /// Deletes a specific key from secure storage.
  Future<void> delete(String key) async {
    await _storage.delete(
      key: key,
      aOptions: _androidOptions,
      iOptions: _iosOptions,
    );
  }

  /// Deletes all stored secure values.
  ///
  /// Useful during logout or account switch.
  Future<void> clearAll() async {
    await _storage.deleteAll(aOptions: _androidOptions, iOptions: _iosOptions);
  }

  /// Checks whether a key exists in secure storage.
  Future<bool> containsKey(String key) async {
    return await _storage.containsKey(
      key: key,
      aOptions: _androidOptions,
      iOptions: _iosOptions,
    );
  }

  /// Reads all stored secure key-value pairs.
  ///
  /// Useful for debugging or migration.
  Future<Map<String, String>> readAll() async {
    return await _storage.readAll(
      aOptions: _androidOptions,
      iOptions: _iosOptions,
    );
  }
}
