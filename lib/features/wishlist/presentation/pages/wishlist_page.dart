import 'package:kastelli/core/shared/widgets/cart_icon_button.dart';
import 'package:kastelli/core/theme/app_colors.dart';
import 'package:kastelli/core/constants/app_strings.dart';
import 'package:kastelli/core/shared/widgets/app_drawer.dart';
import 'package:kastelli/features/wishlist/presentation/widgets/wishlist_item_card.dart';
import 'package:kastelli/features/wishlist/presentation/providers/wishlist_provider.dart'
    show WishlistProvider;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    final wishlist = context.watch<WishlistProvider>();
    final savedProducts = wishlist.items;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: Center(
          child: Text(
            AppStrings.wishlist,
            style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold),
          ),
        ),
        actions: [const CartIconButton()],
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: Image.asset(
                "assets/img/Burger@2x.png",
                width: 25.w,
                height: 12.h,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: const AppDrawer(),
      body: wishlist.isLoading && savedProducts.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : savedProducts.isEmpty
              ? Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.favorite_border,
                          size: 56.sp,
                          color: AppColors.accent,
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          AppStrings.wishlistEmpty,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  scrollDirection: Axis.vertical,
                  itemCount: savedProducts.length,
                  separatorBuilder: (context, index) => SizedBox(height: 16.h),
                  itemBuilder: (context, index) {
                    return WishlistItemCard(product: savedProducts[index]);
                  },
                ),
    );
  }
}
