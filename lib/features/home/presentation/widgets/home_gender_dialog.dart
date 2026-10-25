import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:date_app/core/extensions/app_extensions.dart';
import 'package:date_app/core/services/flutter_toast_service.dart';
import 'package:date_app/core/theme/app_colors.dart';
import 'package:date_app/core/widgets/app_button.dart';
import 'package:date_app/core/widgets/app_text.dart';
import 'package:date_app/features/global/bloc/global_cubit.dart';
import 'package:date_app/features/global/models/user_model.dart';
import 'package:date_app/features/home/bloc/gender_selection_cubit.dart';
import 'package:date_app/features/home/bloc/gender_selection_state.dart';
import 'package:date_app/features/home/bloc/home_cubit.dart';

class HomeGenderDialog extends StatelessWidget {
  final UserModel user;

  const HomeGenderDialog({super.key, required this.user});

  static Future<void> show(
    BuildContext context, {
    required UserModel user,
  }) async {
    final globalCubit = context.read<GlobalCubit>();
    final homeCubit = context.read<HomeCubit>();

    await showGeneralDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'SelectGender',
      barrierColor: Colors.black.withValues(alpha: 0.85),
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (dialogContext, anim1, anim2) {
        return BlocProvider(
          create: (_) => GenderSelectionCubit(
            user: user,
            globalCubit: globalCubit,
            homeCubit: homeCubit,
          ),
          child: HomeGenderDialog(user: user),
        );
      },
      transitionBuilder: (dialogContext, anim1, anim2, child) {
        return Transform.scale(
          scale: 0.9 + (0.1 * anim1.value),
          child: Opacity(opacity: anim1.value, child: child),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 320.w,
            margin: EdgeInsets.symmetric(horizontal: 24.w),
            padding: EdgeInsets.all(22.r),
            decoration: BoxDecoration(
              color: context.surfaceCard,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: context.stroke, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.4),
                  blurRadius: 28,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: BlocConsumer<GenderSelectionCubit, GenderSelectionState>(
              listener: (context, state) {
                if (state.status == GenderSelectionStatus.success) {
                  Navigator.of(context).pop();
                } else if (state.status == GenderSelectionStatus.failure &&
                    state.errorMessage != null) {
                  ToastService.showError(state.errorMessage!);
                }
              },
              builder: (context, state) {
                final isMale = state.selectedGender == 'male';
                final isFemale = state.selectedGender == 'female';

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 52.r,
                      height: 52.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [
                            AppColors.primary,
                            AppColors.primaryGradientEnd,
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.35),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.wc_rounded,
                        color: Colors.white,
                        size: 28.r,
                      ),
                    ),
                    14.verticalSpace,
                    AppText(
                      context.tr.selectYourGender,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: context.textPrimary,
                      textAlign: TextAlign.center,
                    ),
                    6.verticalSpace,
                    AppText(
                      context.tr.selectGenderSubtitle,
                      fontSize: 12.sp,
                      color: context.textSecondary,
                      textAlign: TextAlign.center,
                    ),
                    18.verticalSpace,

                    // ── Options Row ──
                    Row(
                      children: [
                        Expanded(
                          child: _GenderOptionCard(
                            label: context.tr.male,
                            icon: Icons.male_rounded,
                            isSelected: isMale,
                            onTap: () => context
                                .read<GenderSelectionCubit>()
                                .selectGender('male'),
                          ),
                        ),
                        12.horizontalSpace,
                        Expanded(
                          child: _GenderOptionCard(
                            label: context.tr.female,
                            icon: Icons.female_rounded,
                            isSelected: isFemale,
                            onTap: () => context
                                .read<GenderSelectionCubit>()
                                .selectGender('female'),
                          ),
                        ),
                      ],
                    ),

                    14.verticalSpace,

                    // ── Info Notice ──
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            size: 14.r,
                            color: AppColors.primary,
                          ),
                          6.horizontalSpace,
                          Expanded(
                            child: AppText(
                              context.tr.genderCannotBeChangedNote,
                              fontSize: 11.sp,
                              color: context.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    20.verticalSpace,

                    // ── Submit Button ──
                    AppButton(
                      label: context.tr.continueButton,
                      isLoading:
                          state.status == GenderSelectionStatus.submitting,
                      onPressed: () {
                        context.read<GenderSelectionCubit>().submitGender();
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _GenderOptionCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _GenderOptionCard({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.12)
              : context.appBackground,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : context.stroke,
            width: isSelected ? 2 : 1.2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 28.r,
              color: isSelected ? AppColors.primary : context.textSecondary,
            ),
            6.verticalSpace,
            AppText(
              label,
              fontSize: 13.sp,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? AppColors.primary : context.textPrimary,
            ),
          ],
        ),
      ),
    );
  }
}
