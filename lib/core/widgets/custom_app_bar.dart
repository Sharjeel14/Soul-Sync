import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:date_app/core/extensions/app_extensions.dart';
import 'package:date_app/core/widgets/app_text.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final VoidCallback? onPop;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.onPop,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      scrolledUnderElevation: 0,
      elevation: 0,
      toolbarHeight: 50,
      backgroundColor: context.appBackground,
      title: Row(
        children: [
          if (showBackButton)
            GestureDetector(
              onTap: onPop ?? () => context.safePop(),
              child: Icon(Icons.arrow_back, color: context.textPrimary),
            ),
          if (showBackButton) 16.horizontalSpace,
          AppText(
            title,
            fontSize: 24,
            fontWeight: FontWeight.w400,
            color: context.textPrimary,
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(50.h); // Adjust height as needed
}
