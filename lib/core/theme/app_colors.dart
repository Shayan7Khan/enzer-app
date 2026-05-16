import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  //primary colors
  static const Color primary50 = Color(0xFFFCF2FF);
  static const Color primary100 = Color(0xFFF9E5FF);
  static const Color primary200 = Color(0xFFD9D4E8);
  static const Color primary300 = Color(0xFFC5BEDD);
  static const Color primary400 = Color(0xFF9F93C6);
  static const Color primary500 = Color(0xFFBF00FF);
  static const Color primary600 = Color(0xFF322071);
  static const Color primary700 = Color(0xFF2C1C63);
  static const Color primary800 = Color(0xFF261855);
  static const Color primary900 = Color(0xFF191038);

  //secondary colors
  static const Color secondary50 = Color(0xFFFEFAF5);
  static const Color secondary100 = Color(0xFFFDF0E2);
  static const Color secondary200 = Color(0xFFFCE7CF);
  static const Color secondary300 = Color(0xFFFADDBC);
  static const Color secondary400 = Color(0xFFF8CE9F);
  static const Color secondary500 = Color(0xFFF29D40);
  static const Color secondary600 = Color(0xFFC37F34);
  static const Color secondary700 = Color(0xFFAB6F2E);
  static const Color secondary800 = Color(0xFF936028);
  static const Color secondary900 = Color(0xFF64421D);

  //gray
  static const Color gray50 = Color(0xFFF9FAFB);
  static const Color gray100 = Color(0xFFF3F4F6);
  static const Color gray200 = Color(0xFFE5E7EB);
  static const Color gray300 = Color(0xFFD1D5DB);
  static const Color gray400 = Color(0xFF9CA3AF);
  static const Color gray500 = Color(0xFF6B7280);
  static const Color gray600 = Color(0xFF4B5563);
  static const Color gray700 = Color(0xFF374151);
  static const Color gray800 = Color(0xFF1F2937);
  static const Color gray900 = Color(0xFF111827);

  static const Color primary = primary500;
  static const Color secondary = secondary500;
  static LinearGradient get primaryGradient => const LinearGradient(
    begin: Alignment.bottomRight,
    end: Alignment.topLeft,
    colors: [Color(0xFF5E2C4D), Color(0xFFBF00FF)],
  );
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color backgroundColor = Color(0xFFFCFDFE);
  static const Color warning = Color(0xFFF87171);
  static const Color error = Color(0xFFC33142);
  static const Color success = Color(0xFF007300);
}
