import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:date_app/core/extensions/app_extensions.dart';
import 'package:date_app/core/theme/app_colors.dart';

class MyDatingLogo extends StatelessWidget {
  const MyDatingLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // ── Brand Icon Badge ──
        Container(
          width: 72.r,
          height: 72.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primary, AppColors.primaryGradientEnd],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.35),
                blurRadius: 24,
                spreadRadius: 2,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Icon(
              Icons.favorite_rounded,
              color: Colors.white,
              size: 38.r,
            ),
          ),
        ),
        14.verticalSpace,

        // ── Brand Name ──
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: context.isDark
                ? const [Colors.white, AppColors.primaryLight]
                : const [AppColors.textPrimaryLight, AppColors.primary],
          ).createShader(bounds),
          child: Text(
            'SoulSync',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 26.sp,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
        ),
        4.verticalSpace,

        // ── Subtitle ──
        Text(
          'Dating & Genuine Matches',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: context.textSecondary,
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }
}
