import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CircleIconIndicator extends StatelessWidget {
  final double outerSize;
  final double innerSize;
  final Color color;

  final Object icon; // <-- can be String OR IconData

  final double iconSize;
  final Color? iconColor;
  final double outerOpacity;
  final double innerOpacity;

  const CircleIconIndicator({
    super.key,
    required this.outerSize,
    required this.innerSize,
    required this.color,
    required this.icon,
    this.iconSize = 50,
    this.iconColor,
    this.outerOpacity = 0.15,
    this.innerOpacity = 0.25,
  });

  @override
  Widget build(BuildContext context) {
    Widget buildIcon() {
      if (icon is String) {
        return SvgPicture.asset(
          icon as String,
          width: iconSize.w,
          height: iconSize.h,
          colorFilter: ColorFilter.mode(iconColor ?? color, BlendMode.srcIn),
        );
      } else if (icon is IconData) {
        return Icon(
          icon as IconData,
          size: iconSize.w,
          color: iconColor ?? color,
        );
      } else {
        return const SizedBox.shrink(); // fallback
      }
    }

    return Container(
      width: outerSize.w,
      height: outerSize.h,
      decoration: BoxDecoration(
        color: color.withValues(alpha: outerOpacity),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Container(
          width: innerSize.w,
          height: innerSize.h,
          decoration: BoxDecoration(
            color: color.withValues(alpha: innerOpacity),
            shape: BoxShape.circle,
          ),
          child: Center(child: buildIcon()),
        ),
      ),
    );
  }
}
