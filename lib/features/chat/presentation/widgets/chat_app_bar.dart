import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:date_app/core/extensions/app_extensions.dart';
import 'package:date_app/core/theme/app_colors.dart';
import 'package:date_app/core/widgets/app_cache_network_image.dart';
import 'package:date_app/core/widgets/app_text.dart';
import 'package:date_app/core/widgets/user_circle_avatar.dart';
import 'package:date_app/features/chat/bloc/chat_cubit.dart';
import 'package:date_app/features/chat/bloc/chat_state.dart';
import 'package:date_app/features/global/models/user_model.dart';

class ChatAppBar extends StatelessWidget {
  final UserModel targetUser;
  final VoidCallback onBlockTap;

  const ChatAppBar({
    super.key,
    required this.targetUser,
    required this.onBlockTap,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(
      buildWhen: (p, c) =>
          p.isOnline != c.isOnline || p.isBlocked != c.isBlocked,
      builder: (context, state) {
        final isOnline = state.isOnline;

        return ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: Container(
              decoration: BoxDecoration(
                color: context.surfaceCard.withValues(alpha: 0.85),
                border: Border(
                  bottom: BorderSide(
                    color: context.stroke.withValues(alpha: 0.6),
                    width: 1,
                  ),
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: context.textPrimary,
                          size: 20,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      4.horizontalSpace,
                      // Avatar with Realtime Online Badge
                      Stack(
                        children: [
                          Container(
                            padding: EdgeInsets.all(1.5.r),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.primary,
                                width: 2,
                              ),
                            ),
                            child: ClipOval(
                              child: targetUser.profileImageUrl.isNotEmpty
                                  ? AppCacheNetworkImage(
                                      targetUser.profileImageUrl,
                                      width: 44.r,
                                      height: 44.r,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              UserCircleAvatar(
                                                name: targetUser.name,
                                                size: 44,
                                              ),
                                    )
                                  : UserCircleAvatar(
                                      name: targetUser.name,
                                      size: 44,
                                    ),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              width: 12.r,
                              height: 12.r,
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
                      12.horizontalSpace,
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              targetUser.name,
                              color: context.textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            2.verticalSpace,
                            Row(
                              children: [
                                Container(
                                  width: 6.r,
                                  height: 6.r,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isOnline
                                        ? const Color(0xFF00E676)
                                        : const Color(0xFF9E9E9E),
                                  ),
                                ),
                                6.horizontalSpace,
                                AppText(
                                  isOnline ? 'Online now' : 'Offline',
                                  color: isOnline
                                      ? const Color(0xFF00E676)
                                      : context.textSecondary,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      PopupMenuButton<String>(
                        icon: Icon(
                          Icons.more_vert_rounded,
                          color: context.textSecondary,
                        ),
                        color: context.surfaceCard,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        onSelected: (value) {
                          if (value == 'block') {
                            onBlockTap();
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'block',
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.block_rounded,
                                  color: Colors.redAccent,
                                  size: 18,
                                ),
                                8.horizontalSpace,
                                const AppText(
                                  'Block User',
                                  color: Colors.redAccent,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
