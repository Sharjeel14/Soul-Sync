import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:date_app/core/theme/app_colors.dart';
import 'app_text.dart';

class GlassArrowField extends StatelessWidget {
  final String text;
  final String? hintText;
  final VoidCallback? onTap;
  final Widget? icon;
  final double thickness;
  final Color? textColor;

  const GlassArrowField({
    super.key,
    required this.text,
    this.hintText,
    this.onTap,
    this.icon,
    this.thickness = 20,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: AppText(
                text.isNotEmpty ? text : (hintText ?? ""),
                color: textColor ?? AppColors.white,
                fontSize: 14,
              ),
            ),
            icon ??
                Icon(Icons.arrow_forward_ios, color: AppColors.white, size: 16),
          ],
        ),
      ),
    );
  }
}
