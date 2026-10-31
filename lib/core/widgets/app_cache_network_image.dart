import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:date_app/core/widgets/place_holder.dart';

import '../theme/app_colors.dart';

import 'package:shimmer/shimmer.dart';

class AppCacheNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final double? borderRadius;
  final BoxFit fit;

  /// Optional custom loader widget
  final Widget Function(BuildContext context, String url)? loaderBuilder;

  /// Optional custom error widget
  final Widget Function(BuildContext context, String url, Object error)?
  errorBuilder;

  const AppCacheNetworkImage(
    this.imageUrl, {
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.fit = BoxFit.cover,
    this.loaderBuilder,
    this.errorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius?.r ?? 12.r;

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,

        /// Custom loader or shimmer loader
        placeholder:
            loaderBuilder ??
            (context, url) => Shimmer.fromColors(
              baseColor: AppColors.primary.withValues(alpha: 0.1),
              highlightColor: AppColors.primary.withValues(alpha: 1),
              child: Container(
                width: width,
                height: height,
                color: AppColors.primary.withValues(alpha: 0.1),
              ),
            ),

        /// Custom error widget or default
        errorWidget:
            errorBuilder ??
            (context, url, error) => Container(
              width: width,
              height: height,
              alignment: Alignment.center,
              child: const ImagePlaceHolder(),
            ),
      ),
    );
  }
}
