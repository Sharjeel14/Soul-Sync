import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:date_app/core/extensions/app_extensions.dart';

class SocialLoginRow extends StatelessWidget {
  final VoidCallback? onFacebookTap;
  final VoidCallback? onGoogleTap;
  final VoidCallback? onAppleTap;

  const SocialLoginRow({
    super.key,
    this.onFacebookTap,
    this.onGoogleTap,
    this.onAppleTap,
  });

  Widget _buildButton(
    BuildContext context, {
    required Widget child,
    required VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52.r,
        width: 52.r,
        decoration: BoxDecoration(
          color: context.surfaceCard,
          shape: BoxShape.circle,
          border: Border.all(color: context.stroke),
        ),
        child: Center(child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // ── Google ──
        _buildButton(
          context,
          onTap: onGoogleTap,
          child: Text(
            'G',
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w700,
              color: context.textPrimary,
            ),
          ),
        ),
        16.horizontalSpace,

        // ── Apple ──
        _buildButton(
          context,
          onTap: onAppleTap,
          child: Icon(
            Icons.apple,
            color: context.textPrimary,
            size: 26.r,
          ),
        ),
        16.horizontalSpace,

        // ── Facebook ──
        _buildButton(
          context,
          onTap: onFacebookTap,
          child: Text(
            'f',
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1877F2),
            ),
          ),
        ),
      ],
    );
  }
}
