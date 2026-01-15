import 'package:flutter/material.dart';
import 'package:rastro/utils/styles/app_styles.dart';

// reusable text field for auth forms
class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hintText;
  final bool enabled;
  final bool obscureText;
  final TextInputType keyboardType;
  final VoidCallback? onToggleObscure;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hintText,
    this.enabled = true,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.onToggleObscure,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.label),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          enabled: enabled,
          obscureText: obscureText,
          decoration: onToggleObscure != null
              ? AppInputStyles.password(
                  hintText: hintText,
                  obscure: obscureText,
                  onToggle: onToggleObscure!,
                )
              : AppInputStyles.base(hintText: hintText),
        ),
      ],
    );
  }
}
