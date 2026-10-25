import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:date_app/core/extensions/app_extensions.dart';
import 'package:date_app/core/theme/app_colors.dart';
import 'package:date_app/core/widgets/app_cache_network_image.dart';
import 'package:date_app/core/widgets/app_text.dart';
import 'package:date_app/features/global/models/user_model.dart';

class HomeSwiperCard extends StatelessWidget {
  final UserModel user;
  final int percentX;
  final VoidCallback onInfoTap;

  const HomeSwiperCard({
    super.key,
    required this.user,
    required this.percentX,
    required this.onInfoTap,
  });

  @override
  Widget build(BuildContext context) {
    final isLiking = percentX > 15;
    final isNoping = percentX < -15;
    final likeOpacity = (percentX / 100).clamp(0.0, 1.0);
    final nopeOpacity = ((-percentX) / 100).clamp(0.0, 1.0);

    return ClipRRect(
      borderRadius: BorderRadius.circular(28.r),
      child: Container(
        decoration: BoxDecoration(
          color: context.surfaceCard,
          borderRadius: BorderRadius.circular(28.r),
          border: Border.all(color: context.stroke.withValues(alpha: 0.6)),
        ),
        child: Stack(
          children: [
            // User Photo or Initials Gradient
            Positioned.fill(
              child: user.profileImageUrl.isNotEmpty
                  ? AppCacheNetworkImage(
                      user.profileImageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          HomeInitialsFullCard(user: user),
                    )
                  : HomeInitialsFullCard(user: user),
            ),

            // Gradient Overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.0, 0.4, 0.7, 1.0],
                    colors: [
                      Colors.black.withValues(alpha: 0.25),
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.6),
                      Colors.black.withValues(alpha: 0.92),
                    ],
                  ),
                ),
              ),
            ),

            // LIKE STAMP
            if (isLiking)
              Positioned(
                top: 40.h,
                left: 24.w,
                child: Opacity(
                  opacity: likeOpacity,
                  child: Transform.rotate(
                    angle: -0.2,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFF00E676),
                          width: 3.5,
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: const Text(
                        'LIKE',
                        style: TextStyle(
                          color: Color(0xFF00E676),
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

            // NOPE STAMP
            if (isNoping)
              Positioned(
                top: 40.h,
                right: 24.w,
                child: Opacity(
                  opacity: nopeOpacity,
                  child: Transform.rotate(
                    angle: 0.2,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFFFF5252),
                          width: 3.5,
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: const Text(
                        'NOPE',
                        style: TextStyle(
                          color: Color(0xFFFF5252),
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

            // User Info Overlay
            Positioned(
              left: 20.w,
              right: 20.w,
              bottom: 24.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: AppText(
                          user.name,
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      8.horizontalSpace,
                      GestureDetector(
                        onTap: onInfoTap,
                        child: Container(
                          padding: EdgeInsets.all(8.r),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.2),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.4),
                              width: 1,
                            ),
                          ),
                          child: const Icon(
                            Icons.info_outline_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  6.verticalSpace,
                  AppText(
                    user.bio.isNotEmpty
                        ? user.bio
                        : 'Looking for a genuine connection ✨',
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 14,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    lineHeight: 1.3,
                  ),
                  12.verticalSpace,
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              user.gender.toLowerCase() == 'female'
                                  ? Icons.female_rounded
                                  : Icons.male_rounded,
                              size: 14,
                              color: Colors.white,
                            ),
                            4.horizontalSpace,
                            AppText(
                              user.gender.capitalize(),
                              color: Colors.white,
                              fontSize: 12,
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
          ],
        ),
      ),
    );
  }
}

class HomeInitialsFullCard extends StatelessWidget {
  final UserModel user;

  const HomeInitialsFullCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final initial = user.name.isNotEmpty ? user.name[0].toUpperCase() : '?';
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2C1930), Color(0xFF140D18)],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90.r,
              height: 90.r,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryGradientEnd],
                ),
              ),
              child: Center(
                child: Text(
                  initial,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 42,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
            12.verticalSpace,
            AppText(
              user.name,
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ],
        ),
      ),
    );
  }
}
