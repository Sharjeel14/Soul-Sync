import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:date_app/core/extensions/app_extensions.dart';
import 'package:date_app/core/router/routes.dart';
import 'package:date_app/core/theme/app_colors.dart';
import 'package:date_app/core/widgets/app_cache_network_image.dart';
import 'package:date_app/core/widgets/app_text.dart';
import 'package:date_app/core/widgets/user_circle_avatar.dart';
import 'package:date_app/features/chat/models/conversation_item.dart';

class ConversationItemTile extends StatelessWidget {
  final ConversationItem conversation;
  final bool isOnline;

  const ConversationItemTile({
    super.key,
    required this.conversation,
    required this.isOnline,
  });

  static String formatTime(DateTime? time) {
    if (time == null) return '';
    final now = DateTime.now();
    final diff = now.difference(time);
    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24 && diff.inDays == 0 && time.day == now.day) {
      return DateFormat.jm().format(time);
    }
    if (diff.inDays < 2) return 'Yesterday';
    if (diff.inDays < 7) return DateFormat.E().format(time);
    return DateFormat.MMMd().format(time);
  }

  @override
  Widget build(BuildContext context) {
    final user = conversation.user;
    final lastMsg = conversation.lastMessage;
    final hasUnread = conversation.unreadCount > 0;

    final messageText = lastMsg != null
        ? (lastMsg.text.isNotEmpty
              ? lastMsg.text
              : (lastMsg.imageUrl != null ? '📷 Photo' : ''))
        : 'Say hello to ${user.name.split(',').first} 👋';

    return InkWell(
      onTap: () {
        context.push(AppRoutes.chat, extra: user);
      },
      borderRadius: BorderRadius.circular(16.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4.h),
        child: Row(
          children: [
            Stack(
              children: [
                ClipOval(
                  child: user.profileImageUrl.isNotEmpty
                      ? AppCacheNetworkImage(
                          user.profileImageUrl,
                          width: 54.r,
                          height: 54.r,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              UserCircleAvatar(name: user.name, size: 54),
                        )
                      : UserCircleAvatar(name: user.name, size: 54),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 14.r,
                    height: 14.r,
                    decoration: BoxDecoration(
                      color: isOnline
                          ? const Color(0xFF00E676)
                          : const Color(0xFF9E9E9E),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: context.appBackground,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: AppText(
                          user.name,
                          color: context.textPrimary,
                          fontSize: 15,
                          fontWeight: hasUnread
                              ? FontWeight.w700
                              : FontWeight.w600,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      8.horizontalSpace,
                      AppText(
                        formatTime(lastMsg?.timestamp),
                        color: hasUnread
                            ? AppColors.primary
                            : context.textSecondary,
                        fontSize: 11,
                        fontWeight: hasUnread
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ],
                  ),
                  4.verticalSpace,
                  Row(
                    children: [
                      Expanded(
                        child: AppText(
                          messageText,
                          color: hasUnread
                              ? context.textPrimary
                              : context.textSecondary,
                          fontSize: 13,
                          fontWeight: hasUnread
                              ? FontWeight.w600
                              : FontWeight.w400,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (hasUnread) ...[
                        8.horizontalSpace,
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 2.h,
                          ),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: AppText(
                            conversation.unreadCount > 9
                                ? '9+'
                                : conversation.unreadCount.toString(),
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
