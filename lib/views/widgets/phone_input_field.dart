import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rastro/utils/styles/app_colors.dart';
import 'package:rastro/utils/styles/app_styles.dart';

// phone input with argentina format: +54 | 11 XXXX-XXXX
class PhoneInputField extends StatelessWidget {
  final TextEditingController controller;
  final bool enabled;
  final String? errorText;
  final VoidCallback? onChanged;

  const PhoneInputField({
    super.key,
    required this.controller,
    this.enabled = true,
    this.errorText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null;

    return TextField(
      controller: controller,
      keyboardType: TextInputType.phone,
      enabled: enabled,
      onChanged: (_) => onChanged?.call(),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        _ArgentinaPhoneFormatter(),
      ],
      decoration: InputDecoration(
        hintText: '11 1234-5678',
        hintStyle: AppTextStyles.hint,
        filled: true,
        fillColor: AppColors.inputFill,
        prefixIcon: Container(
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '🇦🇷 +54',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textDark,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 8),
                width: 1,
                height: 24,
                color: AppColors.divider,
              ),
            ],
          ),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: hasError
              ? const BorderSide(color: AppColors.error, width: 1.5)
              : BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: hasError
              ? const BorderSide(color: AppColors.error, width: 1.5)
              : BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: hasError ? AppColors.error : AppColors.primary,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  // get full phone number in E.164 format for supabase
  static String getFullNumber(String formatted) {
    final digits = formatted.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return '';
    return '+54$digits';
  }
}

// formatter: 11 1234-5678
class _ArgentinaPhoneFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');

    // max 10 digits for argentina mobile
    final limited = digits.length > 10 ? digits.substring(0, 10) : digits;

    final buffer = StringBuffer();
    for (int i = 0; i < limited.length; i++) {
      // add space after area code (2 digits)
      if (i == 2 && limited.length > 2) buffer.write(' ');
      // add dash after 4 more digits
      if (i == 6 && limited.length > 6) buffer.write('-');
      buffer.write(limited[i]);
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
