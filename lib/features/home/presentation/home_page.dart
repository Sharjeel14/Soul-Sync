import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:date_app/core/di/injection_container.dart';
import 'package:date_app/core/extensions/app_extensions.dart';
import 'package:date_app/core/router/routes.dart';
import 'package:date_app/core/services/flutter_toast_service.dart';
import 'package:date_app/core/theme/app_colors.dart';
import 'package:date_app/core/widgets/animated_loader.dart';
import 'package:date_app/core/widgets/app_system_overlay.dart';
import 'package:date_app/core/widgets/app_text.dart';
import 'package:date_app/features/global/bloc/global_cubit.dart';
import 'package:date_app/features/global/models/user_model.dart';
import 'package:date_app/features/home/bloc/home_cubit.dart';

// import 'widgets/home_filter_chip.dart';
import 'widgets/home_gender_dialog.dart';
import 'widgets/home_match_celebration_dialog.dart';
import 'widgets/home_mode_switch_button.dart';
import 'widgets/home_profile_detail_sheet.dart';
import 'widgets/home_swipe_deck_view.dart';
import 'widgets/home_user_list_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<HomeCubit>(),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final CardSwiperController _swiperController;
  bool _isGenderDialogShowing = false;

  @override
  void initState() {
    super.initState();
    _swiperController = CardSwiperController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _checkAndPromptGender(context, context.read<GlobalCubit>().state.user);
      }
    });
  }

  void _checkAndPromptGender(BuildContext context, UserModel? user) {
    if (user == null || _isGenderDialogShowing) return;
    final gender = user.gender.trim().toLowerCase();
    if (gender.isEmpty || gender == 'unknown') {
      _isGenderDialogShowing = true;
      HomeGenderDialog.show(context, user: user).then((_) {
        _isGenderDialogShowing = false;
      });
    }
  }

  @override
  void dispose() {
    _swiperController.dispose();
    super.dispose();
  }

  void _showMatchDialog(BuildContext context, UserModel matchedUser) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Match',
      barrierColor: Colors.black.withValues(alpha: 0.8),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (dialogContext, anim1, anim2) {
        return HomeMatchCelebrationDialog(
          matchedUser: matchedUser,
          onSendMessage: () {
            Navigator.of(dialogContext).pop();
            context.read<HomeCubit>().dismissMatchDialog();
            context.push(AppRoutes.chat, extra: matchedUser);
          },
          onKeepSwiping: () {
            Navigator.of(dialogContext).pop();
            context.read<HomeCubit>().dismissMatchDialog();
          },
        );
      },
      transitionBuilder: (dialogContext, anim1, anim2, child) {
        return Transform.scale(
          scale: 0.85 + (0.15 * anim1.value),
          child: Opacity(opacity: anim1.value, child: child),
        );
      },
    );
  }

  void _showProfileDetailSheet(BuildContext context, UserModel user) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) => HomeProfileDetailSheet(
        user: user,
        onStartChat: () {
          Navigator.of(sheetContext).pop();
          context.push(AppRoutes.chat, extra: user);
        },
        onBlockUser: () {
          Navigator.of(sheetContext).pop();
          context.read<HomeCubit>().blockUser(user.uid);
          ToastService.showPrimary('Blocked ${user.name}');
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<HomeCubit, HomeState>(
          listenWhen: (prev, curr) =>
              curr.lastMatchedUser != null &&
              curr.lastMatchedUser != prev.lastMatchedUser,
          listener: (context, state) {
            if (state.lastMatchedUser != null) {
              _showMatchDialog(context, state.lastMatchedUser!);
            }
          },
        ),
        BlocListener<GlobalCubit, GlobalState>(
          listenWhen: (prev, curr) =>
              curr.user != null && curr.user != prev.user,
          listener: (context, state) {
            _checkAndPromptGender(context, state.user);
          },
        ),
      ],
      child: AppSystemOverlay(
        child: Scaffold(
          backgroundColor: context.appBackground,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryGradientEnd],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.35),
                        blurRadius: 12,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.favorite_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                10.horizontalSpace,
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryLight],
                  ).createShader(bounds),
                  child: const AppText(
                    'SoulSync',
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.refresh_rounded, color: context.textPrimary),
                onPressed: () => context.read<HomeCubit>().loadUsers(),
              ),
              12.horizontalSpace,
            ],
          ),
          floatingActionButtonLocation: const HomeBottomCenterFloatingLocation(
            bottomMargin: 84,
          ),
          floatingActionButton: BlocBuilder<HomeCubit, HomeState>(
            buildWhen: (prev, curr) =>
                prev.viewMode != curr.viewMode ||
                prev.isLoading != curr.isLoading ||
                prev.errorMessage != curr.errorMessage,
            builder: (context, state) {
              if (state.isLoading || state.errorMessage != null) {
                return const SizedBox.shrink();
              }
              final isSwipe = state.viewMode == HomeViewMode.swipe;
              return HomeModeSwitchFloatingButton(
                isSwipe: isSwipe,
                onToggle: () {
                  context.read<HomeCubit>().setViewMode(
                    isSwipe ? HomeViewMode.list : HomeViewMode.swipe,
                  );
                },
              );
            },
          ),
          body: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              if (state.isLoading) {
                return const Center(child: BreathingOpacityLoader());
              }

              if (state.errorMessage != null) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline_rounded,
                          color: AppColors.primary,
                          size: 48,
                        ),
                        12.verticalSpace,
                        AppText(
                          state.errorMessage!,
                          color: AppColors.textSecondaryDark,
                          fontSize: 14,
                          textAlign: TextAlign.center,
                        ),
                        16.verticalSpace,
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                          ),
                          onPressed: () =>
                              context.read<HomeCubit>().loadUsers(),
                          child: const AppText(
                            'Retry',
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final users = state.filteredUsers;

              return Column(
                children: [
                  // ── Dating Filter Chips ──
                  // Padding(
                  //   padding: EdgeInsets.symmetric(
                  //     horizontal: 16.w,
                  //     vertical: 6.h,
                  //   ),
                  //   child: Row(
                  //     children: [
                  //       HomeFilterChip(
                  //         icon: Icons.all_inclusive_rounded,
                  //         label: 'All',
                  //         isSelected:
                  //             state.selectedGenderFilter == null ||
                  //             state.selectedGenderFilter == 'all',
                  //         onTap: () =>
                  //             context.read<HomeCubit>().filterByGender('all'),
                  //       ),
                  //       8.horizontalSpace,
                  //       HomeFilterChip(
                  //         icon: Icons.female_rounded,
                  //         label: 'Women',
                  //         isSelected:
                  //             state.selectedGenderFilter?.toLowerCase() ==
                  //             'female',
                  //         onTap: () => context.read<HomeCubit>().filterByGender(
                  //           'female',
                  //         ),
                  //       ),
                  //       8.horizontalSpace,
                  //       HomeFilterChip(
                  //         icon: Icons.male_rounded,
                  //         label: 'Men',
                  //         isSelected:
                  //             state.selectedGenderFilter?.toLowerCase() ==
                  //             'male',
                  //         onTap: () =>
                  //             context.read<HomeCubit>().filterByGender('male'),
                  //       ),
                  //     ],
                  //   ),
                  // ),

                  // ── View Mode: Swipe Deck vs List ──
                  Expanded(
                    child: IndexedStack(
                      index: state.viewMode == HomeViewMode.swipe ? 0 : 1,
                      children: [
                        // MODE 1: SWIPE DECK
                        HomeSwipeDeckView(
                          users: users,
                          swiperController: _swiperController,
                          onInfoTap: (user) =>
                              _showProfileDetailSheet(context, user),
                        ),

                        // MODE 2: LIST MODE
                        HomeUserListView(
                          users: users,
                          onCardTap: (user) =>
                              _showProfileDetailSheet(context, user),
                          onStartChat: (user) =>
                              context.push(AppRoutes.chat, extra: user),
                          onLike: (user) =>
                              context.read<HomeCubit>().onSwipeRight(user),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
