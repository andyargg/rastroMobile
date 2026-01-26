import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rastro/utils/styles/app_colors.dart';

/// reusable otp input widget with responsive layout
class OtpInput extends StatelessWidget {
  final int digitCount;
  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;
  final bool enabled;
  final bool hasError;
  final Function(int index, String value) onChanged;

  const OtpInput({
    super.key,
    required this.digitCount,
    required this.controllers,
    required this.focusNodes,
    this.enabled = true,
    this.hasError = false,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(digitCount, (index) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              left: index == 0 ? 0 : 3,
              right: index == digitCount - 1 ? 0 : 3,
            ),
            child: SizedBox(
              height: 48,
              child: TextField(
                controller: controllers[index],
                focusNode: focusNodes[index],
                enabled: enabled,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 1,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
                decoration: InputDecoration(
                  counterText: '',
                  filled: true,
                  fillColor: AppColors.inputFill,
                  contentPadding: EdgeInsets.zero,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: hasError
                        ? const BorderSide(color: AppColors.error, width: 1.5)
                        : BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: hasError
                        ? const BorderSide(color: AppColors.error, width: 1.5)
                        : BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: hasError ? AppColors.error : AppColors.primary,
                      width: 2,
                    ),
                  ),
                ),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (value) => onChanged(index, value),
              ),
            ),
          ),
        );
      }),
    );
  }
}
