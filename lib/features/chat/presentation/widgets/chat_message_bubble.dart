import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:date_app/core/extensions/app_extensions.dart';
import 'package:date_app/core/theme/app_colors.dart';
import 'package:date_app/core/widgets/app_cache_network_image.dart';
import 'package:date_app/core/widgets/app_text.dart';
import 'package:date_app/core/widgets/user_circle_avatar.dart';
import 'package:date_app/features/chat/models/chat_message.dart';

class ChatMessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isMe;
  final String userAvatar;

  const ChatMessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    required this.userAvatar,
  });

  void _openFullScreenImage(BuildContext context, String imageUrl) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: PhotoView(
            imageProvider: CachedNetworkImageProvider(imageUrl),
            heroAttributes: PhotoViewHeroAttributes(tag: imageUrl),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 2.5,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final timeStr = DateFormat('hh:mm a').format(message.timestamp);
    final hasImage = message.imageUrl != null && message.imageUrl!.isNotEmpty;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            ClipOval(
              child: userAvatar.isNotEmpty
                  ? AppCacheNetworkImage(
                      userAvatar,
                      width: 28.r,
                      height: 28.r,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          UserCircleAvatar(name: 'User', size: 28),
                    )
                  : UserCircleAvatar(name: 'User', size: 28),
            ),
            8.horizontalSpace,
          ],
          Flexible(
            child: Container(
              padding: EdgeInsets.all(hasImage ? 6.r : 12.r),
              decoration: BoxDecoration(
                gradient: isMe
                    ? const LinearGradient(
                        colors: [
                          AppColors.primary,
                          AppColors.primaryGradientEnd,
                        ],
                      )
                    : null,
                color: isMe ? null : context.surfaceCard,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18.r),
                  topRight: Radius.circular(18.r),
                  bottomLeft: Radius.circular(isMe ? 18.r : 4.r),
                  bottomRight: Radius.circular(isMe ? 4.r : 18.r),
                ),
                border: isMe
                    ? null
                    : Border.all(
                        color: context.stroke.withValues(alpha: 0.6),
                        width: 1,
                      ),
                boxShadow: isMe
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.25),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : null,
              ),
              child: Column(
                crossAxisAlignment: isMe
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  if (hasImage) ...[
                    GestureDetector(
                      onTap: () =>
                          _openFullScreenImage(context, message.imageUrl!),
                      child: Hero(
                        tag: message.imageUrl!,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(14.r),
                          child: AppCacheNetworkImage(
                            message.imageUrl!,
                            width: 220.w,
                            height: 220.w,
                            fit: BoxFit.cover,
                            loaderBuilder: (context, url) => Container(
                              width: 220.w,
                              height: 220.w,
                              color: Colors.black12,
                              child: const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  width: 220.w,
                                  height: 220.w,
                                  color: Colors.black12,
                                  child: const Icon(Icons.broken_image_rounded),
                                ),
                          ),
                        ),
                      ),
                    ),
                    if (message.text.isNotEmpty &&
                        message.text != '📷 Photo') ...[
                      6.verticalSpace,
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6.w),
                        child: AppText(
                          message.text,
                          color: isMe ? AppColors.white : context.textPrimary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ] else ...[
                    AppText(
                      message.text,
                      color: isMe ? AppColors.white : context.textPrimary,
                      fontSize: 14,
                      lineHeight: 1.35,
                    ),
                  ],
                  4.verticalSpace,
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: hasImage ? 6.w : 0,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppText(
                          timeStr,
                          color: isMe
                              ? AppColors.white.withValues(alpha: 0.75)
                              : context.textSecondary,
                          fontSize: 10,
                        ),
                        if (isMe) ...[
                          4.horizontalSpace,
                          Icon(
                            message.isRead
                                ? Icons.done_all_rounded
                                : Icons.done_rounded,
                            size: 13.sp,
                            color: message.isRead
                                ? AppColors.white
                                : AppColors.white.withValues(alpha: 0.5),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
