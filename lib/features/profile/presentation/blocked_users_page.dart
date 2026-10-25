import 'package:date_app/core/widgets/app_cache_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:date_app/core/di/injection_container.dart';
import 'package:date_app/core/extensions/app_extensions.dart';
import 'package:date_app/core/services/flutter_toast_service.dart';
import 'package:date_app/core/theme/app_colors.dart';
import 'package:date_app/core/widgets/app_system_overlay.dart';
import 'package:date_app/core/widgets/app_text.dart';
import 'package:date_app/features/global/models/user_model.dart';
import 'package:date_app/features/profile/repository/block_repository.dart';

class BlockedUsersPage extends StatelessWidget {
  const BlockedUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final blockRepo = getIt<BlockRepository>();

    return AppSystemOverlay(
      child: Scaffold(
        backgroundColor: context.appBackground,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: context.textPrimary,
              size: 20,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: AppText(
            'Blocked Users',
            color: context.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        body: StreamBuilder<List<UserModel>>(
          stream: blockRepo.streamBlockedUsers(),
          builder: (context, snapshot) {
            final blockedUsers = snapshot.data ?? [];

            if (blockedUsers.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 80.r,
                        height: 80.r,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary.withValues(alpha: 0.12),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.3),
                          ),
                        ),
                        child: const Icon(
                          Icons.person_off_rounded,
                          color: AppColors.primary,
                          size: 40,
                        ),
                      ),
                      20.verticalSpace,
                      AppText(
                        'No Blocked Users',
                        color: context.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                      8.verticalSpace,
                      AppText(
                        'Users you block will appear here. You can unblock them anytime to connect again.',
                        color: context.textSecondary,
                        fontSize: 13,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }

            return ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              itemCount: blockedUsers.length,
              separatorBuilder: (context, index) => 12.verticalSpace,
              itemBuilder: (context, index) {
                final user = blockedUsers[index];

                return Container(
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    color: context.surfaceCard,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: context.stroke),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: user.profileImageUrl.isNotEmpty
                            ? AppCacheNetworkImage(
                                user.profileImageUrl,
                                width: 50.r,
                                height: 50.r,
                                fit: BoxFit.cover,
                                errorBuilder: (context, url, error) =>
                                    _InitialsPlaceholder(name: user.name),
                              )
                            : _InitialsPlaceholder(name: user.name),
                      ),
                      14.horizontalSpace,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              user.name,
                              color: context.textPrimary,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                            2.verticalSpace,
                            AppText(
                              user.email.isNotEmpty
                                  ? user.email
                                  : user.gender.capitalize(),
                              color: context.textSecondary,
                              fontSize: 12,
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary.withValues(
                            alpha: 0.15,
                          ),
                          foregroundColor: AppColors.primary,
                          elevation: 0,
                          padding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 8.h,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            side: const BorderSide(color: AppColors.primary),
                          ),
                        ),
                        onPressed: () async {
                          await blockRepo.unblockUser(user.uid);
                          ToastService.showPrimary('Unblocked ${user.name}');
                        },
                        child: const AppText(
                          'Unblock',
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _InitialsPlaceholder extends StatelessWidget {
  final String name;

  const _InitialsPlaceholder({required this.name});

  @override
  Widget build(BuildContext context) {
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';
    return Container(
      width: 50.r,
      height: 50.r,
      color: AppColors.primary.withValues(alpha: 0.15),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: const TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.w800,
          fontSize: 18,
        ),
      ),
    );
  }
}
