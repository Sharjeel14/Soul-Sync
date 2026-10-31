import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:date_app/core/extensions/app_extensions.dart';
import 'package:date_app/core/theme/app_colors.dart';
import 'package:date_app/core/widgets/app_button.dart';
import 'package:date_app/core/widgets/app_text.dart';

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({super.key});

  static Future<bool?> show(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => const LogoutDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: context.surfaceCard,
      insetPadding: const EdgeInsets.all(24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: context.stroke,
          width: 1.2,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: context.surfaceCard,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.1),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  width: 1.2,
                ),
              ),
              child: const Icon(
                CupertinoIcons.square_arrow_left,
                color: AppColors.primary,
                size: 30,
              ),
            ),

            const SizedBox(height: 20),

            AppText(
              context.tr.logout,
              color: context.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),

            const SizedBox(height: 12),

            AppText(
              context.tr.areYouSureYouWantToLogOut,
              textAlign: TextAlign.center,
              color: context.textSecondary,
              fontSize: 15,
              lineHeight: 1.5,
            ),

            const SizedBox(height: 28),

            Row(
              children: [
                Expanded(
                  child: AppButton(
                    onPressed: () => context.safePop(false),
                    backgroundColor: context.surfaceDark,
                    textColor: context.textPrimary,
                    borderColor: context.stroke,
                    borderRadius: 14,
                    label: context.tr.cancel,
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: AppButton(
                    onPressed: () => context.safePop(true),
                    backgroundColor: AppColors.primary,
                    borderColor: AppColors.primary,
                    borderRadius: 14,
                    label: context.tr.logout,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
