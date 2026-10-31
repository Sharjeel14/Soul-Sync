import 'package:flutter/material.dart';
import 'package:date_app/core/theme/app_colors.dart';

class AppLoaderImage extends StatelessWidget {
  const AppLoaderImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primary.withValues(alpha: 0.15),
      ),
      child: const Center(
        child: Icon(
          Icons.favorite_rounded,
          color: AppColors.primary,
          size: 24,
        ),
      ),
    );
  }
}
