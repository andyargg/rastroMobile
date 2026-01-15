import 'package:flutter/material.dart';
import 'package:rastro/utils/styles/app_colors.dart';

// custom snackbar with static show methods
class CustomSnackbar extends StatelessWidget {
  final String message;
  final Color backgroundColor;
  final Color textColor;
  final IconData icon;
  final Duration duration;

  const CustomSnackbar({
    super.key,
    required this.message,
    required this.icon,
    this.backgroundColor = AppColors.primary,
    this.textColor = AppColors.white,
    this.duration = const Duration(seconds: 2),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: textColor, size: 30),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              message,
              style: TextStyle(
                color: textColor,
                fontFamily: 'Roboto',
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static void show(BuildContext context, CustomSnackbar snackbar) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        margin: const EdgeInsets.fromLTRB(16, 16, 16, 80),
        padding: EdgeInsets.zero,
        content: snackbar,
        duration: snackbar.duration,
        dismissDirection: DismissDirection.horizontal,
      ),
    );
  }

  static void showSuccess(BuildContext context, {String message = "Success!"}) {
    show(
      context,
      CustomSnackbar(
        message: message,
        icon: Icons.check_circle,
        backgroundColor: AppColors.success,
        textColor: AppColors.white,
      ),
    );
  }

  static void showError(BuildContext context, String message) {
    show(
      context,
      CustomSnackbar(
        message: message,
        icon: Icons.error,
        backgroundColor: AppColors.error,
        textColor: AppColors.white,
      ),
    );
  }
}
