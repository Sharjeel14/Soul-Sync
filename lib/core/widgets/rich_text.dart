import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:date_app/core/theme/app_colors.dart';
import 'package:date_app/core/widgets/app_text.dart';
import 'package:flutter/gestures.dart';

class TwoStyleText extends StatelessWidget {
  final String firstText;
  final String secondText;

  final TextStyle? firstStyle;
  final TextStyle? secondStyle;

  final VoidCallback? onFirstTap;
  final VoidCallback? onSecondTap;

  final TextAlign textAlign;
  final AppFontFamily fontStyle;

  const TwoStyleText({
    super.key,
    required this.firstText,
    required this.secondText,
    this.firstStyle,
    this.secondStyle,
    this.onFirstTap,
    this.onSecondTap,
    this.fontStyle = AppFontFamily.inter,
    this.textAlign = TextAlign.start,
  });

  @override
  Widget build(BuildContext context) {
    TextStyle Function({double? fontSize, FontWeight? fontWeight, Color? color})
    googleFont;

    switch (fontStyle) {
      case AppFontFamily.inter:
        googleFont = GoogleFonts.inter;
        break;
      case AppFontFamily.notoSansArabic:
        googleFont = GoogleFonts.notoSansArabic;
        break;
    }

    final baseStyle = googleFont(
      fontSize: 12.sp,
      fontWeight: FontWeight.bold,
      color: AppColors.white,
    );

    return RichText(
      textAlign: textAlign,
      text: TextSpan(
        style: baseStyle,
        children: [
          TextSpan(
            text: firstText,
            style: firstStyle,
            recognizer: onFirstTap != null
                ? (TapGestureRecognizer()..onTap = onFirstTap)
                : null,
          ),
          TextSpan(
            text: secondText,
            style: secondStyle,
            recognizer: onSecondTap != null
                ? (TapGestureRecognizer()..onTap = onSecondTap)
                : null,
          ),
        ],
      ),
    );
  }
}
