import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:date_app/core/extensions/app_extensions.dart';
import 'package:date_app/core/theme/app_colors.dart';
import 'package:date_app/core/widgets/app_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class MediaPermissionDialog extends StatelessWidget {
  /// Whether to pick video instead of image
  final bool isVideo;

  const MediaPermissionDialog({super.key, this.isVideo = false});

  static Future<XFile?> show(
    BuildContext context, {
    bool isVideo = false,
  }) async {
    final granted = await _requestPermission();

    if (granted) {
      return _pickMedia(isVideo: isVideo);
    }

    if (!context.mounted) return null;

    await showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.7),
      builder: (_) => MediaPermissionDialog(isVideo: isVideo),
    );

    return null;
  }

  /// Returns true if permission is already granted
  static Future<bool> _requestPermission() async {
    // Android 13+
    final photos = await Permission.photos.status;
    final videos = await Permission.videos.status;

    if (photos.isGranted && videos.isGranted) return true;

    // Request both
    final results = await [Permission.photos, Permission.videos].request();

    return results[Permission.photos]!.isGranted &&
        results[Permission.videos]!.isGranted;
  }

  static Future<XFile?> _pickMedia({required bool isVideo}) async {
    final picker = ImagePicker();
    if (isVideo) {
      return picker.pickVideo(source: ImageSource.gallery);
    }
    return picker.pickImage(source: ImageSource.gallery);
  }

  Future<void> _handleAllow(BuildContext context) async {
    context.safePop();

    final results = await [Permission.photos, Permission.videos].request();

    final photosGranted = results[Permission.photos]!.isGranted;
    final videosGranted = results[Permission.videos]!.isGranted;

    if (photosGranted && videosGranted) {
      await _pickMedia(isVideo: isVideo);
    } else if (results[Permission.photos]!.isPermanentlyDenied ||
        results[Permission.videos]!.isPermanentlyDenied) {
      await openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 28.w),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF141425),
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(color: AppColors.strokes),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Top icon banner ──────────────────────────────
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 28.h),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.r),
                  topRight: Radius.circular(24.r),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 72.w,
                    height: 72.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary.withValues(alpha: 0.15),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Icon(
                      Icons.perm_media_outlined,
                      color: AppColors.primary,
                      size: 32.r,
                    ),
                  ),
                  16.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _MiniIconBadge(icon: Icons.photo_outlined),
                      8.horizontalSpace,
                      _MiniIconBadge(icon: Icons.videocam_outlined),
                      8.horizontalSpace,
                      _MiniIconBadge(icon: Icons.image_outlined),
                    ],
                  ),
                ],
              ),
            ),

            // ── Text + Buttons ───────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
              child: Column(
                children: [
                  AppText(
                    context.tr.mediaPermissionTitle,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                    textAlign: TextAlign.center,
                  ),
                  12.verticalSpace,
                  AppText(
                    context.tr.mediaPermissionDesc,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: AppColors.grey,
                    textAlign: TextAlign.center,
                  ),
                  24.verticalSpace,

                  // Allow Access
                  SizedBox(
                    width: double.infinity,
                    height: 52.h,
                    child: ElevatedButton(
                      onPressed: () => _handleAllow(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                      ),
                      child: AppText(
                        context.tr.allowAccess,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.white,
                      ),
                    ),
                  ),

                  12.verticalSpace,

                  // Not Now
                  SizedBox(
                    width: double.infinity,
                    height: 52.h,
                    child: TextButton(
                      onPressed: () => context.safePop(),
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                      ),
                      child: AppText(
                        context.tr.notNow,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: AppColors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Mini icon badge ──────────────────────────────────────────────────────────

class _MiniIconBadge extends StatelessWidget {
  final IconData icon;

  const _MiniIconBadge({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36.w,
      height: 36.w,
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.strokes),
      ),
      child: Icon(icon, color: AppColors.grey, size: 18.r),
    );
  }
}
