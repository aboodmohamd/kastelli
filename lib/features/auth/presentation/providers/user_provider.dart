import 'package:kastelli/core/di/service_locator.dart';
import 'package:kastelli/core/services/app_preferences.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  AppPreferences get _prefs => sl<AppPreferences>();

  String _userName = '';
  String _email = '';
  String _profileImage = '';

  String get userName => _userName;
  String get email => _email;
  String get profileImage => _profileImage;

  void loadUserData() {
    _userName = _prefs.getUserName();
    _email = _prefs.getUserEmail();
    _profileImage = _prefs.getUserPhoto();
    notifyListeners();
  }

  Future<void> updateUserData({
    String? name,
    String? email,
    String? imagePath,
  }) async {
    if (name != null) {
      _userName = name;
      await _prefs.setUserName(name);
    }
    if (email != null) {
      _email = email;
      await _prefs.setUserEmail(email);
    }
    if (imagePath != null) {
      await _prefs.clearUserPhoto();
      _profileImage = imagePath;
      await _prefs.setUserPhoto(imagePath);
    }
    notifyListeners();
  }

  Future<void> removePhoto() async {
    await _prefs.clearUserPhoto();
    _profileImage = '';
    notifyListeners();
  }
}
