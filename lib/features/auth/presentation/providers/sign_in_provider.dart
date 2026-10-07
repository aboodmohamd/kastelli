import 'package:kastelli/core/di/service_locator.dart';
import 'package:kastelli/features/auth/data/repositories/auth_repository.dart';
import 'package:flutter/material.dart';

class SignInProvider extends ChangeNotifier {
  AuthRepository get _authRepository => sl<AuthRepository>();

  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _rememberMe = false;

  bool get isLoading => _isLoading;
  bool get isPasswordVisible => _isPasswordVisible;
  bool get rememberMe => _rememberMe;

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  void toggleRememberMe(bool value) {
    _rememberMe = value;
    notifyListeners();
  }

  Future<void> login({required String email, required String password}) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _authRepository.login(email: email, password: password);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
