import 'package:dio/dio.dart';
import 'package:kastelli/core/database/app_database.dart';
import 'package:kastelli/core/database/database_helper.dart';
import 'package:kastelli/core/network/api_client.dart';
import 'package:kastelli/core/network/app_interceptors.dart';
import 'package:kastelli/core/services/app_preferences.dart';
import 'package:kastelli/features/auth/data/repositories/auth_repository.dart';
import 'package:kastelli/features/home/data/repositories/dashboard_repository.dart';
import 'package:kastelli/features/products/data/repositories/product_details_repository.dart';
import 'package:kastelli/features/products/data/repositories/product_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> initDI() async {
  sl.registerLazySingleton<GlobalKey<NavigatorState>>(
    () => GlobalKey<NavigatorState>(),
  );
  sl.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());
  sl.registerLazySingleton<AppDatabase>(
    () => AppDatabase(sl<DatabaseHelper>(), apiConsumer: sl<ApiConsumer>()),
  );

  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(
    () => const FlutterSecureStorage(),
  );

  sl.registerLazySingleton<AppPreferences>(
    () => AppPreferences(sl(), sl<FlutterSecureStorage>()),
  );

  sl.registerLazySingleton<AppInterceptors>(
    () => AppInterceptors(appPreferences: sl(), dio: sl<Dio>()),
  );
  sl.registerLazySingleton<ApiConsumer>(
    () => ApiClient(dioClient: sl(), interceptors: sl<AppInterceptors>()),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepository(
      apiConsumer: sl<ApiConsumer>(),
      appPreferences: sl<AppPreferences>(),
    ),
  );
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepository(
      apiConsumer: sl<ApiConsumer>(),
    ),
  );
  sl.registerLazySingleton<ProductDetailsRepository>(
    () => ProductDetailsRepository(apiConsumer: sl<ApiConsumer>()),
  );
  sl.registerLazySingleton<DashboardRepository>(
    () => DashboardRepository(apiConsumer: sl<ApiConsumer>()),
  );
}
