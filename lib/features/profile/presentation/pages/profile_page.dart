import 'package:kastelli/core/shared/widgets/cart_icon_button.dart';
import 'package:kastelli/core/theme/app_colors.dart';
import 'package:kastelli/core/constants/app_strings.dart';
import 'package:kastelli/core/shared/widgets/user_avatar.dart';
import 'package:kastelli/features/auth/presentation/providers/user_provider.dart';
import 'package:kastelli/core/shared/widgets/app_drawer.dart';
import 'package:kastelli/features/auth/presentation/widgets/sign_out_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  void _showPhotoOptions(BuildContext context) {
    final hasPhoto = context.read<UserProvider>().profileImage.isNotEmpty;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text(AppStrings.takePhoto),
              onTap: () {
                Navigator.pop(sheetContext);
                _pickPhoto(context, ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text(AppStrings.chooseFromGallery),
              onTap: () {
                Navigator.pop(sheetContext);
                _pickPhoto(context, ImageSource.gallery);
              },
            ),
            if (hasPhoto)
              ListTile(
                leading:
                    const Icon(Icons.delete_outline, color: AppColors.danger),
                title: const Text(
                  AppStrings.removePhoto,
                  style: TextStyle(color: AppColors.danger),
                ),
                onTap: () {
                  Navigator.pop(sheetContext);
                  context.read<UserProvider>().removePhoto();
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickPhoto(BuildContext context, ImageSource source) async {
    try {
      final picked = await ImagePicker().pickImage(
        source: source,
        maxWidth: 512,
        imageQuality: 85,
      );
      if (picked == null) return;

      final dir = await getApplicationDocumentsDirectory();
      final newPath = p.join(
        dir.path,
        'user_photo_${DateTime.now().millisecondsSinceEpoch}${p.extension(picked.path)}',
      );
      await picked.saveTo(newPath);

      if (!context.mounted) return;
      await context.read<UserProvider>().updateUserData(imagePath: newPath);
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.photoFailed)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>();

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: Center(
          child: Text(
            AppStrings.myProfile,
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
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(30.w, 50.h, 23.w, 24.h),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => _showPhotoOptions(context),
                  child: UserAvatar(radius: 40.r),
                ),
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
                const Spacer(),
                IconButton(
                  tooltip: AppStrings.changePhoto,
                  onPressed: () => _showPhotoOptions(context),
                  icon: Icon(
                    Icons.edit_outlined,
                    color: AppColors.textLight,
                    size: 24.sp,
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(12.w),
            margin: EdgeInsets.only(left: 30.w),
            height: 55.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(11.r),
              border: Border(
                top: BorderSide(color: AppColors.black, width: 0.4),
                bottom: BorderSide(color: AppColors.black, width: 0.4),
                left: BorderSide(color: AppColors.black, width: 0.4),
              ),
            ),
            child: Row(
              children: [
                Image.asset("assets/img/server (2).png"),
                SizedBox(width: 8.w),
                Text(
                  AppStrings.myOrders,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.textLight,
                    size: 24.sp,
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.all(12.w),
            margin: EdgeInsets.only(left: 30.w),
            height: 55.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(11.r),
              border: Border(
                top: BorderSide(color: AppColors.black, width: 0.4),
                bottom: BorderSide(color: AppColors.black, width: 0.4),
                left: BorderSide(color: AppColors.black, width: 0.4),
              ),
            ),
            child: Row(
              children: [
                Image.asset("assets/img/credit-card.png"),
                SizedBox(width: 8.w),
                Text(
                  AppStrings.paymentMethod,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.textLight,
                    size: 24.sp,
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.all(12.w),
            margin: EdgeInsets.only(left: 30.w),
            height: 55.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(11.r),
              border: Border(
                top: BorderSide(color: AppColors.black, width: 0.4),
                bottom: BorderSide(color: AppColors.black, width: 0.4),
                left: BorderSide(color: AppColors.black, width: 0.4),
              ),
            ),
            child: Row(
              children: [
                Image.asset("assets/img/map-pin.png"),
                SizedBox(width: 8.w),
                Text(
                  AppStrings.deliveryAddress,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.textLight,
                    size: 24.sp,
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.all(12.w),
            margin: EdgeInsets.only(left: 30.w),
            height: 55.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(11.r),
              border: Border(
                top: BorderSide(color: AppColors.black, width: 0.4),
                bottom: BorderSide(color: AppColors.black, width: 0.4),
                left: BorderSide(color: AppColors.black, width: 0.4),
              ),
            ),
            child: Row(
              children: [
                Image.asset("assets/img/gift.png"),
                SizedBox(width: 8.w),
                Text(
                  AppStrings.promoCodes,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.textLight,
                    size: 24.sp,
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 16.h),
          GestureDetector(
            onTap: () {
              showSignOutDialog(context);
            },
            child: Container(
              padding: EdgeInsets.all(12.w),
              margin: EdgeInsets.only(left: 30.w),
              height: 55.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(11.r),
                border: Border(
                  top: BorderSide(color: AppColors.black, width: 0.4),
                  bottom: BorderSide(color: AppColors.black, width: 0.4),
                  left: BorderSide(color: AppColors.black, width: 0.4),
                ),
              ),
              child: Row(
                children: [
                  Image.asset("assets/img/log-out.png"),
                  SizedBox(width: 8.w),
                  Text(
                    AppStrings.signOut,
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      showSignOutDialog(context);
                    },
                    icon: Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.textLight,
                      size: 24.sp,
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}
