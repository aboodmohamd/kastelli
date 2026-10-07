import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:kastelli/core/services/auth_event_service.dart';
import 'package:kastelli/core/services/app_preferences.dart';
import 'package:kastelli/core/services/network_logger.dart';
import 'package:flutter/foundation.dart';

class AppInterceptors extends Interceptor {
  final AppPreferences appPreferences;
  AppInterceptors({required this.appPreferences, required Dio dio});

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    options.headers['Content-Type'] = 'application/json';
    options.headers['charset'] = 'utf-8';
    options.headers['Accept'] = 'application/json';
    options.headers['x-secret-key'] = 'application/json';
    options.headers['X-Platform'] = Platform.isAndroid ? 'android' : 'ios';
    options.headers['Accept-Language'] = 'en';

    final token = appPreferences.getToken();
    if (token != null && token.isNotEmpty) {
      options.headers["Authorization"] = "Bearer $token";
    }

    NetworkLogger().logRequest(options.method, options.path, options.data);
    super.onRequest(options, handler);
  }

  @override
  Future<void> onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    debugPrint(
      'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
    );

    if (response.statusCode == 401) {
      await _logoutAndRedirect();
      return handler.next(response);
    }

    if (response.data is Map<String, dynamic>) {
      final data = response.data as Map<String, dynamic>;
      if (data.containsKey('status')) {
        final status = data['status'];
        final int error = status['error'] ?? 0;
        final String message = status['message'] ?? '';
        final List<dynamic> errorMessages = status['error_messages'] ?? [];

        if (error == 1) {
          return handler.reject(
            DioException(
              requestOptions: response.requestOptions,
              response: response,
              type: DioExceptionType.badResponse,
              message:
                  errorMessages.isNotEmpty ? errorMessages.join(', ') : message,
            ),
          );
        }
      }
    }

    dynamic logData = response.data;

    if (response.data is String) {
      try {
        final decodedResponse = json.decode(response.data);
        if (kDebugMode) {
          final prettyJson = const JsonEncoder.withIndent(
            '  ',
          ).convert(decodedResponse);
          debugPrint("Response Decoded:\n$prettyJson");
        }
        logData = decodedResponse;
      } catch (e) {
        if (kDebugMode) {
          debugPrint("Failed to decode response: ${response.data}");
        }
      }
    } else if (response.data is Map<String, dynamic>) {
      if (kDebugMode) {
        final prettyJson = const JsonEncoder.withIndent(
          '  ',
        ).convert(response.data);
        debugPrint("Response JSON:\n$prettyJson");
      }
    } else {
      debugPrint("Response Data: ${response.data}");
    }

    NetworkLogger().logResponse(
      response.requestOptions.path,
      response.statusCode ?? 0,
      logData,
    );
    super.onResponse(response, handler);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    debugPrint(
      'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
    );

    NetworkLogger().logError(
      err.requestOptions.path,
      err.response?.statusCode ?? 0,
      err.message ?? 'Unknown Error',
    );

    super.onError(err, handler);
  }

  Future<void> _logoutAndRedirect() async {
    debugPrint("Session expired → emitting unauthenticated event");
    await appPreferences.logout();
    AuthEventService().emit(AuthEvent.unauthenticated);
  }
}
