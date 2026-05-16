import 'package:enzer_app/core/theme/app_colors.dart';
import 'package:enzer_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResetPasswordAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const ResetPasswordAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      centerTitle: true,
      leading: Padding(
        padding: EdgeInsets.only(left: 24.w),
        child: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.black, size: 24.sp),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      title: Text('Verification', style: AppTextStyles.h6SemiBold),
    );
  }
}
