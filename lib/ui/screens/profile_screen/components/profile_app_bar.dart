import 'package:enzer_app/core/theme/app_colors.dart';
import 'package:enzer_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  final BuildContext context;
  const ProfileAppBar({super.key, required this.context});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      surfaceTintColor: AppColors.white,
      elevation: 0,
      centerTitle: true,
      title: Text(
        'Profile',
        style: AppTextStyles.h5Bold.copyWith(color: AppColors.black),
      ),
    );
  }
}
