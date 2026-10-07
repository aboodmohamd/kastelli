import 'package:kastelli/core/constants/app_strings.dart';
import 'package:kastelli/core/network/api_client.dart';
import 'package:kastelli/core/network/api_endpoints.dart';
import 'package:kastelli/core/network/response_wrapper.dart';
import 'package:kastelli/core/services/app_preferences.dart';
import 'package:kastelli/features/auth/data/models/user_model.dart';

class AuthRepository {
  final ApiConsumer apiConsumer;
  final AppPreferences appPreferences;

  AuthRepository({
    required this.apiConsumer,
    required this.appPreferences,
  });

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final ResponseWrapper response = await apiConsumer.post(
      ApiEndpoints.login,
      body: {
        'email': email,
        'password': password,
      },
    );

    final list = response.data as List;
    if (list.isEmpty) {
      throw Exception(AppStrings.loginFailed);
    }
    final data = list.first as Map<String, dynamic>;

    final token = data['customer_token'] as String?;
    if (token == null || token.isEmpty) {
      throw Exception(AppStrings.invalidCredentials);
    }

    await appPreferences.setToken(token);

    final user = UserModel.fromJson(data);

    await appPreferences.setUserName(user.name);
    await appPreferences.setUserEmail(user.email);
    await appPreferences.setAuthenticated(true);

    return user;
  }

  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required String countryCode,
    required String telephone,
    required String dateOfBirth,
  }) async {
    final ResponseWrapper response = await apiConsumer.post(
      ApiEndpoints.register,
      body: {
        'name': name,
        'email': email,
        'password': password,
        'telephone_extension': countryCode,
        'telephone': telephone,
        'newsletter': 0,
        'date_of_birth': dateOfBirth,
      },
    );

    final list = response.data;
    if (list is! List || list.isEmpty) {
      throw Exception(AppStrings.signUpFailed);
    }
    final data = list.first as Map<String, dynamic>;

    final token = data['customer_token'] as String?;
    if (token == null || token.isEmpty) {
      throw Exception(AppStrings.signUpFailed);
    }

    await appPreferences.setToken(token);
    await appPreferences.setAuthenticated(true);

    final user = UserModel.fromJson(data);

    await appPreferences.setUserName(user.name);
    await appPreferences.setUserEmail(user.email);
    return user;
  }

  Future<void> logout() async {
    try {
      await apiConsumer.post(ApiEndpoints.logout);
    } catch (_) {
    } finally {
      await appPreferences.logout();
    }
  }
}
