import 'package:flutter/material.dart';
import 'package:rastro/utils/styles/app_colors.dart';

// text styles
abstract class AppTextStyles {
  static const title = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
    fontFamily: 'Roboto',
  );

  static const label = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textDark,
    fontFamily: 'Roboto',
  );

  static const hint = TextStyle(
    color: AppColors.hintText,
    fontSize: 14,
  );

  static const button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.5,
    fontFamily: 'Roboto',
  );

  static const link = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
    fontFamily: 'Roboto',
  );

  static const body = TextStyle(
    fontSize: 14,
    color: AppColors.tertiary,
    fontFamily: 'Roboto',
  );

  static TextStyle dividerText = TextStyle(
    fontSize: 12,
    color: AppColors.tertiary.withValues(alpha: 0.8),
    fontFamily: 'Roboto',
  );
}

// input decoration
abstract class AppInputStyles {
  static InputDecoration base({String? hintText}) => InputDecoration(
    hintText: hintText,
    hintStyle: AppTextStyles.hint,
    filled: true,
    fillColor: AppColors.inputFill,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
  );

  static InputDecoration password({
    String? hintText,
    required bool obscure,
    required VoidCallback onToggle,
  }) => base(hintText: hintText).copyWith(
    suffixIcon: IconButton(
      icon: Icon(
        obscure ? Icons.visibility_off : Icons.visibility,
        color: AppColors.tertiary,
        size: 20,
      ),
      onPressed: onToggle,
    ),
  );
}

// button styles
abstract class AppButtonStyles {
  static ButtonStyle primary = ElevatedButton.styleFrom(
    backgroundColor: AppColors.primary,
    foregroundColor: AppColors.white,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.6),
  );
}
