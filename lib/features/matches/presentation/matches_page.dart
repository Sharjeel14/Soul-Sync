import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:date_app/core/di/injection_container.dart';
import 'package:date_app/core/extensions/app_extensions.dart';
import 'package:date_app/core/theme/app_colors.dart';
import 'package:date_app/core/widgets/animated_loader.dart';
import 'package:date_app/core/widgets/app_system_overlay.dart';
import 'package:date_app/core/widgets/app_text.dart';
import 'package:date_app/features/matches/bloc/matches_cubit.dart';
import 'package:date_app/features/matches/bloc/matches_state.dart';
import 'package:date_app/features/matches/presentation/widgets/match_grid_card.dart';
import 'package:date_app/features/matches/presentation/widgets/matches_empty_state.dart';
import 'package:date_app/features/matches/presentation/widgets/matches_mutual_row.dart';

class MatchesPage extends StatelessWidget {
  const MatchesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<MatchesCubit>(),
      child: const _MatchesContent(),
    );
  }
}

class _MatchesContent extends StatelessWidget {
  const _MatchesContent();

  @override
  Widget build(BuildContext context) {
    return AppSystemOverlay(
      child: Scaffold(
        backgroundColor: context.appBackground,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Row(
            children: [
              Container(
                padding: EdgeInsets.all(6.r),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withValues(alpha: 0.15),
                ),
                child: const Icon(
                  Icons.favorite_rounded,
                  color: AppColors.primary,
                  size: 18,
                ),
              ),
              8.horizontalSpace,
              AppText(
                'Matches & Sparks',
                color: context.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ],
          ),
        ),
        body: BlocBuilder<MatchesCubit, MatchesState>(
          builder: (context, state) {
            if (state.isLoading && state.matches.isEmpty) {
              return const Center(child: BreathingOpacityLoader());
            }

            final matches = state.matches;
            if (matches.isEmpty) {
              return const MatchesEmptyState();
            }

            return RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () => context.read<MatchesCubit>().refresh(),
              child: ListView(
                padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 110.h),
                children: [
                  MatchesMutualRow(matches: matches),
                  20.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppText(
                        'Ready to Chat',
                        color: context.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 3.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: AppText(
                          '${matches.length} Matches',
                          color: AppColors.primary,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  14.verticalSpace,
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: matches.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 14.w,
                      mainAxisSpacing: 14.h,
                      childAspectRatio: 0.78,
                    ),
                    itemBuilder: (context, index) {
                      return MatchGridCard(match: matches[index]);
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
