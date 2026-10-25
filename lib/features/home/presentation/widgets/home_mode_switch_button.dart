import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:date_app/core/extensions/app_extensions.dart';
import 'package:date_app/core/theme/app_colors.dart';
import 'package:date_app/core/widgets/app_text.dart';

class HomeBottomCenterFloatingLocation extends FloatingActionButtonLocation {
  final double bottomMargin;
  const HomeBottomCenterFloatingLocation({this.bottomMargin = 84});

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    final double fabX =
        (scaffoldGeometry.scaffoldSize.width -
            scaffoldGeometry.floatingActionButtonSize.width) /
        2.0;
    final double fabY =
        scaffoldGeometry.scaffoldSize.height -
        scaffoldGeometry.floatingActionButtonSize.height -
        bottomMargin.h;
    return Offset(fabX, fabY);
  }
}

class HomeModeSwitchFloatingButton extends StatelessWidget {
  final bool isSwipe;
  final VoidCallback onToggle;

  const HomeModeSwitchFloatingButton({
    super.key,
    required this.isSwipe,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42.h,
      decoration: BoxDecoration(
        color: context.isDark
            ? AppColors.surfaceCard.withValues(alpha: 0.95)
            : Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: context.isDark
              ? AppColors.primary.withValues(alpha: 0.4)
              : AppColors.strokes.withValues(alpha: 0.8),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(
              alpha: context.isDark ? 0.3 : 0.15,
            ),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: context.isDark ? 0.35 : 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24.r),
          onTap: onToggle,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.9, end: 1.0).animate(animation),
                  child: child,
                ),
              ),
              child: Row(
                key: ValueKey<bool>(isSwipe),
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(5.r),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary,
                          AppColors.primaryGradientEnd,
                        ],
                      ),
                    ),
                    child: Icon(
                      isSwipe ? Icons.view_agenda_rounded : Icons.style_rounded,
                      color: Colors.white,
                      size: 13.sp,
                    ),
                  ),
                  8.horizontalSpace,
                  AppText(
                    isSwipe ? 'List Mode' : 'Swipe Deck',
                    color: context.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
