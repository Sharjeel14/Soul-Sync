import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:date_app/core/extensions/app_extensions.dart';
import 'package:date_app/core/services/camera_photos_service.dart';
import 'package:date_app/core/theme/app_colors.dart';
import 'package:date_app/core/widgets/app_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';

class AppImagePicker {
  static Future<List<XFile>?> pickImages(
    BuildContext context,
    ImageSource source, {
    bool allowMultiple = true,
  }) async {
    if (!context.mounted) return null;

    bool hasPermission;

    if (source == ImageSource.camera) {
      hasPermission = await CameraPhotosService.requestCameraPermission(
        context,
      );
    } else {
      hasPermission = true;
      // hasPermission = await CameraPhotosService.requestPhotosPermission(
      //   context,
      // );
    }

    if (!hasPermission && context.mounted) {
      final granted = await showDialog<bool>(
        context: context,
        barrierColor: Colors.black.withValues(alpha: 0.7),
        builder: (_) => const _MediaPermissionDialog(),
      );

      if (granted != true) return null;
    }

    final picker = ImagePicker();

    // Gallery
    if (source == ImageSource.gallery) {
      // Multiple images -> compress only
      if (allowMultiple) {
        final images = await picker.pickMultiImage();

        if (images.isEmpty) return null;

        return await ImageCompressor.compressList(images);
      }

      // Single image -> crop then compress
      final image = await picker.pickImage(source: ImageSource.gallery);

      if (image == null) return null;

      if (!context.mounted) return null;

      final cropped = await cropImage(image, context);
      if (cropped == null) return null;

      final compressed = await ImageCompressor.compress(cropped);

      return [compressed ?? cropped];
    }

    // Camera -> always single image -> crop then compress
    final image = await picker.pickImage(source: ImageSource.camera);

    if (image == null) return null;

    if (!context.mounted) return null;

    final cropped = await cropImage(image, context);
    if (cropped == null) return null;

    final compressed = await ImageCompressor.compress(cropped);

    return [compressed ?? cropped];
  }

  static Future<XFile?> cropImage(XFile image, BuildContext context) async {
    final cropped = await ImageCropper().cropImage(
      sourcePath: image.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 88, // single encode at crop time — no re-compression
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: context.tr.cropImage,
          toolbarColor: AppColors.backgroundDark,
          toolbarWidgetColor: Colors.white,
          activeControlsWidgetColor: AppColors.primary,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: true,
          aspectRatioPresets: [CropAspectRatioPreset.square],
          cropStyle: CropStyle.circle,
        ),
        IOSUiSettings(
          title: context.tr.cropImage,
          aspectRatioPresets: [CropAspectRatioPreset.square],
          aspectRatioLockEnabled: true,
          resetAspectRatioEnabled: false,
          cropStyle: CropStyle.circle,
        ),
      ],
    );

    if (cropped == null) return null;

    return XFile(cropped.path);
  }
}

class _MediaPermissionDialog extends StatelessWidget {
  const _MediaPermissionDialog();

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
              child: Center(
                child: Container(
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
              ),
            ),
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
                  SizedBox(
                    width: double.infinity,
                    height: 52.h,
                    child: ElevatedButton(
                      onPressed: () async {
                        // Request permissions
                        Map<Permission, PermissionStatus> statuses = await [
                          Permission.camera,
                          if (Platform.isIOS) Permission.photos,
                          if (Platform.isAndroid) ...[
                            Permission.photos,
                            Permission.storage,
                          ],
                        ].request();

                        bool cameraOk =
                            statuses[Permission.camera]?.isGranted ??
                            statuses[Permission.camera]?.isLimited ??
                            false;

                        bool photosOk = false;
                        if (Platform.isIOS) {
                          photosOk =
                              statuses[Permission.photos]?.isGranted ??
                              statuses[Permission.photos]?.isLimited ??
                              false;
                        } else {
                          photosOk =
                              statuses[Permission.photos]?.isGranted ??
                              statuses[Permission.storage]?.isGranted ??
                              false;
                        }

                        if (cameraOk && photosOk) {
                          if (context.mounted) context.safePop(true);
                        } else {
                          // Check if any is permanently denied
                          bool isPermanentlyDenied =
                              statuses[Permission.camera]
                                  ?.isPermanentlyDenied ??
                              statuses[Permission.photos]
                                  ?.isPermanentlyDenied ??
                              statuses[Permission.storage]
                                  ?.isPermanentlyDenied ??
                              false;

                          if (isPermanentlyDenied) {
                            // Only suggest settings if the system dialog refused to show
                            await openAppSettings();
                          } else {
                            // If they just clicked 'Deny' on the system dialog, we stay here or close
                            if (context.mounted) context.safePop(false);
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                      ),
                      child: AppText(
                        context.tr.allowAccess,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.background,
                      ),
                    ),
                  ),
                  12.verticalSpace,
                  TextButton(
                    onPressed: () => context.safePop(false),
                    child: AppText(
                      context.tr.notNow,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppColors.grey,
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

class ImagePickerBottomSheet extends StatelessWidget {
  const ImagePickerBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 20.w),
      decoration: BoxDecoration(
        color: AppColors.backgroundDark,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppText(
            context.tr.selectSource,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.white,
          ),
          30.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _PickerOption(
                icon: Icons.camera_alt_rounded,
                label: context.tr.camera,
                onTap: () => context.safePop(ImageSource.camera),
              ),
              _PickerOption(
                icon: Icons.photo_library_rounded,
                label: context.tr.gallery,
                onTap: () => context.safePop(ImageSource.gallery),
              ),
            ],
          ),
          20.verticalSpace,
        ],
      ),
    );
  }
}

class _PickerOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _PickerOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 80.w,
            height: 80.w,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(icon, color: AppColors.black, size: 35.r),
          ),
          12.verticalSpace,
          AppText(
            label,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.white,
          ),
        ],
      ),
    );
  }
}

class ImageCompressor {
  static Future<XFile?> compress(XFile file) async {
    final tempDir = await getTemporaryDirectory();

    final targetPath =
        '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

    final compressed = await FlutterImageCompress.compressAndGetFile(
      file.path,
      targetPath,
      quality: 80,
      minWidth: 1440,
      minHeight: 1440,
      format: CompressFormat.jpeg,
    );

    if (compressed == null) return null;

    return XFile(compressed.path);
  }

  static Future<List<XFile>> compressList(List<XFile> files) async {
    final List<XFile> result = [];

    for (final file in files) {
      final compressed = await compress(file);
      result.add(compressed ?? file);
    }

    return result;
  }
}
