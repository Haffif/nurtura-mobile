import 'package:flutter/material.dart';
import 'package:nurtura_grow/theme/colors.dart';

class AppTheme {
  static ThemeData get projectTheme {
    return ThemeData(
      primaryColor: AppColors.primaryColor,
      scaffoldBackgroundColor: const Color(0xFFF1F5F9),
      fontFamily: 'Inter',

    );
  }
}