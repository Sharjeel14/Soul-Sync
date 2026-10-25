import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:date_app/core/extensions/app_extensions.dart';
import 'package:date_app/core/widgets/app_text.dart';

class ProfileStatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const ProfileStatItem({
    super.key,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppText(value, color: color, fontSize: 18, fontWeight: FontWeight.w800),
        2.verticalSpace,
        AppText(
          label,
          color: context.textSecondary,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ],
    );
  }
}
