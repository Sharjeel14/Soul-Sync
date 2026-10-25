import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:date_app/core/widgets/app_text.dart';

class PillTag extends StatelessWidget {
  final String text;
  final Color color;

  const PillTag({super.key, required this.text, this.color = Colors.green});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(50),
        // border: Border.all(color: color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          6.horizontalSpace,
          AppText(
            text,
            color: color,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ],
      ),
    );
  }
}
