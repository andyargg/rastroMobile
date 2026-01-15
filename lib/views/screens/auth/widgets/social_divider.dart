import 'package:flutter/material.dart';
import 'package:rastro/utils/styles/app_colors.dart';
import 'package:rastro/utils/styles/app_styles.dart';

// divider with social text
class SocialDivider extends StatelessWidget {
  final String text;

  const SocialDivider({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.divider)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(text, style: AppTextStyles.dividerText),
        ),
        const Expanded(child: Divider(color: AppColors.divider)),
      ],
    );
  }
}
