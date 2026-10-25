import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'package:date_app/core/di/injection_container.dart';
import 'package:date_app/core/enums/signup_page_type.dart';
import 'package:date_app/core/extensions/app_extensions.dart';
import 'package:date_app/core/router/routes.dart';
import 'package:date_app/core/services/flutter_toast_service.dart';
import 'package:date_app/core/theme/app_colors.dart';
import 'package:date_app/core/utils/general_utils.dart';
import 'package:date_app/core/widgets/app_button.dart';
import 'package:date_app/core/widgets/app_system_overlay.dart';
import 'package:date_app/core/widgets/app_text.dart';
import 'package:date_app/features/auth/bloc/auth_cubit.dart';
import 'package:date_app/features/auth/bloc/auth_state.dart';
import 'package:date_app/features/auth/presentation/widgets/otp_page_widget.dart';
import 'package:date_app/features/global/bloc/global_cubit.dart';

class OtpPage extends StatelessWidget {
  final Map<String, dynamic> data;
  final OtpPageRouteType pageType;

  OtpPage({super.key, required this.data, required this.pageType});

  final _otpController = TextEditingController();
  final _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 48.r,
      height: 54.r,
      textStyle: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: AppColors.primary,
      ),
      decoration: BoxDecoration(
        color: context.surfaceCard,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: context.stroke),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: AppColors.primary, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.1),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
    );

    final errorPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: Colors.red, width: 1.5),
      ),
    );

    final verificationId = data['verificationId'] as String? ?? '';
    final phone = data['phone'] as String? ?? '';

    return AppSystemOverlay(
      child: BlocProvider(
        create: (context) => getIt<AuthCubit>(),
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state.loginStatus == AuthStatus.otpResendSuccess) {
              ToastService.showPrimary('Verification code resent');
            }
            if (state.loginStatus == AuthStatus.success) {
              context.read<AuthCubit>().clearMessage();
              context.read<GlobalCubit>().getUser();
              context.go(AppRoutes.bottomNavBar);
            }
          },
          builder: (context, state) {
            final hasError =
                state.loginStatus == AuthStatus.failure &&
                state.message != null &&
                state.message!.isNotEmpty;

            return Scaffold(
              backgroundColor: context.appBackground,
              body: SafeArea(
                child: Column(
                  children: [
                    32.verticalSpace,
                    const OtpTopLogo(),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: 360.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                12.verticalSpace,
                                if (phone.isNotEmpty) ...[
                                  AppText(
                                    'Code sent to $phone',
                                    color: context.textSecondary,
                                    fontSize: 13,
                                    textAlign: TextAlign.center,
                                  ),
                                  16.verticalSpace,
                                ],
                                Center(
                                  child: Directionality(
                                    textDirection: TextDirection.ltr,
                                    child: Pinput(
                                      length: 6,
                                      controller: _otpController,
                                      focusNode: _focusNode,
                                      defaultPinTheme: hasError
                                          ? errorPinTheme
                                          : defaultPinTheme,
                                      focusedPinTheme: hasError
                                          ? errorPinTheme
                                          : focusedPinTheme,
                                      separatorBuilder: (index) => Gap(8.w),
                                      hapticFeedbackType:
                                          HapticFeedbackType.lightImpact,
                                      onChanged: (_) {
                                        if (hasError) {
                                          context
                                              .read<AuthCubit>()
                                              .clearMessage();
                                        }
                                      },
                                      onCompleted: (pin) {
                                        closeKeyboard();
                                        context
                                            .read<AuthCubit>()
                                            .verifyPhoneOtp(
                                              verificationId: verificationId,
                                              smsCode: pin,
                                            );
                                      },
                                    ),
                                  ),
                                ),
                                if (hasError) ...[
                                  8.verticalSpace,
                                  Center(
                                    child: AppText(
                                      state.message!,
                                      color: Colors.red,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                                24.verticalSpace,
                                ResendOtpPrompt(
                                  onResendTap: () {
                                    if (phone.isNotEmpty) {
                                      context.read<AuthCubit>().sendPhoneOtp(
                                        phone,
                                      );
                                    }
                                  },
                                  isDisabled:
                                      state.loginStatus ==
                                      AuthStatus.otpResendSuccess,
                                  isLoading:
                                      state.loginStatus ==
                                      AuthStatus.otpResendLoading,
                                ),
                                24.verticalSpace,
                                AppButton(
                                  isLoading: state.isLoading,
                                  label: context.tr.submit,
                                  onPressed: () {
                                    closeKeyboard();
                                    context.read<AuthCubit>().verifyPhoneOtp(
                                      verificationId: verificationId,
                                      smsCode: _otpController.text.trim(),
                                    );
                                  },
                                ),
                                32.verticalSpace,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Padding(
                    //   padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 38.h),
                    //   child: const LanguageToggle(),
                    // ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
