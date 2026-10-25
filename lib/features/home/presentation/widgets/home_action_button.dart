import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:date_app/core/theme/app_colors.dart';

class HomeActionButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color borderColor;
  final Color backgroundColor;
  final double size;
  final bool isGlow;
  final VoidCallback onTap;

  const HomeActionButton({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.borderColor,
    required this.backgroundColor,
    required this.size,
    this.isGlow = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size.r,
        height: size.r,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor,
          border: Border.all(color: borderColor, width: 1.5),
          boxShadow: isGlow
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.4),
                    blurRadius: 18,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Icon(icon, color: iconColor, size: (size * 0.48).r),
        ),
      ),
    );
  }
}
