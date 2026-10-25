import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:date_app/core/di/injection_container.dart';
import 'package:date_app/core/extensions/app_extensions.dart';
import 'package:date_app/core/router/routes.dart';
import 'package:date_app/core/services/flutter_toast_service.dart';
import 'package:date_app/core/theme/app_colors.dart';
import 'package:date_app/core/widgets/app_button.dart';
import 'package:date_app/core/widgets/app_system_overlay.dart';
import 'package:date_app/core/widgets/app_text.dart';
import 'package:date_app/features/auth/bloc/auth_cubit.dart';
import 'package:date_app/features/auth/bloc/auth_state.dart';
import 'package:date_app/features/global/bloc/global_cubit.dart';

class EmailVerificationPage extends StatelessWidget {
  const EmailVerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthCubit>(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state.loginStatus == AuthStatus.success ||
              state.isEmailVerified) {
            ToastService.showPrimary('Email verified!');
            context.read<GlobalCubit>().getUser();
            context.go(AppRoutes.bottomNavBar);
          } else if (state.message != null && state.message!.isNotEmpty) {
            ToastService.showPrimary(state.message!);
            context.read<AuthCubit>().clearMessage();
          }
        },
        builder: (context, state) {
          return AppSystemOverlay(
            child: Scaffold(
              backgroundColor: context.appBackground,
              body: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 32.h,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Spacer(),
                      Container(
                        width: 90.r,
                        height: 90.r,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary.withValues(alpha: 0.15),
                          border: Border.all(
                            color: AppColors.primary,
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.mark_email_read_outlined,
                          size: 48,
                          color: AppColors.primary,
                        ),
                      ),
                      24.verticalSpace,
                      AppText(
                        'Verify Your Email',
                        color: context.textPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        textAlign: TextAlign.center,
                      ),
                      12.verticalSpace,
                      AppText(
                        'We sent a verification link to your email. Please check your inbox and click the verification link before proceeding.',
                        color: context.textSecondary,
                        fontSize: 14,
                        textAlign: TextAlign.center,
                      ),
                      const Spacer(),
                      AppButton(
                        label: 'I Have Verified',
                        isLoading: state.isLoading,
                        onPressed: () {
                          context.read<AuthCubit>().checkEmailVerified();
                        },
                      ),
                      12.verticalSpace,
                      AppButton(
                        label: 'Resend Verification Email',
                        backgroundColor: Colors.transparent,
                        borderColor: AppColors.primary,
                        textColor: AppColors.primary,
                        onPressed: () {
                          context.read<AuthCubit>().sendEmailVerification();
                        },
                      ),
                      16.verticalSpace,
                      TextButton(
                        onPressed: () async {
                          await context.read<AuthCubit>().logout();
                          if (context.mounted) {
                            context.go(AppRoutes.login);
                          }
                        },
                        child: AppText(
                          'Back to Login',
                          color: context.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                      16.verticalSpace,
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
