import 'package:flutter/material.dart';
import 'package:date_app/core/theme/app_colors.dart';

class AppDivider extends StatelessWidget {
  const AppDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: AppColors.primary.withValues(alpha: 0.24),
      thickness: 0.6,
    );
  }
}
