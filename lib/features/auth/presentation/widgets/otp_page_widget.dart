import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:date_app/core/extensions/app_extensions.dart';
import 'package:date_app/core/theme/app_colors.dart';
import 'package:date_app/core/widgets/app_loader.dart';
import 'package:date_app/core/widgets/app_text.dart';

import 'auth_logo_widget.dart';

class OtpTopLogo extends StatelessWidget {
  const OtpTopLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          right: context.isRTL ? 10 : null,
          left: context.isRTL ? null : 10,
          child: IconButton(
            padding: EdgeInsets.zero,
            splashRadius: 1,
            onPressed: () => context.safePop(),
            icon: Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: context.stroke,
                ),
                color: context.surfaceCard,
              ),
              child: Icon(
                Icons.chevron_left,
                color: context.textPrimary,
                size: 22,
              ),
            ),
          ),
        ),

        Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const MyDatingLogo(),
              8.verticalSpace,
              AppText(
                context.tr.enterVerificationCode,
                textAlign: TextAlign.center,
                color: context.textPrimary,
                fontWeight: FontWeight.w400,
                fontSize: 20,
              ),
              8.verticalSpace,
              AppText(
                context.tr.otpSubtitle,
                textAlign: TextAlign.center,
                color: context.textSecondary,
                fontWeight: FontWeight.w400,
                fontSize: 13,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ResendOtpPrompt extends StatelessWidget {
  final VoidCallback? onResendTap;
  final bool isDisabled;
  final bool isLoading;

  const ResendOtpPrompt({
    super.key,
    this.onResendTap,
    this.isDisabled = false,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Opacity(
          opacity: isLoading ? 0.3 : 1,
          child: IgnorePointer(
            ignoring: isLoading,
            child: Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                AppText(
                  context.tr.didntReceiveCode,
                  color: context.textSecondary,
                  textAlign: TextAlign.center,
                  fontSize: 13,
                ),
                3.horizontalSpace,
                GestureDetector(
                  key: ValueKey(
                    'resend_code_${isDisabled ? 'disabled' : 'enabled'}',
                  ),
                  onTap: isDisabled ? null : onResendTap,
                  behavior: HitTestBehavior.opaque,
                  child: AppText(
                    context.tr.resendCode,
                    color: isDisabled
                        ? context.textSecondary
                        : AppColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),

        if (isLoading)
          const SizedBox(
            // width: 18,
            // height: 18,
            child: AppLoader(strokeWidth: 2),
          ),
      ],
    );
  }
}
