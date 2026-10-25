import 'dart:io';

import 'package:date_app/core/widgets/theme_toggle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:date_app/core/constants/app_constants.dart';
import 'package:date_app/core/di/injection_container.dart';
import 'package:date_app/core/extensions/app_extensions.dart';
import 'package:date_app/core/router/routes.dart';
import 'package:date_app/core/services/flutter_toast_service.dart';
import 'package:date_app/core/theme/app_colors.dart';
import 'package:date_app/core/utils/general_utils.dart';
import 'package:date_app/core/widgets/app_button.dart';
import 'package:date_app/core/widgets/app_system_overlay.dart';
import 'package:date_app/core/widgets/app_text.dart';
import 'package:date_app/core/widgets/app_text_form_field.dart';
import 'package:date_app/features/auth/bloc/auth_cubit.dart';
import 'package:date_app/features/auth/bloc/auth_state.dart';
import 'package:date_app/features/auth/presentation/widgets/register_page_widget.dart';
import 'package:date_app/features/global/bloc/global_cubit.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _mobileController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  Future<void> _showImagePickerModal(BuildContext cubitContext) async {
    showModalBottomSheet(
      context: context,
      backgroundColor: context.surfaceCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (bottomSheetContext) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppText(
                  'Choose Profile Picture',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: context.textPrimary,
                ),
                16.verticalSpace,
                ListTile(
                  leading: const Icon(
                    Icons.photo_library,
                    color: AppColors.primary,
                  ),
                  title: AppText(
                    'Gallery',
                    color: context.textPrimary,
                    fontSize: 14,
                  ),
                  onTap: () async {
                    final cubit = cubitContext.read<AuthCubit>();
                    Navigator.pop(bottomSheetContext);
                    final picked = await _picker.pickImage(
                      source: ImageSource.gallery,
                      maxWidth: 1024,
                      maxHeight: 1024,
                      imageQuality: 85,
                    );
                    if (picked != null) {
                      cubit.pickImage(File(picked.path));
                    }
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.camera_alt,
                    color: AppColors.primary,
                  ),
                  title: AppText(
                    'Camera',
                    color: context.textPrimary,
                    fontSize: 14,
                  ),
                  onTap: () async {
                    final cubit = cubitContext.read<AuthCubit>();
                    Navigator.pop(bottomSheetContext);
                    final picked = await _picker.pickImage(
                      source: ImageSource.camera,
                      maxWidth: 1024,
                      maxHeight: 1024,
                      imageQuality: 85,
                    );
                    if (picked != null) {
                      cubit.pickImage(File(picked.path));
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthCubit>(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state.loginStatus == AuthStatus.needsEmailVerification) {
            ToastService.showPrimary(
              'Account created! Please verify your email.',
            );
            context.go(AppRoutes.emailVerification);
          } else if (state.loginStatus == AuthStatus.success) {
            context.read<GlobalCubit>().getUser();
            context.go(AppRoutes.bottomNavBar);
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
              body: SafeArea(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    // vertical: 12.h,
                  ),
                  child: Stack(
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            RegisterBrandHeader(
                              title: context.tr.createYourAccount,
                            ),
                            20.verticalSpace,
                            // ── Profile Image Picker Avatar ──
                            Center(
                              child: Stack(
                                children: [
                                  GestureDetector(
                                    onTap: () => _showImagePickerModal(context),
                                    child: Container(
                                      width: 100.r,
                                      height: 100.r,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: context.surfaceCard,
                                        border: Border.all(
                                          color: AppColors.primary,
                                          width: 2,
                                        ),
                                        image: state.profileImage != null
                                            ? DecorationImage(
                                                image: FileImage(
                                                  state.profileImage!,
                                                ),
                                                fit: BoxFit.cover,
                                              )
                                            : null,
                                      ),
                                      child: state.profileImage == null
                                          ? Icon(
                                              Icons.person,
                                              size: 50.r,
                                              color: context.textSecondary,
                                            )
                                          : null,
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: GestureDetector(
                                      onTap: () =>
                                          _showImagePickerModal(context),
                                      child: Container(
                                        width: 32.r,
                                        height: 32.r,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColors.primary,
                                        ),
                                        child: const Icon(
                                          Icons.camera_alt,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            8.verticalSpace,
                            Center(
                              child: AppText(
                                'Add Profile Photo',
                                color: context.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                            20.verticalSpace,

                            // ── Full Name ──
                            AppText(
                              context.tr.fullName,
                              color: context.textSecondary,
                              fontSize: 13,
                            ),
                            5.verticalSpace,
                            AppTextFormField(
                              controller: _nameController,
                              hintText: context.tr.fullNameHint,
                              validator: (val) {
                                if (val?.isEmpty ?? true) {
                                  return context.tr.enterFullNameError;
                                }
                                return null;
                              },
                            ),
                            16.verticalSpace,

                            // ── Email ──
                            AppText(
                              'Email Address',
                              color: context.textSecondary,
                              fontSize: 13,
                            ),
                            5.verticalSpace,
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

                            // ── Gender ──
                            RegisterGenderField(
                              value: state.gender,
                              onChanged: (v) {
                                if (v != null) {
                                  context.read<AuthCubit>().updateGender(v);
                                }
                              },
                            ),
                            16.verticalSpace,

                            // ── Password ──
                            AppText(
                              'Password',
                              color: context.textSecondary,
                              fontSize: 13,
                            ),
                            5.verticalSpace,
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
                                if (val == null || val.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                            ),
                            16.verticalSpace,

                            // ── Confirm Password ──
                            AppText(
                              'Confirm Password',
                              color: context.textSecondary,
                              fontSize: 13,
                            ),
                            5.verticalSpace,
                            AppTextFormField(
                              controller: _confirmPasswordController,
                              hintText: '••••••••',
                              obscureText: !state.isConfirmPasswordVisible,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  state.isConfirmPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: context.textSecondary,
                                  size: 20,
                                ),
                                onPressed: () => context
                                    .read<AuthCubit>()
                                    .toggleConfirmPasswordVisibility(),
                              ),
                              validator: (val) {
                                if (val != _passwordController.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                            ),
                            30.verticalSpace,

                            AppButton(
                              label: 'Register',
                              isLoading: state.isLoading,
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  closeKeyboard();
                                  final fullPhone =
                                      '+${AppCountryCodes.saCountryCode}${_mobileController.text.trim()}';
                                  context.read<AuthCubit>().register(
                                    name: _nameController.text.trim(),
                                    email: _emailController.text.trim(),
                                    password: _passwordController.text,
                                    phone: fullPhone,
                                    profileImage: state.profileImage,
                                  );
                                }
                              },
                            ),
                            24.verticalSpace,
                          ],
                        ),
                      ),
                      Positioned(top: 16, right: 0, child: ThemeToggleWidget()),
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
