import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:date_app/core/extensions/app_extensions.dart';
import 'package:date_app/core/theme/app_colors.dart';
import 'package:date_app/core/widgets/app_cache_network_image.dart';
import 'package:date_app/core/widgets/app_text.dart';

class ProfileAvatarHeader extends StatelessWidget {
  final File? selectedImage;
  final String profileImageUrl;
  final VoidCallback onTap;

  const ProfileAvatarHeader({
    super.key,
    this.selectedImage,
    required this.profileImageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Stack(
            children: [
              GestureDetector(
                onTap: onTap,
                child: Container(
                  width: 110.r,
                  height: 110.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.white.withValues(alpha: 0.08),
                    border: Border.all(color: AppColors.primary, width: 2.5),
                  ),
                  child: ClipOval(
                    child: selectedImage != null
                        ? Image.file(selectedImage!, fit: BoxFit.cover)
                        : (profileImageUrl.isNotEmpty
                              ? AppCacheNetworkImage(
                                  profileImageUrl,
                                  fit: BoxFit.cover,
                                  loaderBuilder: (context, url) => const Center(
                                    child: CircularProgressIndicator(
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(
                                        Icons.person,
                                        size: 55,
                                        color: AppColors.textSecondaryDark,
                                      ),
                                )
                              : const Icon(
                                  Icons.person,
                                  size: 55,
                                  color: AppColors.textSecondaryDark,
                                )),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: onTap,
                  child: Container(
                    width: 34.r,
                    height: 34.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary,
                      border: Border.all(
                        color: context.appBackground,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.4),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      size: 18,
                      color: Colors.white,
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
            'Tap avatar to change photo',
            color: context.textSecondary,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
