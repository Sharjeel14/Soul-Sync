import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:date_app/core/theme/app_colors.dart';
import 'package:date_app/core/widgets/app_cache_network_image.dart';
import 'package:date_app/core/widgets/app_text.dart';

class UserCircleAvatar extends StatelessWidget {
  final String name;
  final String imageUrl;
  final double size;
  final bool isCircle;
  final bool isOnline;
  final VoidCallback? onTap;

  const UserCircleAvatar({
    super.key,
    required this.name,
    this.imageUrl = '',
    this.size = 48,
    this.isCircle = true,
    this.isOnline = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final initial = name.trim().isNotEmpty ? name.trim()[0].toUpperCase() : '?';

    Widget avatarContent;
    if (imageUrl.isNotEmpty) {
      avatarContent = AppCacheNetworkImage(
        imageUrl,
        width: size.r,
        height: size.r,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildInitials(initial),
      );
    } else {
      avatarContent = _buildInitials(initial);
    }

    Widget result = ClipRRect(
      borderRadius: isCircle
          ? BorderRadius.circular((size / 2).r)
          : BorderRadius.circular(12.r),
      child: SizedBox(width: size.r, height: size.r, child: avatarContent),
    );

    if (isOnline) {
      result = Stack(
        clipBehavior: Clip.none,
        children: [
          result,
          Positioned(
            right: 1.r,
            bottom: 1.r,
            child: Container(
              width: 12.r,
              height: 12.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF10B981),
                border: Border.all(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  width: 2.r,
                ),
              ),
            ),
          ),
        ],
      );
    }

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: result);
    }

    return result;
  }

  Widget _buildInitials(String initial) {
    return Container(
      width: size.r,
      height: size.r,
      decoration: BoxDecoration(
        shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
        color: AppColors.primary.withValues(alpha: 0.15),
        borderRadius: isCircle ? null : BorderRadius.circular(12.r),
      ),
      alignment: Alignment.center,
      child: AppText(
        initial,
        color: AppColors.primary,
        fontWeight: FontWeight.w800,
        fontSize: (size * 0.4).r,
      ),
    );
  }
}
