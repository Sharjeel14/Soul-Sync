import 'package:date_app/core/constants/app_images.dart';
import 'package:date_app/core/widgets/animated_loader.dart';
import 'package:date_app/core/widgets/app_icon.dart';
import 'package:date_app/core/widgets/theme_toggle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:date_app/core/constants/app_constants.dart';
import 'package:date_app/core/di/injection_container.dart';
import 'package:date_app/core/enums/signup_page_type.dart';
import 'package:date_app/core/extensions/app_extensions.dart';
import 'package:date_app/core/router/routes.dart';
import 'package:date_app/core/services/flutter_toast_service.dart';
import 'package:date_app/core/utils/general_utils.dart';
import 'package:date_app/core/widgets/app_button.dart';
import 'package:date_app/core/widgets/app_phone_form_field.dart';
import 'package:date_app/core/widgets/app_system_overlay.dart';
import 'package:date_app/core/widgets/app_text.dart';
import 'package:date_app/core/widgets/app_text_form_field.dart';
import 'package:date_app/features/auth/bloc/auth_cubit.dart';
import 'package:date_app/features/auth/bloc/auth_state.dart';
import 'package:date_app/features/auth/models/otp_page_data.dart';
import 'package:date_app/features/auth/presentation/widgets/login_page_widget.dart';
import 'package:date_app/features/global/bloc/global_cubit.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final bool _isEmailTab = true;

  @override
  void initState() {
    super.initState();
    getIt<AuthCubit>().clearUserSession();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthCubit>(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state.loginStatus == AuthStatus.success) {
            context.read<GlobalCubit>().getUser();
            context.go(AppRoutes.bottomNavBar);
          } else if (state.loginStatus == AuthStatus.needsEmailVerification) {
            context.push(AppRoutes.emailVerification);
          } else if (state.loginStatus == AuthStatus.otpSent) {
            final formattedPhone =
                '+${AppCountryCodes.saCountryCode}${_phoneController.text.trim()}';
            context.push(
              AppRoutes.otp,
              extra: OtpPageData(
                data: {
                  'phone': formattedPhone,
                  'verificationId': state.phoneVerificationId,
                },
                pageType: OtpPageRouteType.login,
              ),
            );
          } else if (state.loginStatus == AuthStatus.failure &&
              state.message != null &&
              state.message!.isNotEmpty) {
            ToastService.showError(state.message!);
            context.read<AuthCubit>().clearMessage();
          }
        },
        builder: (context, state) {
          return AppSystemOverlay(
            child: Scaffold(
              backgroundColor: context.appBackground,

              body: Stack(
                children: [
                  SafeArea(
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 16.h,
                        ),
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                20.verticalSpace,
                                const LoginTopLogo(),
                                24.verticalSpace,

                                // ── Tab Selector: Email vs Phone ──
                                // Container(
                                //   padding: EdgeInsets.all(4.r),
                                //   decoration: BoxDecoration(
                                //     color: AppColors.white.withValues(alpha: 0.06),
                                //     borderRadius: BorderRadius.circular(12.r),
                                //   ),
                                //   child: Row(
                                //     children: [
                                //       Expanded(
                                //         child: GestureDetector(
                                //           onTap: () =>
                                //               setState(() => _isEmailTab = true),
                                //           child: Container(
                                //             padding: EdgeInsets.symmetric(
                                //               vertical: 10.h,
                                //             ),
                                //             decoration: BoxDecoration(
                                //               color: _isEmailTab
                                //                   ? AppColors.primary
                                //                   : Colors.transparent,
                                //               borderRadius: BorderRadius.circular(10.r),
                                //             ),
                                //             child: Center(
                                //               child: AppText(
                                //                 'Email Login',
                                //                 color: AppColors.white,
                                //                 fontWeight: _isEmailTab
                                //                     ? FontWeight.w600
                                //                     : FontWeight.w400,
                                //                 fontSize: 13,
                                //               ),
                                //             ),
                                //           ),
                                //         ),
                                //       ),
                                //       Expanded(
                                //         child: GestureDetector(
                                //           onTap: () =>
                                //               setState(() => _isEmailTab = false),
                                //           child: Container(
                                //             padding: EdgeInsets.symmetric(
                                //               vertical: 10.h,
                                //             ),
                                //             decoration: BoxDecoration(
                                //               color: !_isEmailTab
                                //                   ? AppColors.primary
                                //                   : Colors.transparent,
                                //               borderRadius: BorderRadius.circular(10.r),
                                //             ),
                                //             child: Center(
                                //               child: AppText(
                                //                 'Phone Login',
                                //                 color: AppColors.white,
                                //                 fontWeight: !_isEmailTab
                                //                     ? FontWeight.w600
                                //                     : FontWeight.w400,
                                //                 fontSize: 13,
                                //               ),
                                //             ),
                                //           ),
                                //         ),
                                //       ),
                                //     ],
                                //   ),
                                // ),
                                // 24.verticalSpace,
                                if (_isEmailTab) ...[
                                  AppText(
                                    'Email Address',
                                    color: context.textSecondary,
                                    fontSize: 13,
                                  ),
                                  6.verticalSpace,
                                  AppTextFormField(
                                    controller: _emailController,
                                    hintText: 'name@example.com',
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (val) {
                                      if (val?.isEmpty ?? true) {
                                        return 'Please enter email';
                                      }
                                      if (!val!.contains('@')) {
                                        return 'Please enter valid email';
                                      }
                                      return null;
                                    },
                                  ),
                                  16.verticalSpace,
                                  AppText(
                                    'Password',
                                    color: context.textSecondary,
                                    fontSize: 13,
                                  ),
                                  6.verticalSpace,
                                  AppTextFormField(
                                    controller: _passwordController,
                                    hintText: '••••••••',
                                    obscureText: !state.isPasswordVisible,
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        state.isPasswordVisible
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: context.textSecondary,
                                        size: 20,
                                      ),
                                      onPressed: () => context
                                          .read<AuthCubit>()
                                          .togglePasswordVisibility(),
                                    ),
                                    validator: (val) {
                                      if (val?.isEmpty ?? true) {
                                        return 'Please enter password';
                                      }
                                      return null;
                                    },
                                  ),
                                  24.verticalSpace,
                                  AppButton(
                                    isLoading:
                                        state.isLoading &&
                                        !state.isGoogleLoading,
                                    label: 'Login',
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        closeKeyboard();
                                        context
                                            .read<AuthCubit>()
                                            .loginWithEmail(
                                              email: _emailController.text
                                                  .trim(),
                                              password:
                                                  _passwordController.text,
                                            );
                                      }
                                    },
                                  ),
                                ] else ...[
                                  AppText(
                                    context.tr.enterYourMobileNumberLabel,
                                    color: context.textSecondary,
                                    fontSize: 13,
                                  ),
                                  6.verticalSpace,
                                  AppPhoneFormField(
                                    phoneCode:
                                        '🇸🇦 +${AppCountryCodes.saCountryCode}',
                                    hintText: '50 123 4567',
                                    controller: _phoneController,
                                    validator: (val) {
                                      if (val?.isEmpty ?? true) {
                                        return context
                                            .tr
                                            .enterMobileNumberError;
                                      }
                                      return null;
                                    },
                                  ),
                                  24.verticalSpace,
                                  AppButton(
                                    isLoading:
                                        state.isLoading &&
                                        !state.isGoogleLoading,
                                    label: 'Send Code',
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        closeKeyboard();
                                        final formatted =
                                            '+${AppCountryCodes.saCountryCode}${_phoneController.text.trim()}';
                                        context.read<AuthCubit>().sendPhoneOtp(
                                          formatted,
                                        );
                                      }
                                    },
                                  ),
                                ],

                                24.verticalSpace,
                                // Divider with OR
                                Row(
                                  children: [
                                    Expanded(
                                      child: Divider(color: context.stroke),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12.w,
                                      ),
                                      child: AppText(
                                        'OR',
                                        color: context.textSecondary,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Expanded(
                                      child: Divider(color: context.stroke),
                                    ),
                                  ],
                                ),
                                20.verticalSpace,

                                // ── Google Sign In Button ──
                                InkWell(
                                  onTap: state.isLoading
                                      ? null
                                      : () {
                                          closeKeyboard();
                                          context
                                              .read<AuthCubit>()
                                              .loginWithGoogle();
                                        },
                                  borderRadius: BorderRadius.circular(14.r),
                                  child: Container(
                                    height: 52.h,
                                    decoration: BoxDecoration(
                                      color: context.surfaceCard,
                                      borderRadius: BorderRadius.circular(14.r),
                                      border: Border.all(color: context.stroke),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        AppIcon(AppImages.googleIcon, size: 22),
                                        8.horizontalSpace,
                                        AppText(
                                          'Continue with Google',
                                          color: context.textPrimary,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                28.verticalSpace,
                                SignUpPrompt(
                                  onCreateAccountTap: () {
                                    context.push(
                                      AppRoutes.register,
                                      extra: {
                                        'title': context.tr.createYourAccount,
                                        'isLoggedIn': false,
                                      },
                                    );
                                  },
                                ),
                                24.verticalSpace,
                                // const Center(child: LanguageToggle()),
                                // 16.verticalSpace,
                              ],
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: ThemeToggleWidget(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // ── Full-screen Google Loading Overlay ──
                  if (state.isGoogleLoading)
                    Positioned.fill(
                      child: PopScope(
                        canPop: false,
                        child: Container(
                          color: Colors.black.withValues(alpha: 0.65),
                          child: Center(
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 32.w),
                              padding: EdgeInsets.symmetric(
                                horizontal: 28.w,
                                vertical: 24.h,
                              ),
                              decoration: BoxDecoration(
                                color: context.surfaceCard,
                                borderRadius: BorderRadius.circular(18.r),
                                border: Border.all(
                                  color: context.stroke,
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.4),
                                    blurRadius: 24,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const BreathingOpacityLoader(size: 64),
                                  18.verticalSpace,
                                  AppText(
                                    context.tr.signingInWithGoogle,
                                    color: context.textPrimary,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
