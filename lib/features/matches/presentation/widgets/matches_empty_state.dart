import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:date_app/core/extensions/app_extensions.dart';
import 'package:date_app/core/theme/app_colors.dart';
import 'package:date_app/core/widgets/app_text.dart';
import 'package:date_app/features/bottom_nav_bar/bloc/bottom_nav_cubit.dart';

class MatchesEmptyState extends StatelessWidget {
  const MatchesEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 76.r,
              height: 76.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.12),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.3),
                ),
              ),
              child: const Icon(
                Icons.favorite_border_rounded,
                color: AppColors.primary,
                size: 38,
              ),
            ),
            18.verticalSpace,
            AppText(
              'No Matches Yet',
              color: context.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
            8.verticalSpace,
            AppText(
              'Swipe right or tap Like in Discover to create your matches!',
              color: context.textSecondary,
              fontSize: 13,
              textAlign: TextAlign.center,
            ),
            20.verticalSpace,
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22.r),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 24.w,
                  vertical: 12.h,
                ),
              ),
              onPressed: () {
                context.read<BottomNavCubit>().updateIndex(0);
              },
              child: const AppText(
                'Discover People ✨',
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
