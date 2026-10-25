import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:date_app/core/di/injection_container.dart';
import 'package:date_app/core/extensions/app_extensions.dart';
import 'package:date_app/core/theme/app_colors.dart';
import 'package:date_app/core/widgets/app_button.dart';
import 'package:date_app/core/widgets/app_text.dart';
import 'package:date_app/features/auth/bloc/auth_cubit.dart';
import 'package:date_app/features/auth/bloc/auth_state.dart';

class DeleteAccountDialog extends StatelessWidget {
  const DeleteAccountDialog({super.key});

  static Future<bool?> show(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => const DeleteAccountDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AuthCubit>(),
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state.loginStatus == AuthStatus.success) {
            context.read<AuthCubit>().clearMessage();
          }
        },
        child: Dialog(
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
                  child: Icon(
                    CupertinoIcons.delete,
                    color: Colors.white,
                    size: 30,
                  ),
                ),

                20.verticalSpace,

                AppText(
                  context.tr.deleteAccount,
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),

                12.verticalSpace,

                AppText(
                  context.tr.areYouSureYouWantToDeleteYourAccount,
                  textAlign: TextAlign.center,
                  color: Colors.white70,
                  fontSize: 15,
                  lineHeight: 1.5,
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

                    BlocSelector<AuthCubit, AuthState, bool>(
                      selector: (state) {
                        return state.isLoading;
                      },
                      builder: (context, isLoading) {
                        return Expanded(
                          child: AppButton(
                            onPressed: () async {
                              context.read<AuthCubit>().deleteAccount();
                            },
                            backgroundColor: AppColors.primary,
                            borderColor: AppColors.primary,
                            borderRadius: 14,
                            label: context.tr.confirm,
                            isLoading: isLoading,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
