import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:date_app/core/extensions/app_extensions.dart';
import 'package:date_app/core/widgets/app_text.dart';

class ArrowAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const ArrowAppbar({super.key, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          padding: EdgeInsets.zero,
          splashRadius: 1,
          onPressed: () => context.safePop(),

          icon: Container(
            width: 40.r,
            height: 40.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: context.stroke),
              color: context.surfaceCard,
            ),
            child: Icon(
              Icons.chevron_left,
              color: context.textPrimary,
              size: 22,
            ),
          ),
        ),
        16.horizontalSpace,
        AppText(
          title,
          color: context.textPrimary,
          style: AppTypography.h3,
          fontWeight: FontWeight.bold,
        ),
      ],
    );
  }
}
