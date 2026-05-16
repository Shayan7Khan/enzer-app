import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.white,

      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        primaryContainer: AppColors.primary100,
        secondary: AppColors.secondary,
        secondaryContainer: AppColors.secondary100,
        surface: AppColors.white,
        onPrimary: AppColors.white,
        onSecondary: AppColors.white,
        onSurface: AppColors.gray900,
      ),

      textTheme: TextTheme(
        displayLarge: AppTextStyles.headingLarge,
        displayMedium: AppTextStyles.headingMedium,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        labelMedium: AppTextStyles.labelMedium,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          textStyle: AppTextStyles.labelMedium,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      ),
    );
  }
}

class AppTextStyles {
  AppTextStyles._();

  //Futura
  static TextStyle futura = TextStyle(
    fontFamily: 'Futura',
    fontSize: 28.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.black,
    height: 1.35,
  );

  //Display
  static TextStyle displayLargeRegular = GoogleFonts.inter(
    fontSize: 48.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
    height: 1.2,
  );
  static TextStyle displayLargeMedium = GoogleFonts.inter(
    fontSize: 48.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.black,
    height: 1.2,
  );
  static TextStyle displayLargeSemiBold = GoogleFonts.inter(
    fontSize: 48.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
    height: 1.2,
  );
  static TextStyle displayLargeBold = GoogleFonts.inter(
    fontSize: 48.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.black,
    height: 1.2,
  );

  static TextStyle displaySmallRegular = GoogleFonts.inter(
    fontSize: 32.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
    height: 1.2,
  );
  static TextStyle displaySmallMedium = GoogleFonts.inter(
    fontSize: 32.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.black,
    height: 1.2,
  );
  static TextStyle displaySmallSemiBold = GoogleFonts.inter(
    fontSize: 32.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
    height: 1.2,
  );
  static TextStyle displaySmallBold = GoogleFonts.inter(
    fontSize: 32.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.black,
    height: 1.2,
  );

  //H1
  static TextStyle h1Regular = GoogleFonts.inter(
    fontSize: 40.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
    height: 1.25,
  );
  static TextStyle h1Medium = GoogleFonts.inter(
    fontSize: 40.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.black,
    height: 1.25,
  );
  static TextStyle h1SemiBold = GoogleFonts.inter(
    fontSize: 40.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
    height: 1.25,
  );
  static TextStyle h1Bold = GoogleFonts.inter(
    fontSize: 40.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.black,
    height: 1.25,
  );

  //H2
  static TextStyle h2Regular = GoogleFonts.inter(
    fontSize: 36.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
    height: 1.25,
  );
  static TextStyle h2Medium = GoogleFonts.inter(
    fontSize: 36.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.black,
    height: 1.25,
  );
  static TextStyle h2SemiBold = GoogleFonts.inter(
    fontSize: 36.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
    height: 1.25,
  );
  static TextStyle h2Bold = GoogleFonts.inter(
    fontSize: 36.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.black,
    height: 1.25,
  );

  //  H3
  static TextStyle h3Regular = GoogleFonts.inter(
    fontSize: 32.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
    height: 1.3,
  );
  static TextStyle h3Medium = GoogleFonts.inter(
    fontSize: 32.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.black,
    height: 1.3,
  );
  static TextStyle h3SemiBold = GoogleFonts.inter(
    fontSize: 32.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
    height: 1.3,
  );
  static TextStyle h3Bold = GoogleFonts.inter(
    fontSize: 32.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.black,
    height: 1.3,
  );

  //  H4
  static TextStyle h4Regular = GoogleFonts.inter(
    fontSize: 28.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
    height: 1.3,
  );
  static TextStyle h4Medium = GoogleFonts.inter(
    fontSize: 28.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.black,
    height: 1.3,
  );
  static TextStyle h4SemiBold = GoogleFonts.inter(
    fontSize: 28.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
    height: 1.3,
  );
  static TextStyle h4Bold = GoogleFonts.inter(
    fontSize: 28.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.black,
    height: 1.3,
  );

  //  H5
  static TextStyle h5Regular = GoogleFonts.inter(
    fontSize: 24.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
    height: 1.35,
  );
  static TextStyle h5Medium = GoogleFonts.inter(
    fontSize: 24.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.black,
    height: 1.35,
  );
  static TextStyle h5SemiBold = GoogleFonts.inter(
    fontSize: 24.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
    height: 1.35,
  );
  static TextStyle h5Bold = GoogleFonts.inter(
    fontSize: 24.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.black,
    height: 1.35,
  );

  //  H6
  static TextStyle h6Regular = GoogleFonts.inter(
    fontSize: 20.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
    height: 1.35,
  );
  static TextStyle h6Medium = GoogleFonts.inter(
    fontSize: 20.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.black,
    height: 1.35,
  );
  static TextStyle h6SemiBold = GoogleFonts.inter(
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
    height: 1.35,
  );
  static TextStyle h6Bold = GoogleFonts.inter(
    fontSize: 20.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.black,
    height: 1.35,
  );

  //  Body
  static TextStyle bodyLargeRegular = GoogleFonts.inter(
    fontSize: 20.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
    height: 1.5,
  );
  static TextStyle bodyLargeMedium = GoogleFonts.inter(
    fontSize: 20.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.black,
    height: 1.5,
  );
  static TextStyle bodyLargeSemiBold = GoogleFonts.inter(
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
    height: 1.5,
  );
  static TextStyle bodyLargeBold = GoogleFonts.inter(
    fontSize: 20.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.black,
    height: 1.5,
  );

  static TextStyle bodyMediumRegular = GoogleFonts.inter(
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
    height: 1.5,
  );
  static TextStyle bodyMediumMedium = GoogleFonts.inter(
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.black,
    height: 1.5,
  );
  static TextStyle bodyMediumSemiBold = GoogleFonts.inter(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
    height: 1.5,
  );
  static TextStyle bodyMediumBold = GoogleFonts.inter(
    fontSize: 16.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.black,
    height: 1.5,
  );

  static TextStyle bodySmallRegular = GoogleFonts.inter(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
    height: 1.5,
  );
  static TextStyle bodySmallMedium = GoogleFonts.inter(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.black,
    height: 1.5,
  );
  static TextStyle bodySmallSemiBold = GoogleFonts.inter(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
    height: 1.5,
  );
  static TextStyle bodySmallBold = GoogleFonts.inter(
    fontSize: 14.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.black,
    height: 1.5,
  );

  //  Paragraph
  static TextStyle paragraphLargeRegular = GoogleFonts.inter(
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
    height: 1.6,
  );
  static TextStyle paragraphLargeMedium = GoogleFonts.inter(
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.black,
    height: 1.6,
  );
  static TextStyle paragraphLargeSemiBold = GoogleFonts.inter(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
    height: 1.6,
  );
  static TextStyle paragraphLargeBold = GoogleFonts.inter(
    fontSize: 16.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.black,
    height: 1.6,
  );

  static TextStyle paragraphSmallRegular = GoogleFonts.inter(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
    height: 1.6,
  );
  static TextStyle paragraphSmallMedium = GoogleFonts.inter(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.black,
    height: 1.6,
  );
  static TextStyle paragraphSmallSemiBold = GoogleFonts.inter(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
    height: 1.6,
  );
  static TextStyle paragraphSmallBold = GoogleFonts.inter(
    fontSize: 14.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.black,
    height: 1.6,
  );

  //  Caption
  static TextStyle captionLargeRegular = GoogleFonts.inter(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
    height: 1.4,
  );
  static TextStyle captionLargeMedium = GoogleFonts.inter(
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.black,
    height: 1.4,
  );
  static TextStyle captionLargeSemiBold = GoogleFonts.inter(
    fontSize: 12.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
    height: 1.4,
  );
  static TextStyle captionLargeBold = GoogleFonts.inter(
    fontSize: 12.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.black,
    height: 1.4,
  );

  static TextStyle captionSmallRegular = GoogleFonts.inter(
    fontSize: 10.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
    height: 1.4,
  );
  static TextStyle captionSmallMedium = GoogleFonts.inter(
    fontSize: 10.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.black,
    height: 1.4,
  );
  static TextStyle captionSmallSemiBold = GoogleFonts.inter(
    fontSize: 10.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
    height: 1.4,
  );
  static TextStyle captionSmallBold = GoogleFonts.inter(
    fontSize: 10.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.black,
    height: 1.4,
  );

  //  Label (buttons / inputs)
  static TextStyle labelLarge = GoogleFonts.inter(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
    height: 1.0,
  );
  static TextStyle labelMedium = GoogleFonts.inter(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
    height: 1.0,
  );
  static TextStyle labelSmall = GoogleFonts.inter(
    fontSize: 12.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
    height: 1.0,
  );

  // Legacy aliases — keeps existing usages from breaking
  static TextStyle get headingLarge => h3Bold;
  static TextStyle get headingMedium => h5Bold;
  static TextStyle get bodyLarge => bodyLargeRegular;
  static TextStyle get bodyMedium => bodyMediumRegular;
  static TextStyle get bodySmall => bodySmallRegular;
}
