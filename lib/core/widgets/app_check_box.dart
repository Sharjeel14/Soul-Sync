import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:date_app/core/theme/app_colors.dart';
import 'package:date_app/core/widgets/app_text.dart';

class AppCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final String? label;

  const AppCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 25.w,
          height: 25.h,
          // decoration: BoxDecoration(
          //   border: Border.all(color: AppColors.white),
          //   borderRadius: BorderRadius.circular(4.r),
          // ),
          child: Checkbox(
            // splashRadius: 0,
            value: value,
            side: BorderSide(color: AppColors.white),

            visualDensity: VisualDensity.compact,
            onChanged: onChanged,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        if (label != null) ...[
          10.horizontalSpace,
          GestureDetector(
            onTap: () => onChanged(!value),
            child: AppText(label!, fontSize: 16),
          ),
        ],
      ],
    );
  }
}
