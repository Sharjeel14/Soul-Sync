import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// A scalable app icon drawn from an inline SVG.
///
/// Usage:
///   const AppIcon(size: 96)
///   AppIcon(size: 64, startColor: Colors.teal, endColor: Colors.indigo)
class AppIcon extends StatelessWidget {
  const AppIcon(this.path, {super.key, this.size = 96, this.color});

  final double size;
  final Color? color;
  final String path;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: SvgPicture.asset(
        path,
        width: size,
        height: size,
        colorFilter: color != null
            ? ColorFilter.mode(color!, BlendMode.srcIn)
            : null,
      ),
    );
  }
}
