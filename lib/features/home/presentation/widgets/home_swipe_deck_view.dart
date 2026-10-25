import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:date_app/core/extensions/app_extensions.dart';
import 'package:date_app/core/router/routes.dart';
import 'package:date_app/core/theme/app_colors.dart';
import 'package:date_app/features/global/models/user_model.dart';
import 'package:date_app/features/home/bloc/home_cubit.dart';

import 'home_action_button.dart';
import 'home_empty_card_state.dart';
import 'home_swiper_card.dart';

class HomeSwipeDeckView extends StatelessWidget {
  final List<UserModel> users;
  final CardSwiperController swiperController;
  final ValueChanged<UserModel> onInfoTap;

  const HomeSwipeDeckView({
    super.key,
    required this.users,
    required this.swiperController,
    required this.onInfoTap,
  });

  @override
  Widget build(BuildContext context) {
    if (users.isEmpty) {
      return HomeEmptyCardState(
        onRefresh: () => context.read<HomeCubit>().loadUsers(),
      );
    }

    return Column(
      children: [
        Expanded(
          child: CardSwiper(
            controller: swiperController,
            cardsCount: users.length,
            numberOfCardsDisplayed: users.length >= 2 ? 2 : 1,
            backCardOffset: const Offset(0, 36),
            scale: 0.92,
            padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 14.h),
            allowedSwipeDirection: const AllowedSwipeDirection.only(
              left: true,
              right: true,
            ),
            onSwipe: (previousIndex, currentIndex, direction) {
              if (currentIndex != null) {
                context.read<HomeCubit>().updateSelectedIndex(currentIndex);
              }
              if (previousIndex < users.length) {
                final user = users[previousIndex];
                if (direction == CardSwiperDirection.right) {
                  context.read<HomeCubit>().onSwipeRight(user);
                } else if (direction == CardSwiperDirection.left) {
                  context.read<HomeCubit>().onSwipeLeft(user);
                }
              }
              return true;
            },
            onUndo: (previousIndex, currentIndex, direction) {
              context.read<HomeCubit>().updateSelectedIndex(currentIndex);

              if (previousIndex != null && previousIndex < users.length) {
                context.read<HomeCubit>().undoSwipe(users[previousIndex]);
              }
              return true;
            },
            cardBuilder: (context, index, percentX, percentY) {
              if (index >= users.length) return null;
              final user = users[index];
              return HomeSwiperCard(
                user: user,
                percentX: percentX,
                onInfoTap: () => onInfoTap(user),
              );
            },
          ),
        ),

        // ── Action Buttons Row ──
        Padding(
          padding: EdgeInsets.only(bottom: 138.h, top: 4.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Rewind / Undo
              HomeActionButton(
                icon: Icons.replay_rounded,
                iconColor: const Color(0xFFFFB74D),
                borderColor: const Color(0xFFFFB74D).withValues(alpha: 0.4),
                backgroundColor: context.surfaceCard,
                size: 46,
                onTap: () => swiperController.undo(),
              ),
              // Pass (Left Swipe)
              HomeActionButton(
                icon: Icons.close_rounded,
                iconColor: const Color(0xFFFF5252),
                borderColor: const Color(0xFFFF5252).withValues(alpha: 0.4),
                backgroundColor: context.surfaceCard,
                size: 56,
                onTap: () => swiperController.swipe(CardSwiperDirection.left),
              ),
              // Chat Directly with User
              HomeActionButton(
                icon: Icons.chat_bubble_rounded,
                iconColor: AppColors.superlikeBlue,
                borderColor: AppColors.superlikeBlue.withValues(alpha: 0.5),
                backgroundColor: context.surfaceCard,
                size: 46,
                onTap: () {
                  final cubit = context.read<HomeCubit>();
                  final currentUsers = cubit.state.filteredUsers;
                  if (currentUsers.isNotEmpty) {
                    final idx = cubit.state.selectedIndex;
                    final target = (idx >= 0 && idx < currentUsers.length)
                        ? currentUsers[idx]
                        : currentUsers.first;
                    context.push(AppRoutes.chat, extra: target);
                  }
                },
              ),
              // Like (Right Swipe)
              HomeActionButton(
                icon: Icons.favorite_rounded,
                iconColor: Colors.white,
                borderColor: AppColors.primary,
                backgroundColor: AppColors.primary,
                isGlow: true,
                size: 58,
                onTap: () => swiperController.swipe(CardSwiperDirection.right),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
