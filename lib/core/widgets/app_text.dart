import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:date_app/core/extensions/app_extensions.dart';
import '../theme/app_colors.dart';

/// Typography variants used across the app
enum AppTypography { h0, h1, h2, h3, h4, h5, body1, body2, caption, button }

/// Supported font families
enum AppFontFamily { inter, notoSansArabic }

class AppText extends StatelessWidget {
  final String text;
  final AppTypography style;

  /// Optional overrides
  final AppFontFamily? fontFamily; // <-- nullable, can override
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double? lineHeight;
  final double? letterSpacing;
  final List<Shadow>? shadows;
  final TextDecoration? decoration;
  final Color? decorationColor;

  const AppText(
    this.text, {
    super.key,
    this.style = AppTypography.body2,
    this.fontFamily,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.fontSize,
    this.fontWeight,
    this.lineHeight,
    this.letterSpacing,
    this.shadows,
    this.decoration,
    this.decorationColor,
  });

  @override
  Widget build(BuildContext context) {
    // ✅ Auto choose font based on text direction unless overridden
    final effectiveFontFamily =
        fontFamily ??
        (context.isRTL ? AppFontFamily.notoSansArabic : AppFontFamily.inter);

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveColor =
        color ?? (isDark ? AppColors.white : AppColors.textPrimaryLight);

    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: getStyle(
        style,
        effectiveFontFamily,
        color: effectiveColor,
        fontSize: fontSize,
        fontWeight: fontWeight,
        height: lineHeight,
        letterSpacing: letterSpacing,
        shadows: shadows,
        decoration: decoration,
        decorationColor: decorationColor,
      ),
    );
  }
}

/// Generates TextStyle based on typography + font family
TextStyle getStyle(
  AppTypography style,
  AppFontFamily fFamily, {
  Color? color,
  double? fontSize,
  FontWeight? fontWeight,
  double? height,
  double? letterSpacing,
  TextDecoration? decoration,
  Color? decorationColor,
  List<Shadow>? shadows, // <-- added here too
  TextStyle? baseStyle,
}) {
  /// 1. Select Google Font dynamically
  final googleFont = switch (fFamily) {
    AppFontFamily.inter => GoogleFonts.inter,
    AppFontFamily.notoSansArabic => GoogleFonts.notoSansArabic,
  };

  /// 2. Define base typography styles
  final Map<AppTypography, TextStyle> styles = {
    AppTypography.h0: TextStyle(
      fontSize: 32.sp,
      fontWeight: FontWeight.bold,
      height: 1.2,
    ),
    AppTypography.h1: TextStyle(
      fontSize: 26.sp,
      fontWeight: FontWeight.bold,
      height: 1.3,
      letterSpacing: 0.2,
    ),
    AppTypography.h2: TextStyle(
      fontSize: 24.sp,
      fontWeight: FontWeight.bold,
      height: 1.3,
    ),
    AppTypography.h3: TextStyle(
      fontSize: 20.sp,
      fontWeight: FontWeight.w600,
      height: 1.4,
    ),
    AppTypography.h4: TextStyle(
      fontSize: 18.sp,
      fontWeight: FontWeight.w600,
      height: 1.4,
    ),
    AppTypography.h5: TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.w600,
      height: 1.5,
    ),
    AppTypography.body1: TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.normal,
      height: 1.5,
    ),
    AppTypography.body2: TextStyle(
      fontSize: 12.sp,
      fontWeight: FontWeight.normal,
      height: 1.5,
    ),
    AppTypography.caption: TextStyle(
      fontSize: 11.sp,
      fontWeight: FontWeight.w400,
      height: 1.4,
      letterSpacing: 0.3,
    ),
    AppTypography.button: TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.w600,
      height: 1.2,
      letterSpacing: 0.5,
    ),
  };

  /// 3. Get selected base style
  final base = styles[style]!;

  /// 4. Apply font + overrides
  final styled = googleFont(
    textStyle: base.copyWith(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: height,
      letterSpacing: letterSpacing,
      decoration: decoration,
      decorationColor: decorationColor,
      shadows: shadows, // <-- applied
    ),
  );

  /// 5. Merge with any external style if provided
  return baseStyle != null ? styled.merge(baseStyle) : styled;
}
