import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:date_app/core/theme/app_colors.dart';
import 'package:date_app/core/widgets/app_text.dart';

class TitleAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const TitleAppbar({super.key, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          /// Title
          AppText(
            title,
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: AppColors.white,
          ),
        ],
      ),
    );
  }
}
