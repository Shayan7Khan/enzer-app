// ignore_for_file: prefer_typing_uninitialized_variables, strict_top_level_inference
import 'package:enzer_app/core/theme/app_colors.dart';
import 'package:enzer_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatelessWidget {
  final controller;
  final bool? obscure;
  final String? errorText;
  final String? hintText;
  final bool? enabled;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final validator;
  final double? fontSize;
  final String? label;
  final onSaved;
  final onTap;
  final bool disableBorder;
  final onChanged;
  final onFieldSubmitted;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;

  const CustomTextField({
    super.key,
    this.controller,
    this.onTap,
    this.disableBorder = false,
    this.label,
    this.obscure = false,
    this.enabled = true,
    this.validator,
    this.errorText,
    this.fontSize = 15.0,
    this.hintText,
    this.onSaved,
    this.suffixIcon,
    this.prefixIcon,
    this.onChanged,
    this.onFieldSubmitted,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      onTap: onTap,
      onSaved: onSaved,
      onFieldSubmitted: onFieldSubmitted,
      enabled: enabled,
      controller: controller,
      obscureText: obscure!,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      inputFormatters: inputFormatters,
      focusNode: focusNode,
      cursorColor: AppColors.black,
      style: TextStyle(
        fontSize: 16.sp,
        color: AppColors.black,
        fontWeight: FontWeight.w400,
      ),
      validator:
          validator ??
          (value) {
            if (value != null) {
              return errorText;
            } else {
              return null;
            }
          },
      decoration: InputDecoration(
        fillColor: AppColors.white,
        filled: true,
        prefixIconConstraints: const BoxConstraints(),
        prefixIcon: prefixIcon != null
            ? Padding(
                padding: EdgeInsets.only(left: 10.0.w, right: 10.0.w),
                child: prefixIcon,
              )
            : null,
        suffixIcon: Padding(
          padding: const EdgeInsets.only(),
          child: suffixIcon ?? const SizedBox.shrink(),
        ),
        suffixIconConstraints: BoxConstraints(maxHeight: 40.h, maxWidth: 50.w),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.0.r),
          borderSide: BorderSide(width: 1.0.w),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: disableBorder ? Colors.transparent : AppColors.gray300,
          ),
          borderRadius: BorderRadius.circular(14.0.r),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: disableBorder ? Colors.transparent : AppColors.gray300,
          ),
          borderRadius: BorderRadius.circular(14.0.r),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: disableBorder ? Colors.transparent : AppColors.gray300,
          ),
          borderRadius: BorderRadius.circular(14.0.r),
        ),
        contentPadding: EdgeInsets.only(left: 21.0.w),
        hintText: hintText,
        hintStyle: AppTextStyles.paragraphLargeRegular.copyWith(
          fontSize: 14.sp,
          color: const Color(0xFF7E7E91),
        ),
      ),
    );
  }
}
