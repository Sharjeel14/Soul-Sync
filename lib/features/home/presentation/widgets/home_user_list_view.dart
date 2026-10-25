import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:date_app/core/extensions/app_extensions.dart';
import 'package:date_app/core/services/presence_service.dart';
import 'package:date_app/core/theme/app_colors.dart';
import 'package:date_app/core/widgets/app_cache_network_image.dart';
import 'package:date_app/core/widgets/app_text.dart';
import 'package:date_app/core/widgets/user_circle_avatar.dart';
import 'package:date_app/features/global/models/user_model.dart';
import 'package:date_app/features/home/bloc/home_cubit.dart';

import 'home_empty_card_state.dart';

class HomeUserListView extends StatelessWidget {
  final List<UserModel> users;
  final ValueChanged<UserModel> onCardTap;
  final ValueChanged<UserModel> onStartChat;
  final ValueChanged<UserModel> onLike;

  const HomeUserListView({
    super.key,
    required this.users,
    required this.onCardTap,
    required this.onStartChat,
    required this.onLike,
  });

  @override
  Widget build(BuildContext context) {
    if (users.isEmpty) {
      return HomeEmptyCardState(
        onRefresh: () => context.read<HomeCubit>().loadUsers(),
      );
    }

    return StreamBuilder<Set<String>>(
      stream: PresenceService().onlineUsersStream,
      initialData: PresenceService().onlineUserIds,
      builder: (context, presenceSnap) {
        final onlineIds = presenceSnap.data ?? {};

        return ListView.separated(
          padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 138.h),
          itemCount: users.length,
          separatorBuilder: (context, index) => 12.verticalSpace,
          itemBuilder: (context, index) {
            final user = users[index];
            final isOnline = onlineIds.contains(user.uid);

            return InkWell(
              onTap: () => onCardTap(user),
              borderRadius: BorderRadius.circular(18.r),
              child: Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: context.surfaceCard,
                  borderRadius: BorderRadius.circular(18.r),
                  border: Border.all(color: context.stroke),
                ),
                child: Row(
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14.r),
                          child: user.profileImageUrl.isNotEmpty
                              ? AppCacheNetworkImage(
                                  user.profileImageUrl,
                                  width: 64.r,
                                  height: 64.r,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      UserCircleAvatar(
                                        name: user.name,
                                        size: 64,
                                        isCircle: false,
                                      ),
                                )
                              : UserCircleAvatar(
                                  name: user.name,
                                  size: 64,
                                  isCircle: false,
                                ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            width: 13.r,
                            height: 13.r,
                            decoration: BoxDecoration(
                              color: isOnline
                                  ? const Color(0xFF00E676)
                                  : const Color(0xFF9E9E9E),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: context.surfaceCard,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    14.horizontalSpace,
                    // User Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: AppText(
                                  user.name,
                                  color: context.textPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              8.horizontalSpace,
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 6.w,
                                  vertical: 2.h,
                                ),
                                decoration: BoxDecoration(
                                  color: isOnline
                                      ? const Color(0xFF00E676)
                                            .withValues(alpha: 0.15)
                                      : context.surfaceDark,
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: AppText(
                                  isOnline ? 'Online' : 'Offline',
                                  color: isOnline
                                      ? const Color(0xFF00E676)
                                      : context.textSecondary,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          4.verticalSpace,
                          AppText(
                            user.bio.isNotEmpty
                                ? user.bio
                                : 'Ready to connect on SoulSync ✨',
                            color: context.textSecondary,
                            fontSize: 12,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    10.horizontalSpace,
                    // Quick Action Buttons
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          style: IconButton.styleFrom(
                            backgroundColor: AppColors.primary.withValues(
                              alpha: 0.15,
                            ),
                            padding: EdgeInsets.all(8.r),
                          ),
                          icon: const Icon(
                            Icons.chat_bubble_rounded,
                            color: AppColors.primary,
                            size: 18,
                          ),
                          onPressed: () => onStartChat(user),
                        ),
                        4.verticalSpace,
                        IconButton(
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.redAccent.withValues(
                              alpha: 0.1,
                            ),
                            padding: EdgeInsets.all(8.r),
                          ),
                          icon: const Icon(
                            Icons.favorite_rounded,
                            color: Colors.redAccent,
                            size: 18,
                          ),
                          onPressed: () => onLike(user),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
