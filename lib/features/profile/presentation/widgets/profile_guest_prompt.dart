import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:date_app/core/extensions/app_extensions.dart';
import 'package:date_app/core/router/routes.dart';
import 'package:date_app/core/theme/app_colors.dart';
import 'package:date_app/core/widgets/app_text.dart';

class ProfileGuestPrompt extends StatelessWidget {
  const ProfileGuestPrompt({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 100.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 88.r,
              height: 88.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryGradientEnd],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.35),
                    blurRadius: 24,
                    spreadRadius: 2,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Icon(
                Icons.person_outline_rounded,
                color: Colors.white,
                size: 44,
              ),
            ),
            20.verticalSpace,
            AppText(
              'Guest Account',
              color: context.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
            8.verticalSpace,
            AppText(
              'Sign in or register to customize your profile, upload dating photos, and keep all your spark matches safe!',
              color: context.textSecondary,
              fontSize: 13,
              textAlign: TextAlign.center,
              lineHeight: 1.4,
            ),
            24.verticalSpace,
            Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: context.surfaceCard,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: context.stroke),
              ),
              child: Column(
                children: [
                  const ProfilePerkRow(
                    icon: Icons.badge_outlined,
                    title: 'Personalized Profile',
                    subtitle: 'Add your custom bio, passions & photos',
                  ),
                  Divider(color: context.stroke, height: 22),
                  const ProfilePerkRow(
                    icon: Icons.chat_bubble_outline_rounded,
                    title: 'Live Chat & Messaging',
                    subtitle: 'Real-time messaging with your sparks',
                  ),
                  Divider(color: context.stroke, height: 22),
                  const ProfilePerkRow(
                    icon: Icons.favorite_border_rounded,
                    title: 'Sync Matches',
                    subtitle: 'Never lose your matches across devices',
                  ),
                ],
              ),
            ),
            28.verticalSpace,
            SizedBox(
              width: double.infinity,
              height: 50.h,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                  elevation: 6,
                ),
                onPressed: () => context.push(AppRoutes.login),
                child: const AppText(
                  'Log In to Existing Account',
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            12.verticalSpace,
            SizedBox(
              width: double.infinity,
              height: 50.h,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primary, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                ),
                onPressed: () => context.push(AppRoutes.register),
                child: const AppText(
                  'Create New Account',
                  color: AppColors.primary,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfilePerkRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const ProfilePerkRow({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary.withValues(alpha: 0.15),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        14.horizontalSpace,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                title,
                color: context.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              2.verticalSpace,
              AppText(subtitle, color: context.textSecondary, fontSize: 11),
            ],
          ),
        ),
      ],
    );
  }
}
