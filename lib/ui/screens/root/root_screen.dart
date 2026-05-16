// ignore_for_file: deprecated_member_use

import 'package:enzer_app/core/constants/image_path.dart';
import 'package:enzer_app/core/theme/app_colors.dart';
import 'package:enzer_app/core/theme/app_theme.dart';
import 'package:enzer_app/ui/screens/root/root_screen_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class RootScreen extends StatelessWidget {
  const RootScreen({super.key});

  static const _gradientColors = [AppColors.primary, Color(0xFF5E2C4D)];

  static final _gradient = LinearGradient(
    colors: _gradientColors,
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  Widget build(BuildContext context) {
    return Consumer<RootScreenViewModel>(
      builder: (context, model, child) => PopScope(
        canPop: false,
        onPopInvokedWithResult: (bool didPop, Object? result) async {
          if (didPop) return;
          final exit = await Get.dialog<bool>(
            AlertDialog(
              title: const Text('Caution!'),
              content: const Text(
                'Do you really want to close the application?',
              ),
              actions: [
                TextButton(
                  onPressed: () => Get.back(result: false),
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () => Get.back(result: true),
                  child: const Text('Yes'),
                ),
              ],
            ),
          );
          if (exit == true) Get.back();
        },
        child: Scaffold(
          backgroundColor: AppColors.white,
          body: IndexedStack(
            index: model.selectedScreen,
            children: model.allScreen,
          ),
          bottomNavigationBar: model.isEnableBottomBar
              ? MediaQuery.removePadding(
                  context: context,
                  removeBottom: true,
                  child: Container(
                    height: 65.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(35.r),
                        topRight: Radius.circular(35.r),
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5,
                          offset: Offset(0, -1),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(35.r),
                        topRight: Radius.circular(35.r),
                      ),
                      child: BottomNavigationBar(
                        currentIndex: model.selectedScreen,
                        onTap: model.updatedScreenIndex,
                        type: BottomNavigationBarType.fixed,
                        backgroundColor: Colors.white,
                        elevation: 0,
                        iconSize: 22.h,
                        selectedFontSize: 12.sp,
                        unselectedFontSize: 12.sp,
                        selectedItemColor: AppColors.primary,
                        unselectedItemColor: AppColors.gray700,
                        selectedLabelStyle: AppTextStyles.paragraphLargeRegular
                            .copyWith(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primary,
                            ),
                        unselectedLabelStyle: AppTextStyles
                            .paragraphLargeRegular
                            .copyWith(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.gray700,
                            ),
                        items: [
                          BottomNavigationBarItem(
                            icon: _buildNavIcon(homeLogo, false),
                            activeIcon: _buildNavIcon(homeLogo, true),
                            label: 'Home',
                          ),
                          BottomNavigationBarItem(
                            icon: _buildNavIcon(aboutLogo, false),
                            activeIcon: _buildNavIcon(aboutLogo, true),
                            label: 'About',
                          ),
                          BottomNavigationBarItem(
                            icon: _buildNavIcon(activityLogo, false),
                            activeIcon: _buildNavIcon(activityLogo, true),
                            label: 'Activity',
                          ),
                          BottomNavigationBarItem(
                            icon: _buildNavIcon(profileLogo, false),
                            activeIcon: _buildNavIcon(profileLogo, true),
                            label: 'Profile',
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildNavIcon(String assetPath, bool isSelected) {
    final icon = SvgPicture.asset(
      assetPath,
      height: 22.h,
      fit: BoxFit.contain,
      colorFilter: ColorFilter.mode(
        isSelected ? Colors.black : AppColors.gray700,
        BlendMode.srcIn,
      ),
    );
    if (isSelected) {
      return ShaderMask(
        shaderCallback: (bounds) => _gradient.createShader(bounds),
        blendMode: BlendMode.srcIn,
        child: icon,
      );
    }
    return icon;
  }
}
