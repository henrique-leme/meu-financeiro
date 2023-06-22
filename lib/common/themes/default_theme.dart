import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class CustomTheme {
  CustomTheme._();

  factory CustomTheme() {
    return CustomTheme._();
  }

  ThemeData get defaultTheme {
    const defaultBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: AppColors.primaryGreen,
      ),
    );

    return ThemeData(
      colorScheme: const ColorScheme.light(
        primary: AppColors.darkGreen,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        foregroundColor: AppColors.iceWhite,
        backgroundColor: AppColors.green,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.darkGreen,
        ),
      ),
      tabBarTheme: const TabBarTheme(
        indicator: BoxDecoration(
          border: Border(),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle:
            AppTextStyles.inputLabelText.copyWith(color: AppColors.grey),
        hintStyle: AppTextStyles.inputHintText.copyWith(color: AppColors.green),
        focusedBorder: defaultBorder,
        enabledBorder: defaultBorder,
        disabledBorder: defaultBorder,
        errorBorder: defaultBorder.copyWith(
          borderSide: const BorderSide(
            color: AppColors.errorColor,
          ),
        ),
        focusedErrorBorder: defaultBorder.copyWith(
          borderSide: const BorderSide(
            color: AppColors.errorColor,
          ),
        ),
      ),
    );
  }
}
