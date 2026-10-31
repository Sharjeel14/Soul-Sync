import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:date_app/core/theme/app_colors.dart';

class AppbarDivider extends StatelessWidget {
  const AppbarDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(color: AppColors.white.withValues(alpha: 0.15)),
        5.verticalSpace,
      ],
    );
  }
}
