import 'package:kastelli/core/theme/app_colors.dart';
import 'package:kastelli/core/constants/app_strings.dart';
import 'package:kastelli/core/shared/widgets/user_avatar.dart';
import 'package:kastelli/features/auth/presentation/providers/user_provider.dart';
import 'package:kastelli/features/products/presentation/pages/products_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>();

    return RepaintBoundary(
      child: Drawer(
        backgroundColor: AppColors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(15.w, 100.h, 0, 19.h),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: AppColors.greyLight,
                        width: 1.0,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      UserAvatar(radius: 35.r),
                      SizedBox(width: 15.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            user.userName,
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textHeading,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            user.email,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.textLight,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                ListTile(
                  title: const Text(AppStrings.categories),
                  leading: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.pop(context);
                    Future<void>.delayed(const Duration(milliseconds: 250), () {
                      if (context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProductsPage(
                              categoryId: 6355,
                              title: AppStrings.dresses,
                            ),
                          ),
                        );
                      }
                    });
                  },
                ),
                ListTile(
                  title: const Text(AppStrings.sale),
                  leading: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.pop(context);
                    Future<void>.delayed(const Duration(milliseconds: 250), () {
                      if (context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProductsPage(
                              categoryId: 7853,
                              title: AppStrings.sale,
                            ),
                          ),
                        );
                      }
                    });
                  },
                ),
                ListTile(
                  title: const Text(AppStrings.bestSellers),
                  leading: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.pop(context);
                    Future<void>.delayed(const Duration(milliseconds: 250), () {
                      if (context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProductsPage(
                              categoryId: 7611,
                              title: AppStrings.mostPopular,
                            ),
                          ),
                        );
                      }
                    });
                  },
                ),
                ListTile(
                  title: const Text(AppStrings.featuredProducts),
                  leading: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.pop(context);
                    Future<void>.delayed(const Duration(milliseconds: 250), () {
                      if (context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProductsPage(
                              categoryId: 8265,
                              title: AppStrings.eidCollection,
                            ),
                          ),
                        );
                      }
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
