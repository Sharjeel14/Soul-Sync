import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GlassPlayButton extends StatelessWidget {
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final double iconSize;

  const GlassPlayButton({
    super.key,
    this.onTap,
    this.width,
    this.height,
    this.iconSize = 40,
  });

  @override
  Widget build(BuildContext context) {
    final double w = width ?? 80.w;
    final double h = height ?? 80.h;

    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: ClipOval(
          child: Container(
            width: w,
            height: h,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.35),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 1),
                width: 1.5,
              ),
            ),
            child: Center(
              child: Icon(
                Icons.play_arrow_outlined,
                color: Colors.white,
                size: iconSize,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
