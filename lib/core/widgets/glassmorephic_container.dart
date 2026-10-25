import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:date_app/core/widgets/app_text.dart';

class GlassmorphicContainer extends StatelessWidget {
  const GlassmorphicContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.blur = 12.0,
    this.borderRadius = 12.0,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 1.0,
    this.padding,
    this.margin,
  });

  /// The widget inside the glass container.
  final Widget child;

  /// Width of the container. Defaults to full width if null.
  final double? width;

  /// Height of the container.
  final double? height;

  /// Blur intensity for the frosted glass effect. Default: 12.
  final double blur;

  /// Corner radius. Default: 12.
  final double borderRadius;

  /// Fill color (semi-transparent white by default).
  final Color? backgroundColor;

  /// Border color (semi-transparent white by default).
  final Color? borderColor;

  /// Border width. Default: 1.
  final double borderWidth;

  /// Inner padding. Defaults to horizontal 14, vertical 10.
  final EdgeInsetsGeometry? padding;

  /// Outer margin.
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            width: width,
            height: height,
            padding:
                padding ??
                const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: backgroundColor ?? Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: borderColor ?? Colors.white.withValues(alpha: 0.13),
                width: borderWidth,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// A thin vertical divider styled for use inside GlassmorphicContainer.
class GlassDivider extends StatelessWidget {
  const GlassDivider({super.key, this.height = 14.0, this.color});

  /// Height of the divider line. Default: 14.
  final double height;

  /// Color of the divider. Defaults to semi-transparent white.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: height,
      color: color ?? Colors.white.withValues(alpha: 0.3),
    );
  }
}

// ---------------------------------------------------------------------------
// EXAMPLE USAGE — remove or keep in your demo/test file
// ---------------------------------------------------------------------------

class GlassStatBar extends StatelessWidget {
  const GlassStatBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 12,
      left: 12,
      right: 12,
      child: GlassmorphicContainer(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildStatItem(Icons.location_on_outlined, "London'UK"),
            const GlassDivider(),
            _buildStatItem(Icons.remove_red_eye_outlined, "1.5k"),
            const GlassDivider(),
            _buildStatItem(Icons.favorite_border, "520"),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white, size: 16),
        4.horizontalSpace,
        AppText(
          label,
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ],
    );
  }
}
