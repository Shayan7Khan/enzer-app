import 'package:enzer_app/core/constants/image_path.dart';
import 'package:enzer_app/core/theme/app_colors.dart';
import 'package:enzer_app/core/theme/app_theme.dart';
import 'package:enzer_app/ui/custom_widgets/custom_elevated_button.dart';
import 'package:enzer_app/ui/screens/about_screen/about_screen_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AboutScreenViewModel(),
      child: Consumer<AboutScreenViewModel>(
        builder: (context, model, child) => Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.white, AppColors.primary50],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: AppColors.backgroundColor,
              surfaceTintColor: AppColors.backgroundColor,
              elevation: 0,
              centerTitle: true,
              title: Text(
                'About App',
                style: AppTextStyles.h5Bold.copyWith(color: AppColors.black),
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        16.verticalSpace,
                        _HeroCard(),
                        28.verticalSpace,
                        _LogoSection(),
                        16.verticalSpace,
                        _DescriptionText(),
                        28.verticalSpace,
                        Text(
                          'Our Core Values',
                          style: AppTextStyles.h4SemiBold.copyWith(
                            color: AppColors.black,
                            fontSize: 24.sp,
                          ),
                        ),
                        16.verticalSpace,
                        _CoreValueCard(
                          svgPath: shariahCompliantLogo,
                          title: 'Shariah Compliant',
                          subtitle: 'Ethical Financial solution',
                        ),
                        12.verticalSpace,
                        _CoreValueCard(
                          svgPath: noHiddenChargesLogo,
                          title: 'No Hidden Charges',
                          subtitle: 'Transparent pricing always',
                        ),
                        12.verticalSpace,
                        _CoreValueCard(
                          svgPath: installmentLogo,
                          title: 'Flexible Instalment',
                          subtitle: 'Split payments your way',
                        ),
                        30.verticalSpace,
                        _BottomButton(model: model),
                        30.verticalSpace,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 343.w,
      height: 213.h,
      decoration: BoxDecoration(
        color: const Color(0xFFF3E8FF),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Center(
        child: SvgPicture.asset(
          aboutScreenImage,
          height: 350.h,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class _LogoSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SvgPicture.asset(
        aboutEnzerLogo,
        height: 70.h,
        fit: BoxFit.contain,
      ),
    );
  }
}

class _DescriptionText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: AppTextStyles.paragraphLargeMedium.copyWith(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
        ),
        children: [
          TextSpan(
            text:
                'Enzer makes shopping effortless — get what you need today and pay comfortably over time with flexible, ',
          ),
          TextSpan(
            text: 'Shariah-compliant instalments',
            style: AppTextStyles.paragraphLargeMedium.copyWith(
              color: AppColors.primary,
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              height: 1.6,
            ),
          ),
          const TextSpan(text: ' and zero hidden charges.'),
        ],
      ),
    );
  }
}

class _CoreValueCard extends StatelessWidget {
  final String svgPath;
  final String title;
  final String subtitle;

  const _CoreValueCard({
    required this.svgPath,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFEEEEEE)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50.r,
            height: 50.r,
            decoration: BoxDecoration(
              color: AppColors.primary50,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Padding(
              padding: EdgeInsets.all(10.r),
              child: SvgPicture.asset(svgPath, fit: BoxFit.contain),
            ),
          ),
          16.horizontalSpace,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.gray800,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              4.verticalSpace,
              Text(
                subtitle,
                style: AppTextStyles.paragraphSmallRegular.copyWith(
                  color: AppColors.gray500,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BottomButton extends StatelessWidget {
  final AboutScreenViewModel model;

  const _BottomButton({required this.model});
  @override
  Widget build(BuildContext context) {
    return CustomElevatedButton(
      text: 'Want to learn more ',
      onPressed: model.onWantToLearnMorePressed,
    );
  }
}
