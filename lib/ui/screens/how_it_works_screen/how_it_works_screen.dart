import 'package:enzer_app/core/constants/image_path.dart';
import 'package:enzer_app/core/theme/app_colors.dart';
import 'package:enzer_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/route_manager.dart';
import 'package:timelines_plus/timelines_plus.dart';

class HowItWorksScreen extends StatelessWidget {
  const HowItWorksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
          leading: Padding(
            padding: EdgeInsets.only(left: 20.w),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: AppColors.black,
                size: 26.sp,
              ),
              onPressed: () => Get.back(),
            ),
          ),
          title: Text(
            'How it works',
            style: AppTextStyles.h5SemiBold.copyWith(
              color: AppColors.black,
              fontSize: 24.sp,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _LogoSection(),
              20.verticalSpace,
              _DescriptionText(),
              32.verticalSpace,
              _StepsSection(),
              32.verticalSpace,
            ],
          ),
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
        height: 65.h,
        width: 140.w,
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
          color: AppColors.black,
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          height: 1.6,
        ),
        children: [
          const TextSpan(
            text:
                'Enzer makes shopping effortless — get what you need today and pay comfortably over time with flexible, ',
          ),
          TextSpan(
            text: 'Shariah-compliant installments',
            style: AppTextStyles.bodyMediumSemiBold.copyWith(
              color: AppColors.primary,
              fontSize: 14.sp,
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

class _StepsSection extends StatelessWidget {
  final List<_StepData> steps = const [
    _StepData(
      number: 1,
      title: 'Shop your favorites',
      description:
          'Browse through thousand of brands and add items to your cart. Look the payment logo at checkout',
      badgeLabel: 'Over 100+ Stores',
      svgPath: primaryCardLogo,
      badgeColor: AppColors.primary100,
      badgeTextColor: AppColors.primary,
      useGradient: true,
    ),
    _StepData(
      number: 2,
      title: 'Choose your plan',
      description:
          'Select a flexible payment plan that suits your budget and lifestyle. All our plans are 100% Shariah Compliant and transparent.',
      badgeLabel: 'Shariah Compliant',
      svgPath: greenCardLogo,
      badgeColor: Color(0xFFDFF2DF),
      badgeTextColor: Color(0xFF007300),
    ),
    _StepData(
      number: 3,
      title: 'Pay with no hidden charges',
      description:
          'Enjoy your purchase immediately. Pay in equal monthly instalment with absolutely no hidden fees or surprises.',
      badgeLabel: 'Zero Hidden Fees',
      svgPath: orangeCardLogo,
      badgeColor: Color(0xFFF8E9E9),
      badgeTextColor: Color(0xFFF87171),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return FixedTimeline.tileBuilder(
      theme: TimelineThemeData(
        nodePosition: 0,
        nodeItemOverlap: false,
        color: AppColors.primary,
        connectorTheme: const ConnectorThemeData(
          thickness: 2.0,
          color: AppColors.primary,
        ),
        indicatorTheme: IndicatorThemeData(size: 40.r, position: 0),
      ),
      builder: TimelineTileBuilder.connected(
        connectionDirection: ConnectionDirection.before,
        itemCount: steps.length,
        contentsBuilder: (context, index) {
          final step = steps[index];
          return Padding(
            padding: EdgeInsets.only(left: 24.w, bottom: 32.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.title,
                  style: AppTextStyles.h6Medium.copyWith(
                    color: AppColors.gray800,
                    fontSize: 20.sp,
                  ),
                ),
                10.verticalSpace,
                Text(
                  step.description,
                  style: AppTextStyles.paragraphLargeRegular.copyWith(
                    color: AppColors.gray800,
                    fontSize: 14.sp,
                    height: 1.5,
                  ),
                ),
                14.verticalSpace,
                _StepBadge(step: step),
                if (index != steps.length - 1) 18.verticalSpace,
              ],
            ),
          );
        },
        indicatorBuilder: (context, index) {
          return DotIndicator(
            size: 40.r,
            color: Colors.transparent,
            border: Border.all(color: Colors.transparent),
            child: Container(
              width: 40.r,
              height: 40.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [AppColors.primary, Color(0xFF5B0090)],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topCenter,
                ),
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          );
        },
        connectorBuilder: (context, index, type) => DecoratedLineConnector(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, Color(0xFF5B0090)],
            ),
          ),
          thickness: 3,
        ),
      ),
    );
  }
}

class _StepData {
  final int number;
  final String title;
  final String description;
  final String badgeLabel;
  final String? svgPath;
  final IconData? badgeIcon;
  final Color badgeColor;
  final Color badgeTextColor;
  final bool useGradient;

  const _StepData({
    required this.number,
    required this.title,
    required this.description,
    required this.badgeLabel,
    required this.badgeColor,
    required this.badgeTextColor,
    this.svgPath,
    // ignore: unused_element_parameter
    this.badgeIcon,
    this.useGradient = false,
  });
}

class _StepBadge extends StatelessWidget {
  final _StepData step;
  const _StepBadge({required this.step});

  Widget _wrapGradient(Widget child) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [AppColors.primary, Color(0xFF5B0090)],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(bounds),
      blendMode: BlendMode.srcIn,
      child: child,
    );
  }

  Widget _buildIcon() {
    if (step.svgPath != null) {
      return SvgPicture.asset(
        step.svgPath!,
        width: 20.sp,
        height: 20.sp,
        colorFilter: ColorFilter.mode(
          step.useGradient ? Colors.white : step.badgeTextColor,
          BlendMode.srcIn,
        ),
      );
    }
    return Icon(
      step.badgeIcon,
      color: step.useGradient ? Colors.white : step.badgeTextColor,
      size: 16.sp,
    );
  }

  @override
  Widget build(BuildContext context) {
    final icon = _buildIcon();
    final label = Text(
      step.badgeLabel,
      style: AppTextStyles.bodySmallRegular.copyWith(
        color: step.useGradient ? Colors.white : step.badgeTextColor,
        fontSize: 13.sp,
        fontWeight: FontWeight.w600,
      ),
    );

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: step.badgeColor,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: step.badgeTextColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          step.useGradient ? _wrapGradient(icon) : icon,
          6.horizontalSpace,
          step.useGradient ? _wrapGradient(label) : label,
        ],
      ),
    );
  }
}
