import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:date_app/core/extensions/app_extensions.dart';
import 'package:date_app/core/router/routes.dart';
import 'package:date_app/core/theme/app_colors.dart';
import 'package:date_app/core/widgets/app_cache_network_image.dart';
import 'package:date_app/core/widgets/app_text.dart';
import 'package:date_app/core/widgets/user_circle_avatar.dart';
import 'package:date_app/features/global/models/user_model.dart';

class MessagesMatchesTray extends StatelessWidget {
  final List<UserModel> matches;
  final Set<String> onlineUserIds;

  const MessagesMatchesTray({
    super.key,
    required this.matches,
    required this.onlineUserIds,
  });

  @override
  Widget build(BuildContext context) {
    if (matches.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          'Matches & Sparks (${matches.length})',
          color: context.textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
        10.verticalSpace,
        SizedBox(
          height: 90.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: matches.length,
            separatorBuilder: (context, index) => 12.horizontalSpace,
            itemBuilder: (context, index) {
              final m = matches[index];
              final isOnline = onlineUserIds.contains(m.uid);

              return GestureDetector(
                onTap: () {
                  context.push(AppRoutes.chat, extra: m);
                },
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.primary,
                              width: 2,
                            ),
                          ),
                          child: ClipOval(
                            child: m.profileImageUrl.isNotEmpty
                                ? AppCacheNetworkImage(
                                    m.profileImageUrl,
                                    width: 60.r,
                                    height: 60.r,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            UserCircleAvatar(
                                              name: m.name,
                                              size: 52,
                                            ),
                                  )
                                : UserCircleAvatar(name: m.name, size: 52),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 13.r,
                            height: 13.r,
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
                    5.verticalSpace,
                    SizedBox(
                      width: 60.w,
                      child: AppText(
                        m.name.split(',').first,
                        color: context.textPrimary,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        14.verticalSpace,
        Divider(color: context.stroke.withValues(alpha: 0.5), height: 1),
        14.verticalSpace,
      ],
    );
  }
}
