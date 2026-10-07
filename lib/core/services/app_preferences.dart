import 'dart:io';

import 'package:kastelli/core/constants/app_constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  final SharedPreferences _prefs;
  final FlutterSecureStorage _secureStorage;

  String? _cachedToken;

  AppPreferences(this._prefs, this._secureStorage);

  static const String keyOnboardingCompleted = 'onboarding_completed';
  static const String keyIsAuthenticated = 'is_authenticated';
  static const String keyUserName = 'user_name';
  static const String keyUserEmail = 'user_email';
  static const String keyUserPhoto = 'user_photo';
  static const String keyIsUserHaveDiscount = 'have_discount';
  static const String keyCartDiscount = 'cart_discount';

  dynamic get(String key) => _prefs.get(key);

  Future<bool> setValue(String key, dynamic value) async {
    if (value is String) return await _prefs.setString(key, value);
    if (value is int) return await _prefs.setInt(key, value);
    if (value is bool) return await _prefs.setBool(key, value);
    if (value is double) return await _prefs.setDouble(key, value);
    if (value is List<String>) return await _prefs.setStringList(key, value);
    return false;
  }

  Future<bool> remove(String key) => _prefs.remove(key);

  Future<bool> clear() => _prefs.clear();

  Future<void> loadToken() async {
    String? token = await _secureStorage.read(key: AppConstants.authTokenKey);

    if (token == null || token.isEmpty) {
      final legacyToken = _prefs.getString(AppConstants.authTokenKey);
      if (legacyToken != null && legacyToken.isNotEmpty) {
        await _secureStorage.write(
          key: AppConstants.authTokenKey,
          value: legacyToken,
        );
        await _prefs.remove(AppConstants.authTokenKey);
        token = legacyToken;
      }
    }

    _cachedToken = token;
  }

  String? getToken() => _cachedToken;

  Future<void> setToken(String token) async {
    _cachedToken = token;
    await _secureStorage.write(key: AppConstants.authTokenKey, value: token);
  }

  bool isOnboardingCompleted() =>
      _prefs.getBool(keyOnboardingCompleted) ?? false;
  Future<bool> setOnboardingCompleted(bool value) =>
      _prefs.setBool(keyOnboardingCompleted, value);

  bool isAuthenticated() => _prefs.getBool(keyIsAuthenticated) ?? false;
  Future<bool> setAuthenticated(bool value) =>
      _prefs.setBool(keyIsAuthenticated, value);

  String getUserName() => _prefs.getString(keyUserName) ?? '';
  Future<bool> setUserName(String name) => _prefs.setString(keyUserName, name);

  String getUserEmail() => _prefs.getString(keyUserEmail) ?? '';
  Future<bool> setUserEmail(String email) =>
      _prefs.setString(keyUserEmail, email);

  String getUserPhoto() => _prefs.getString(keyUserPhoto) ?? '';
  Future<bool> setUserPhoto(String path) =>
      _prefs.setString(keyUserPhoto, path);

  Future<void> clearUserPhoto() async {
    final path = getUserPhoto();
    if (path.isNotEmpty) {
      final file = File(path);
      if (await file.exists()) await file.delete();
    }
    await remove(keyUserPhoto);
  }

  bool userHaveDicount() => _prefs.getBool(keyIsUserHaveDiscount) ?? false;
  double getCartDiscount() => _prefs.getDouble(keyCartDiscount) ?? 0.0;
  Future<bool> setUserHavingDiscount(bool haveDiscount) =>
      _prefs.setBool(keyIsUserHaveDiscount, haveDiscount);
  Future<bool> setDiscount(double discount) =>
      setValue(keyCartDiscount, discount);

  Future<void> logout() async {
    _cachedToken = null;
    await _secureStorage.delete(key: AppConstants.authTokenKey);
    await remove(keyIsAuthenticated);
    await remove(keyUserName);
    await remove(keyUserEmail);
    await clearUserPhoto();
  }
}
