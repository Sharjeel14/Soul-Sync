import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SocialAuthButton extends StatelessWidget {
  final String icon;
  final VoidCallback onTap;

  const SocialAuthButton({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        height: 56.h,
        width: 80.w,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Center(child: SvgPicture.asset(icon, height: 24.h)),
      ),
    );
  }
}
