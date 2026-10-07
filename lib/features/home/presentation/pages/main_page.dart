import 'package:kastelli/core/theme/app_colors.dart';

import 'package:kastelli/features/home/presentation/pages/home_page.dart';
import 'package:kastelli/features/home/presentation/providers/navigation_provider.dart';
import 'package:kastelli/features/cart/presentation/pages/cart_page.dart';
import 'package:kastelli/features/wishlist/presentation/pages/wishlist_page.dart';
import 'package:kastelli/features/profile/presentation/pages/profile_page.dart';
import 'package:kastelli/features/search/presentation/pages/search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  static const String routeName = '/main';

  static const int homeTab = 0;
  static const int searchTab = 1;
  static const int cartTab = 2;
  static const int wishlistTab = 3;
  static const int profileTab = 4;

  static void openTab(BuildContext context, int index) {
    Navigator.of(context).popUntil(
      (route) => route.settings.name == routeName || route.isFirst,
    );
    context.read<NavigationProvider>().changeTab(index);
  }

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late final NavigationProvider _navigation;
  late final PageController _pageController;

  final Color barBackgroundColor = AppColors.bottomBar;
  final Color iconInactiveColor = AppColors.bottomBarIconInactive;

  @override
  void initState() {
    super.initState();
    _navigation = context.read<NavigationProvider>();
    _pageController = PageController(initialPage: _navigation.currentTab);
    _navigation.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    _navigation.removeListener(_onTabChanged);
    _pageController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_pageController.hasClients) {
      _pageController.jumpToPage(_navigation.currentTab);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color appBackgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final currentTab = context.watch<NavigationProvider>().currentTab;

    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: const [
          HomePage(),
          SearchPage(),
          CartPage(),
          WishlistPage(),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: Container(
        height: 85.h,
        decoration: BoxDecoration(
          color: barBackgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.r),
            topRight: Radius.circular(30.r),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(
                0, Icons.home_outlined, appBackgroundColor, currentTab),
            _buildNavItem(1, Icons.search, appBackgroundColor, currentTab),
            _buildNavItem(2, Icons.shopping_cart_outlined, appBackgroundColor,
                currentTab),
            _buildNavItem(
                3, Icons.favorite_border, appBackgroundColor, currentTab),
            _buildNavItem(
                4, Icons.person_outline, appBackgroundColor, currentTab),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
      int index, IconData icon, Color bgColor, int currentTab) {
    bool isActive = currentTab == index;

    return GestureDetector(
      onTap: () => context.read<NavigationProvider>().changeTab(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 60.w,
        height: 85.h,
        child: isActive
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 6.w,
                    height: 8.h,
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(5.r),
                        bottomRight: Radius.circular(5.r),
                      ),
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Container(
                    width: 50.w,
                    height: 50.h,
                    decoration: const BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      color: barBackgroundColor,
                      size: 28.sp,
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    color: iconInactiveColor,
                    size: 28.sp,
                  ),
                ],
              ),
      ),
    );
  }
}
