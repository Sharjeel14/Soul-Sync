import 'package:flutter/cupertino.dart';

class GradientBorderPainter extends CustomPainter {
  const GradientBorderPainter({
    required this.gradient,
    required this.borderRadius,
    required this.strokeWidth,
  });

  final Gradient gradient;
  final double borderRadius;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(
      rect,
      Radius.circular(borderRadius),
    );

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..shader = gradient.createShader(rect);

    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(GradientBorderPainter oldDelegate) =>
      oldDelegate.gradient != gradient ||
          oldDelegate.borderRadius != borderRadius ||
          oldDelegate.strokeWidth != strokeWidth;
}

/// A container with a gradient border.
/// Use this anywhere you'd normally use Border.all() but need a gradient stroke.
class GradientBorderContainer extends StatelessWidget {
  const GradientBorderContainer({
    super.key,
    required this.child,
    required this.gradient,
    this.borderRadius = 16.0,
    this.strokeWidth = 1.5,
    this.backgroundColor,
    this.padding,
    this.width,
    this.height,
    this.boxShadow,
  });

  final Widget child;
  final Gradient gradient;
  final double borderRadius;
  final double strokeWidth;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final List<BoxShadow>? boxShadow;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: GradientBorderPainter(
        gradient: gradient,
        borderRadius: borderRadius,
        strokeWidth: strokeWidth,
      ),
      child: Container(
        width: width,
        height: height,
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: boxShadow,
        ),
        child: child,
      ),
    );
  }
}