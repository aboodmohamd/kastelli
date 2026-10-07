import 'package:kastelli/core/di/service_locator.dart';
import 'package:kastelli/features/auth/data/repositories/auth_repository.dart';
import 'package:flutter/material.dart';

class SignUpProvider extends ChangeNotifier {
  AuthRepository get _authRepository => sl<AuthRepository>();

  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  bool get isLoading => _isLoading;
  bool get isPasswordVisible => _isPasswordVisible;
  bool get isConfirmPasswordVisible => _isConfirmPasswordVisible;

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    notifyListeners();
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String countryCode,
    required String telephone,
    required String dateOfBirth,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _authRepository.register(
        name: name,
        email: email,
        password: password,
        countryCode: countryCode,
        telephone: telephone,
        dateOfBirth: dateOfBirth,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
