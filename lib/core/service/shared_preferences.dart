import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SharedPref {
  static FlutterSecureStorage? _prefs;

  static AndroidOptions _getAndroidOptions() => const AndroidOptions(
    encryptedSharedPreferences: true,
  );

  static void _getInstance() => _prefs =  FlutterSecureStorage(aOptions: _getAndroidOptions());

  /// Returns [key] values from [_prefs]
  static Future<String?> get(String key) async {
    _getInstance();
    return _prefs?.read(key: key);
  }

  /// Sets [value] to [key] key in [_prefs]
  static Future<void> set(String key, dynamic value) async {
    _getInstance();
    await _prefs?.write(key: key, value: value);
  }

  /// Remove [key] value from [_prefs]
  static Future<void> remove(String key) async {
    _getInstance();
    _prefs?.delete(key: key);
  }

  /// Clear all data in [_prefs]
  ///
  /// Uses when user logout form current session
  static Future<void> clear() async {
    _getInstance();
    await _prefs?.deleteAll();
  }
}
