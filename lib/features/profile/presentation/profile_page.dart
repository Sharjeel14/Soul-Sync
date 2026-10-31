import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:date_app/core/di/injection_container.dart';
import 'package:date_app/core/extensions/app_extensions.dart';
import 'package:date_app/core/router/routes.dart';
import 'package:date_app/core/services/flutter_toast_service.dart';
import 'package:date_app/core/theme/app_colors.dart';
import 'package:date_app/core/utils/general_utils.dart';
import 'package:date_app/core/widgets/animated_loader.dart';
import 'package:date_app/core/widgets/app_button.dart';
import 'package:date_app/core/widgets/app_system_overlay.dart';
import 'package:date_app/core/widgets/app_text.dart';
import 'package:date_app/core/widgets/app_text_form_field.dart';
import 'package:date_app/core/widgets/theme_toggle.dart';
import 'package:date_app/features/auth/presentation/widgets/register_page_widget.dart';
import 'package:date_app/features/global/bloc/global_cubit.dart';
import 'package:date_app/features/global/models/user_model.dart';
import 'package:date_app/features/matches/repository/match_repository.dart';
import 'package:date_app/features/profile/bloc/profile_cubit.dart';
import 'package:date_app/features/profile/repository/block_repository.dart';

import 'widgets/profile_avatar_header.dart';
import 'widgets/profile_guest_prompt.dart';
import 'widgets/profile_stat_item.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ProfileCubit>(),
      child: const ProfileView(),
    );
  }
}

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();

  bool _isPopulated = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  bool _isGuest(UserModel? user) {
    if (user == null || user.uid.isEmpty) return true;
    final supaUser = Supabase.instance.client.auth.currentUser;
    if (supaUser == null || supaUser.isAnonymous) return true;
    return false;
  }

  void _populateFields(ProfileState state) {
    if (!_isPopulated && state.user != null) {
      _nameController.text = state.user!.name;
      _emailController.text = state.user!.email;
      _phoneController.text = state.user!.phone;
      _isPopulated = true;
    }
  }

  Future<void> _showImagePicker(BuildContext cubitContext) async {
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
                  'Update Profile Picture',
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
                    'Choose from Gallery',
                    color: context.textPrimary,
                    fontSize: 14,
                  ),
                  onTap: () async {
                    final cubit = cubitContext.read<ProfileCubit>();
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
                    'Take a Photo',
                    color: context.textPrimary,
                    fontSize: 14,
                  ),
                  onTap: () async {
                    final cubit = cubitContext.read<ProfileCubit>();
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

  void _showLogoutDialog(BuildContext cubitContext) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: context.surfaceCard,
          title: AppText(
            'Logout',
            color: context.textPrimary,
            fontWeight: FontWeight.w600,
          ),
          content: AppText(
            'Are you sure you want to sign out?',
            color: context.textSecondary,
            fontSize: 14,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: AppText('Cancel', color: context.textSecondary),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
              onPressed: () async {
                Navigator.pop(dialogContext);
                await cubitContext.read<ProfileCubit>().logout();
                if (mounted) {
                  await GlobalCubit.logout(context);
                }
              },
              child: const AppText(
                'Logout',
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppSystemOverlay(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: AppText(
            'My Profile',
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.white
                : AppColors.textPrimaryLight,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
          actions: [
            const ThemeToggleWidget(),
            6.horizontalSpace,
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.redAccent),
              onPressed: () => _showLogoutDialog(context),
            ),
            8.horizontalSpace,
          ],
        ),
        body: BlocConsumer<ProfileCubit, ProfileState>(
          listener: (context, state) {
            _populateFields(state);

            final successMessage = state.successMessage;
            final errorMessage = state.errorMessage;

            if (successMessage != null && successMessage.isNotEmpty) {
              ToastService.showPrimary(successMessage);
              if (state.user != null) {
                context.read<GlobalCubit>().updateUser(user: state.user!);
              }
            } else if (errorMessage != null && errorMessage.isNotEmpty) {
              ToastService.showError(errorMessage);
            }

            context.read<ProfileCubit>().resetMessages();
          },
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: BreathingOpacityLoader());
            }

            if (_isGuest(state.user)) {
              return const ProfileGuestPrompt();
            }

            _populateFields(state);

            final profileUrl = state.user?.profileImageUrl ?? '';

            return SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 100.h),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      20.verticalSpace,

                      // ── Profile Photo with Camera Badge ──
                      ProfileAvatarHeader(
                        selectedImage: state.selectedImage,
                        profileImageUrl: profileUrl,
                        onTap: () => _showImagePicker(context),
                      ),
                      16.verticalSpace,

                      // ── Real Dating Profile Stats ──
                      StreamBuilder<List<UserModel>>(
                        stream: getIt<MatchRepository>().streamMatches(),
                        builder: (context, matchSnap) {
                          final matchCount = matchSnap.data?.length ?? 0;
                          return StreamBuilder<List<UserModel>>(
                            stream: getIt<BlockRepository>()
                                .streamBlockedUsers(),
                            builder: (context, blockSnap) {
                              final blockedCount = blockSnap.data?.length ?? 0;
                              return Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 12.h,
                                ),
                                decoration: BoxDecoration(
                                  color: context.surfaceCard,
                                  borderRadius: BorderRadius.circular(18.r),
                                  border: Border.all(color: context.stroke),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    ProfileStatItem(
                                      label: 'Matches',
                                      value: '$matchCount',
                                      color: AppColors.primary,
                                    ),
                                    Container(
                                      height: 30.h,
                                      width: 1,
                                      color: context.stroke,
                                    ),
                                    const ProfileStatItem(
                                      label: 'Status',
                                      value: 'Active',
                                      color: Color(0xFF00E676),
                                    ),
                                    Container(
                                      height: 30.h,
                                      width: 1,
                                      color: context.stroke,
                                    ),
                                    ProfileStatItem(
                                      label: 'Blocked',
                                      value: '$blockedCount',
                                      color: Colors.redAccent,
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                      20.verticalSpace,

                      // ── Name Field ──
                      AppText(
                        'Full Name',
                        color: context.textSecondary,
                        fontSize: 13,
                      ),
                      6.verticalSpace,
                      AppTextFormField(
                        controller: _nameController,
                        hintText: 'Enter your name',
                        validator: (val) {
                          if (val?.isEmpty ?? true) {
                            return 'Name cannot be empty';
                          }
                          return null;
                        },
                      ),
                      16.verticalSpace,

                      // ── Email Field ──
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
                            return 'Email cannot be empty';
                          }
                          if (!val!.contains('@')) return 'Enter valid email';
                          return null;
                        },
                      ),
                      16.verticalSpace,

                      // ── Gender Field ──
                      RegisterGenderField(
                        value: state.selectedGender,
                        // onChanged: (v) {
                        //   if (v != null) {
                        //     context.read<ProfileCubit>().updateGender(v);
                        //   }
                        // },
                      ),
                      20.verticalSpace,

                      // ── Blocked Users Section ──
                      InkWell(
                        onTap: () => context.push(AppRoutes.blockedUsers),
                        borderRadius: BorderRadius.circular(16.r),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 14.h,
                          ),
                          decoration: BoxDecoration(
                            color: context.surfaceCard,
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(color: context.stroke),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(8.r),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.redAccent.withValues(
                                    alpha: 0.12,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.block_rounded,
                                  color: Colors.redAccent,
                                  size: 20,
                                ),
                              ),
                              14.horizontalSpace,
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppText(
                                      'Blocked Users',
                                      color: context.textPrimary,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    2.verticalSpace,
                                    AppText(
                                      'Manage and unblock accounts',
                                      color: context.textSecondary,
                                      fontSize: 12,
                                    ),
                                  ],
                                ),
                              ),
                              StreamBuilder<List<UserModel>>(
                                stream: getIt<BlockRepository>()
                                    .streamBlockedUsers(),
                                builder: (context, snapshot) {
                                  final count = snapshot.data?.length ?? 0;
                                  return Row(
                                    children: [
                                      if (count > 0)
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8.w,
                                            vertical: 2.h,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.redAccent.withValues(
                                              alpha: 0.15,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              10.r,
                                            ),
                                          ),
                                          child: Text(
                                            '$count',
                                            style: const TextStyle(
                                              color: Colors.redAccent,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      8.horizontalSpace,
                                      Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        color: context.textSecondary,
                                        size: 14,
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      24.verticalSpace,

                      // ── Save Button ──
                      AppButton(
                        label: 'Save Changes',
                        isLoading: state.isSaving,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            closeKeyboard();
                            context.read<ProfileCubit>().updateProfile(
                              name: _nameController.text.trim(),
                              email: _emailController.text.trim(),
                              phone: _phoneController.text.trim(),
                            );
                          }
                        },
                      ),
                      16.verticalSpace,

                      // ── Logout Button ──
                      AppButton(
                        label: 'Sign Out',
                        backgroundColor: Colors.transparent,
                        borderColor: Colors.redAccent.withValues(alpha: 0.5),
                        textColor: Colors.redAccent,
                        onPressed: () => _showLogoutDialog(context),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
