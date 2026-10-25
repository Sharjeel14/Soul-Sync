import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:date_app/core/extensions/app_extensions.dart';
import 'package:date_app/core/router/routes.dart';
import 'package:date_app/core/theme/app_colors.dart';
import 'package:date_app/core/widgets/app_cache_network_image.dart';
import 'package:date_app/core/widgets/app_text.dart';
import 'package:date_app/core/widgets/user_circle_avatar.dart';
import 'package:date_app/features/matches/models/match_item_model.dart';

class MatchesMutualRow extends StatelessWidget {
  final List<MatchItemModel> matches;

  const MatchesMutualRow({super.key, required this.matches});

  @override
  Widget build(BuildContext context) {
    if (matches.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          'Mutual Matches (${matches.length})',
          color: context.textPrimary,
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
        12.verticalSpace,
        SizedBox(
          height: 130.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: matches.length,
            separatorBuilder: (context, index) => 14.horizontalSpace,
            itemBuilder: (context, index) {
              final match = matches[index];
              final user = match.user;

              return GestureDetector(
                onTap: () {
                  context.push(AppRoutes.chat, extra: user);
                },
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.primary, width: 2),
                      ),
                      child: ClipOval(
                        child: user.profileImageUrl.isNotEmpty
                            ? AppCacheNetworkImage(
                                user.profileImageUrl,
                                width: 68.r,
                                height: 68.r,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    UserCircleAvatar(name: user.name, size: 66),
                              )
                            : UserCircleAvatar(name: user.name, size: 66),
                      ),
                    ),
                    6.verticalSpace,
                    SizedBox(
                      width: 70.w,
                      child: AppText(
                        user.name.split(',').first,
                        color: context.textPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
