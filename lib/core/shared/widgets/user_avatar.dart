import 'package:kastelli/core/theme/app_colors.dart';
import 'dart:io';

import 'package:kastelli/features/auth/presentation/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserAvatar extends StatelessWidget {
  final double radius;

  const UserAvatar({super.key, required this.radius});

  @override
  Widget build(BuildContext context) {
    final path = context.watch<UserProvider>().profileImage;
    final file = File(path);
    final hasPhoto = path.isNotEmpty && file.existsSync();

    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.avatarBackground,
      backgroundImage: hasPhoto ? FileImage(file) : null,
    );
  }
}
