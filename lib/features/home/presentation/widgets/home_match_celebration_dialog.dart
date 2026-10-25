import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:date_app/core/extensions/app_extensions.dart';
import 'package:date_app/core/theme/app_colors.dart';
import 'package:date_app/core/widgets/app_text.dart';
import 'package:date_app/features/global/models/user_model.dart';

class HomeMatchCelebrationDialog extends StatelessWidget {
  final UserModel matchedUser;
  final VoidCallback onSendMessage;
  final VoidCallback onKeepSwiping;

  const HomeMatchCelebrationDialog({
    super.key,
    required this.matchedUser,
    required this.onSendMessage,
    required this.onKeepSwiping,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        padding: EdgeInsets.all(24.r),
        decoration: BoxDecoration(
          color: context.surfaceCard,
          borderRadius: BorderRadius.circular(28.r),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.4),
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.15),
              ),
              child: const Icon(
                Icons.favorite_rounded,
                color: AppColors.primary,
                size: 40,
              ),
            ),
            16.verticalSpace,
            const AppText(
              "It's a Match!",
              color: AppColors.primary,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
            8.verticalSpace,
            AppText(
              'You and ${matchedUser.name} liked each other.',
              color: context.textSecondary,
              fontSize: 14,
              textAlign: TextAlign.center,
            ),
            24.verticalSpace,
            SizedBox(
              width: double.infinity,
              height: 48.h,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                ),
                onPressed: onSendMessage,
                child: const AppText(
                  'Send Message',
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            12.verticalSpace,
            TextButton(
              onPressed: onKeepSwiping,
              child: AppText(
                'Keep Swiping',
                color: context.textSecondary,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
