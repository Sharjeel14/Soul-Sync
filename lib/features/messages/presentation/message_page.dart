import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:date_app/core/di/injection_container.dart';
import 'package:date_app/core/extensions/app_extensions.dart';
import 'package:date_app/core/theme/app_colors.dart';
import 'package:date_app/core/widgets/animated_loader.dart';
import 'package:date_app/core/widgets/app_system_overlay.dart';
import 'package:date_app/core/widgets/app_text.dart';
import 'package:date_app/features/messages/bloc/messages_cubit.dart';
import 'package:date_app/features/messages/bloc/messages_state.dart';
import 'package:date_app/features/messages/presentation/widgets/conversation_item_tile.dart';
import 'package:date_app/features/messages/presentation/widgets/messages_empty_state.dart';
import 'package:date_app/features/messages/presentation/widgets/messages_matches_tray.dart';

class MessagePage extends StatelessWidget {
  const MessagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<MessagesCubit>(),
      child: const _MessagesContent(),
    );
  }
}

class _MessagesContent extends StatelessWidget {
  const _MessagesContent();

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
                  Icons.chat_bubble_rounded,
                  color: AppColors.primary,
                  size: 18,
                ),
              ),
              8.horizontalSpace,
              AppText(
                'Messages',
                color: context.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ],
          ),
        ),
        body: BlocBuilder<MessagesCubit, MessagesState>(
          builder: (context, state) {
            if (state.isLoading && state.conversations.isEmpty) {
              return const Center(child: BreathingOpacityLoader());
            }

            final conversations = state.conversations;
            if (conversations.isEmpty) {
              return const MessagesEmptyState();
            }

            return RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () async {
                context.read<MessagesCubit>().init();
              },
              child: ListView(
                padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 110.h),
                children: [
                  MessagesMatchesTray(
                    matches: state.recentMatches,
                    onlineUserIds: state.onlineUserIds,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppText(
                        'Recent Messages',
                        color: context.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: AppText(
                          '${conversations.length}',
                          color: AppColors.primary,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  10.verticalSpace,
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: conversations.length,
                    separatorBuilder: (context, index) => Divider(
                      color: context.stroke.withValues(alpha: 0.4),
                      height: 20.h,
                    ),
                    itemBuilder: (context, index) {
                      final conv = conversations[index];
                      final isOnline = state.isUserOnline(conv.user.uid);
                      return ConversationItemTile(
                        conversation: conv,
                        isOnline: isOnline,
                      );
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
