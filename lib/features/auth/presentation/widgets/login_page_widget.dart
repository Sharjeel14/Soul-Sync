import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:date_app/core/extensions/app_extensions.dart';
import 'package:date_app/core/theme/app_colors.dart';
import 'package:date_app/core/widgets/app_text.dart';

import 'auth_logo_widget.dart';

class LoginTopLogo extends StatelessWidget {
  const LoginTopLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MyDatingLogo(),
        8.verticalSpace,
        AppText(
          context.tr.loginToYourAccount,
          textAlign: TextAlign.center,
          color: context.textPrimary,
          fontWeight: FontWeight.w400,
          fontSize: 20,
        ),
      ],
    );
  }
}

class SignUpPrompt extends StatelessWidget {
  final VoidCallback? onCreateAccountTap;

  const SignUpPrompt({this.onCreateAccountTap, super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        AppText(
          context.tr.newToMyDating,
          color: context.textSecondary,
          textAlign: TextAlign.center,
          fontSize: 13,
        ),
        3.horizontalSpace,
        GestureDetector(
          onTap: onCreateAccountTap,
          behavior: HitTestBehavior.opaque,
          child: AppText(
            context.tr.createYourAccount,
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
