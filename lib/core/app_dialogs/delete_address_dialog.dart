// lib/core/app_dialogs/delete_address_dialog.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:date_app/core/extensions/app_extensions.dart';
import 'package:date_app/core/theme/app_colors.dart';
import 'package:date_app/core/widgets/app_button.dart';
import 'package:date_app/core/widgets/app_text.dart';

class DeleteAddressDialog extends StatelessWidget {
  const DeleteAddressDialog({super.key});

  static Future<bool?> show(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => const DeleteAddressDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.background,
      insetPadding: const EdgeInsets.all(24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: AppColors.primary.withValues(alpha: 0.2),
          width: 1.2,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary.withValues(alpha: 0.2),
              AppColors.primary.withValues(alpha: 0.1),
            ],
          ),
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
              child: Icon(CupertinoIcons.delete, color: Colors.white, size: 30),
            ),
            20.verticalSpace,
            AppText(
              context.tr.deleteAddress,
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            12.verticalSpace,
            AppText(
              context.tr.areYouSureYouWantToDeleteYourAddress,
              textAlign: TextAlign.center,
              color: Colors.white70,
              fontSize: 15,
              lineHeight: 1.5,
            ),
            12.verticalSpace,
            AppText(
              context.tr.thisActionCannotBeUndone,
              textAlign: TextAlign.center,
              color: Colors.white70,
              fontSize: 13,
            ),
            28.verticalSpace,
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    onPressed: () {
                      context.safePop(false);
                    },
                    backgroundColor: Colors.white.withValues(alpha: 0.1),
                    textColor: Colors.white,
                    borderColor: AppColors.primary.withValues(alpha: 0.3),
                    borderRadius: 14,
                    label: context.tr.cancel,
                  ),
                ),
                14.horizontalSpace,
                Expanded(
                  child: AppButton(
                    onPressed: () {
                      context.safePop(true);
                    },
                    backgroundColor: AppColors.primary,
                    borderColor: AppColors.primary,
                    borderRadius: 14,
                    label: context.tr.confirm,
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
