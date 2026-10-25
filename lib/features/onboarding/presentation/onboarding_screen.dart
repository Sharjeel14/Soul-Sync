import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:date_app/core/extensions/app_extensions.dart';
import 'package:date_app/core/router/routes.dart';
import 'package:date_app/core/theme/app_colors.dart';
import 'package:date_app/core/widgets/app_button.dart';
import 'package:date_app/core/widgets/app_system_overlay.dart';
import 'package:date_app/core/widgets/app_text.dart';
import 'package:date_app/features/onboarding/bloc/onboarding_cubit.dart';
import 'package:date_app/features/onboarding/bloc/onboarding_state.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _finishOnboarding(BuildContext context) {
    context.read<OnboardingCubit>().completeOnboarding().then((_) {
      if (context.mounted) {
        context.go(AppRoutes.login);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnboardingCubit(),
      child: BlocBuilder<OnboardingCubit, OnboardingState>(
        builder: (context, state) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          final backgroundColor = isDark
              ? AppColors.backgroundDark
              : AppColors.backgroundLight;

          return AppSystemOverlay(
            child: Scaffold(
              backgroundColor: backgroundColor,
              body: Stack(
                children: [
                  // ── Ambient Background Glows ──
                  Positioned(
                    top: -40.h,
                    right: -40.w,
                    child: Container(
                      width: 220.r,
                      height: 220.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDark
                            ? AppColors.primary.withValues(alpha: 0.12)
                            : AppColors.primaryLight.withValues(alpha: 0.18),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 60.h,
                    left: -50.w,
                    child: Container(
                      width: 200.r,
                      height: 200.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDark
                            ? AppColors.primaryGradientEnd.withValues(
                                alpha: 0.08,
                              )
                            : AppColors.primary.withValues(alpha: 0.1),
                      ),
                    ),
                  ),

                  // ── Main Content SafeArea ──
                  SafeArea(
                    child: Column(
                      children: [
                        // ── Top Bar: Skip Button ──
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 10.h,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () => _finishOnboarding(context),
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 14.w,
                                    vertical: 6.h,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.r),
                                    side: BorderSide(
                                      color: context.stroke.withValues(
                                        alpha: 0.7,
                                      ),
                                    ),
                                  ),
                                ),
                                child: AppText(
                                  context.tr.skip,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: context.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // ── 3-Page Carousel ──
                        Expanded(
                          child: PageView(
                            controller: _pageController,
                            onPageChanged: (index) {
                              context.read<OnboardingCubit>().setPage(index);
                            },
                            children: [
                              _OnboardingPageItem(
                                icon: Icons.favorite_rounded,
                                iconColors: const [
                                  AppColors.primary,
                                  AppColors.primaryGradientEnd,
                                ],
                                title: context.tr.onboardingTitle1,
                                description: context.tr.onboardingDesc1,
                                accentBadgeIcon: Icons.auto_awesome,
                              ),
                              _OnboardingPageItem(
                                icon: Icons.chat_bubble_rounded,
                                iconColors: const [
                                  AppColors.superlikeBlue,
                                  AppColors.primary,
                                ],
                                title: context.tr.onboardingTitle2,
                                description: context.tr.onboardingDesc2,
                                accentBadgeIcon: Icons.bolt_rounded,
                              ),
                              _OnboardingPageItem(
                                icon: Icons.verified_user_rounded,
                                iconColors: const [
                                  AppColors.boostPurple,
                                  AppColors.primary,
                                ],
                                title: context.tr.onboardingTitle3,
                                description: context.tr.onboardingDesc3,
                                accentBadgeIcon: Icons.shield_rounded,
                              ),
                            ],
                          ),
                        ),

                        // ── Bottom Bar: Indicators & Action Button ──
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 24.w,
                            vertical: 20.h,
                          ),
                          child: Column(
                            children: [
                              // ── Dot Indicators ──
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(3, (index) {
                                  final isActive = state.currentPage == index;
                                  return AnimatedContainer(
                                    duration: const Duration(milliseconds: 250),
                                    margin: EdgeInsets.symmetric(
                                      horizontal: 4.w,
                                    ),
                                    width: isActive ? 24.w : 8.w,
                                    height: 8.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.r),
                                      color: isActive
                                          ? AppColors.primary
                                          : (isDark
                                                ? AppColors.grey700
                                                : AppColors.grey300),
                                    ),
                                  );
                                }),
                              ),

                              24.verticalSpace,

                              // ── Button ──
                              AppButton(
                                label: state.isLastPage
                                    ? context.tr.getStarted
                                    : context.tr.next,
                                onPressed: () {
                                  if (state.isLastPage) {
                                    _finishOnboarding(context);
                                  } else {
                                    _pageController.nextPage(
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      curve: Curves.easeInOut,
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _OnboardingPageItem extends StatelessWidget {
  final IconData icon;
  final List<Color> iconColors;
  final String title;
  final String description;
  final IconData accentBadgeIcon;

  const _OnboardingPageItem({
    required this.icon,
    required this.iconColors,
    required this.title,
    required this.description,
    required this.accentBadgeIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ── Hero Visual Illustration Container ──
          Stack(
            alignment: Alignment.center,
            children: [
              // Outer ambient glow ring
              Container(
                width: 210.r,
                height: 210.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: iconColors.first.withValues(alpha: 0.08),
                  border: Border.all(
                    color: iconColors.first.withValues(alpha: 0.18),
                    width: 1.5,
                  ),
                ),
              ),

              // Middle glow ring
              Container(
                width: 160.r,
                height: 160.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: iconColors.first.withValues(alpha: 0.14),
                ),
              ),

              // Inner gradient badge
              Container(
                width: 110.r,
                height: 110.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: iconColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: iconColors.first.withValues(alpha: 0.4),
                      blurRadius: 28,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Icon(icon, color: Colors.white, size: 52.r),
              ),

              // Accent floating badge
              Positioned(
                top: 24.h,
                right: 24.w,
                child: Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: context.surfaceCard,
                    border: Border.all(color: context.stroke, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Icon(
                    accentBadgeIcon,
                    color: AppColors.matchGold,
                    size: 16.r,
                  ),
                ),
              ),
            ],
          ),

          36.verticalSpace,

          // ── Title ──
          AppText(
            title,
            fontSize: 22.sp,
            fontWeight: FontWeight.w800,
            color: context.textPrimary,
            textAlign: TextAlign.center,
          ),

          12.verticalSpace,

          // ── Description ──
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: AppText(
              description,
              fontSize: 13.sp,
              color: context.textSecondary,
              textAlign: TextAlign.center,
              lineHeight: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
