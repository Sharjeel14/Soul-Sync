import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:date_app/core/extensions/app_extensions.dart';
import 'package:date_app/core/theme/app_colors.dart';
import 'package:date_app/core/widgets/app_cache_network_image.dart';
import 'package:date_app/core/widgets/app_text.dart';
import 'package:date_app/core/widgets/user_circle_avatar.dart';
import 'package:date_app/features/global/models/user_model.dart';

class HomeProfileDetailSheet extends StatelessWidget {
  final UserModel user;
  final VoidCallback onStartChat;
  final VoidCallback onBlockUser;

  const HomeProfileDetailSheet({
    super.key,
    required this.user,
    required this.onStartChat,
    required this.onBlockUser,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.82,
      decoration: BoxDecoration(
        color: context.surfaceCard,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      child: Column(
        children: [
          12.verticalSpace,
          Center(
            child: Container(
              width: 44.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: context.stroke,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(22.r),
                  child: user.profileImageUrl.isNotEmpty
                      ? AppCacheNetworkImage(
                          user.profileImageUrl,
                          height: 280.h,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              UserCircleAvatar(
                                name: user.name,
                                size: 280,
                                isCircle: false,
                              ),
                        )
                      : UserCircleAvatar(
                          name: user.name,
                          size: 280,
                          isCircle: false,
                        ),
                ),
                16.verticalSpace,
                Row(
                  children: [
                    Expanded(
                      child: AppText(
                        user.name,
                        color: context.textPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Icon(
                      Icons.verified_rounded,
                      color: AppColors.superlikeBlue,
                      size: 20,
                    ),
                  ],
                ),
                4.verticalSpace,
                AppText(
                  user.email.isNotEmpty ? user.email : user.gender.capitalize(),
                  color: context.textSecondary,
                  fontSize: 13,
                ),
                16.verticalSpace,
                AppText(
                  'About Me',
                  color: context.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
                8.verticalSpace,
                AppText(
                  user.bio.isNotEmpty ? user.bio : 'No bio provided yet.',
                  color: context.textSecondary,
                  fontSize: 14,
                  lineHeight: 1.45,
                ),
                24.verticalSpace,
                // Action Buttons: Chat & Block
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                        ),
                        icon: const Icon(
                          Icons.chat_bubble_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                        label: const AppText(
                          'Start Conversation',
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                        onPressed: onStartChat,
                      ),
                    ),
                    12.horizontalSpace,
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.redAccent,
                        side: const BorderSide(color: Colors.redAccent),
                        padding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 14.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ),
                      icon: const Icon(Icons.block_rounded, size: 18),
                      label: const AppText(
                        'Block',
                        color: Colors.redAccent,
                        fontWeight: FontWeight.w600,
                      ),
                      onPressed: onBlockUser,
                    ),
                  ],
                ),
                30.verticalSpace,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
