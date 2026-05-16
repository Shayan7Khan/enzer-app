import 'package:enzer_app/core/enums/view_state.dart';
import 'package:enzer_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ViewState? state;
  final bool isBold;
  final double letterSpacing;
  final IconData? prefixIcon;

  const CustomElevatedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.state,
    this.isBold = false,
    this.letterSpacing = 0.5,
    this.prefixIcon,
  });

  bool get _isBusy => state == ViewState.busy;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 342.w,
      height: 48.h,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFBF00FF), Color(0xFF5E2C4D)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: ElevatedButton(
          onPressed: _isBusy ? null : onPressed,
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: Colors.transparent,
            disabledBackgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: _isBusy
              ? SizedBox(
                  height: 22.h,
                  width: 22.h,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (prefixIcon != null) ...[
                      Icon(prefixIcon, color: Colors.white, size: 22.sp),
                      10.horizontalSpace,
                    ],
                    Text(
                      text,
                      style: AppTextStyles.labelMedium.copyWith(
                        fontSize: 18.sp,
                        fontWeight: isBold
                            ? FontWeight.bold
                            : FontWeight.normal,
                        letterSpacing: letterSpacing,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
