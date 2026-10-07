import 'package:kastelli/features/onboarding/presentation/pages/splash_page.dart';
import 'package:kastelli/core/di/service_locator.dart';
import 'package:kastelli/core/env_config.dart';
import 'package:kastelli/core/services/app_preferences.dart';
import 'package:kastelli/features/auth/presentation/providers/sign_in_provider.dart';
import 'package:kastelli/features/auth/presentation/providers/sign_up_provider.dart';
import 'package:kastelli/features/auth/presentation/providers/user_provider.dart';
import 'package:kastelli/features/cart/presentation/providers/cart_provider.dart';
import 'package:kastelli/features/home/presentation/providers/home_provider.dart';
import 'package:kastelli/features/home/presentation/providers/navigation_provider.dart';
import 'package:kastelli/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:kastelli/features/products/presentation/providers/product_details_provider.dart';
import 'package:kastelli/features/products/presentation/providers/products_provider.dart';
import 'package:kastelli/features/search/presentation/providers/search_provider.dart';
import 'package:kastelli/features/wishlist/presentation/providers/wishlist_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EnvConfig.init();
  await initDI();
  await sl<AppPreferences>().loadToken();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => WishlistProvider()..loadWishlist(),
            ),
            ChangeNotifierProvider(
              create: (_) => CartProvider()..loadCart(),
            ),
            ChangeNotifierProvider(
              create: (_) => NavigationProvider(),
            ),
            ChangeNotifierProvider(
              create: (_) => UserProvider()..loadUserData(),
            ),
            ChangeNotifierProvider(
              create: (_) => SignInProvider(),
            ),
            ChangeNotifierProvider(
              create: (_) => SignUpProvider(),
            ),
            ChangeNotifierProvider(
              create: (_) => OnboardingProvider(),
            ),
            ChangeNotifierProvider(
              create: (_) => HomeProvider()..loadHome(),
            ),
            ChangeNotifierProvider(
              create: (_) => ProductsProvider(),
            ),
            ChangeNotifierProvider(
              create: (_) => ProductDetailsProvider(),
            ),
            ChangeNotifierProvider(
              create: (_) => SearchProvider(),
            ),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: const SplashPage(),
          ),
        );
      },
    );
  }
}
