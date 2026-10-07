import 'package:kastelli/core/theme/app_colors.dart';
import 'package:kastelli/core/constants/app_strings.dart';
import 'package:kastelli/features/products/presentation/providers/products_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

const List<String> _sortOptions = [
  AppStrings.sortBestMatch,
  AppStrings.sortPriceLowToHigh,
  AppStrings.sortPriceHighToLow,
  AppStrings.sortNewest,
];

Future<void> showSortingDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext dialogContext) {
      final selectedIndex = dialogContext.watch<ProductsProvider>().sortIndex;

      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.r),
        ),
        clipBehavior: Clip.antiAlias,
        child: Container(
          color: AppColors.white,
          width: 290.w,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(_sortOptions.length, (index) {
              final isSelected = selectedIndex == index;

              return InkWell(
                onTap: () {
                  dialogContext.read<ProductsProvider>().changeSort(index);
                  Navigator.of(dialogContext).pop();
                },
                child: Container(
                  height: 51.h,
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  decoration: BoxDecoration(
                    border: index == _sortOptions.length - 1
                        ? null
                        : const Border(
                            bottom: BorderSide(color: AppColors.greyLight),
                          ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _sortOptions[index],
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                      Icon(
                        isSelected
                            ? Icons.radio_button_checked
                            : Icons.radio_button_unchecked,
                        color: isSelected ? AppColors.primary : AppColors.grey,
                        size: 20.sp,
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      );
    },
  );
}
