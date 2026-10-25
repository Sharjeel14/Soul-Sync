import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:date_app/core/theme/app_colors.dart';
import 'package:date_app/features/global/bloc/global_cubit.dart';

class ThemeToggleWidget extends StatelessWidget {
  const ThemeToggleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GlobalCubit, GlobalState>(
      buildWhen: (prev, curr) => prev.themeMode != curr.themeMode,
      builder: (context, state) {
        final isDark = state.themeMode == ThemeMode.dark;

        return Tooltip(
          message: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
          child: GestureDetector(
            onTap: () => context.read<GlobalCubit>().toggleTheme(),
            behavior: HitTestBehavior.opaque,
            child: Container(
              height: 34.h,
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceCard : Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: isDark
                      ? AppColors.strokes.withValues(alpha: 0.8)
                      : AppColors.grey300,
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Sun Icon (Light Mode)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    padding: EdgeInsets.all(4.r),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: !isDark
                          ? const Color(0xFFFFB300)
                          : Colors.transparent,
                      boxShadow: !isDark
                          ? [
                              BoxShadow(
                                color: const Color(0xFFFFB300)
                                    .withValues(alpha: 0.4),
                                blurRadius: 6,
                              ),
                            ]
                          : null,
                    ),
                    child: Icon(
                      Icons.wb_sunny_rounded,
                      size: 14.sp,
                      color: !isDark
                          ? Colors.white
                          : AppColors.textSecondaryDark,
                    ),
                  ),
                  4.horizontalSpace,
                  // Moon Icon (Dark Mode)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    padding: EdgeInsets.all(4.r),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDark
                          ? AppColors.primary
                          : Colors.transparent,
                      boxShadow: isDark
                          ? [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.4),
                                blurRadius: 6,
                              ),
                            ]
                          : null,
                    ),
                    child: Icon(
                      Icons.nightlight_round,
                      size: 14.sp,
                      color: isDark
                          ? Colors.white
                          : AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
