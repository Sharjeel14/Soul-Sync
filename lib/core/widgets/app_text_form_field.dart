import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:date_app/core/extensions/app_extensions.dart';
import 'package:date_app/core/theme/app_colors.dart';
import 'app_text.dart';

class AppTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String? initialValue;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;
  final double? fontSize;
  final AppFontFamily fontFamily;
  final FontWeight? fontWeight;
  final double? thickness;
  final Function(String)? onChanged;
  final Color? fillColor;
  final int? maxLines;
  final int? minLines;
  final Color? borderColor;
  final bool enabled;
  final bool readOnly;
  final bool? isEmail;

  final double borderRadius;

  final int? minLength;
  final int? maxLength;

  final List<TextInputFormatter>? inputFormatters;

  final VoidCallback? onTap;

  const AppTextFormField({
    super.key,
    this.controller,
    this.initialValue,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.onFieldSubmitted,
    this.fontSize,
    this.fontFamily = AppFontFamily.inter,
    this.fontWeight,
    this.thickness,
    this.onChanged,
    this.fillColor,
    this.maxLines = 1,
    this.minLines = 1,
    this.borderColor,
    this.enabled = true,
    this.readOnly = false,
    this.isEmail = false,
    this.borderRadius = 12,
    this.minLength,
    this.maxLength,
    this.inputFormatters,
    this.onTap,
  });

  TextStyle _getFont(AppFontFamily fFamily) {
    switch (fFamily) {
      case AppFontFamily.inter:
        return GoogleFonts.inter();

      case AppFontFamily.notoSansArabic:
        return GoogleFonts.notoSansArabic();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: isEmail == true
          ? TextDirection.ltr
          : context.isRTL
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: TextFormField(
        enabled: enabled,
        readOnly: readOnly,
        onChanged: onChanged,
        controller: controller,
        obscureText: obscureText,
        maxLines: obscureText ? 1 : maxLines,
        minLines: minLines,

        validator: (value) {
          if (minLength != null &&
              value != null &&
              value.trim().length < minLength!) {
            return "Minimum $minLength characters required";
          }

          if (validator != null) {
            return validator!(value);
          }

          return null;
        },

        /// ✅ max length
        maxLength: maxLength,

        /// ✅ prevents typing more than maxLength
        inputFormatters: maxLength != null
            ? [
                LengthLimitingTextInputFormatter(maxLength),
                if (inputFormatters != null) ...inputFormatters! else ...[],
              ]
            : inputFormatters,

        keyboardType: keyboardType,
        textInputAction: textInputAction,
        onFieldSubmitted: onFieldSubmitted,
        style: _getFont(fontFamily).copyWith(
          fontSize: fontSize?.sp ?? 14.sp,
          fontWeight: fontWeight,
          color: context.textPrimary,
        ),
        onTap: onTap,

        decoration: InputDecoration(
          counterStyle: _getFont(
            fontFamily,
          ).copyWith(fontSize: 12.sp, color: context.textSecondary),
          hintText: hintText,
          hintStyle: _getFont(
            fontFamily,
          ).copyWith(fontSize: 13.sp, color: context.textSecondary),

          prefixIcon: prefixIcon != null
              ? Padding(
                  padding: EdgeInsets.only(left: 8.w, right: 8.w),
                  child: prefixIcon,
                )
              : null,

          suffixIcon: suffixIcon != null
              ? Padding(
                  padding: EdgeInsets.only(right: 8.w, left: 8.w),
                  child: suffixIcon,
                )
              : null,

          fillColor: fillColor ?? Colors.transparent,

          prefixIconConstraints: BoxConstraints(
            maxWidth: 45.w,
            maxHeight: 45.h,
          ),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              width: 1.5,
              color: borderColor ?? context.stroke,
            ),
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              width: 1.5,
              color: borderColor ?? context.stroke,
            ),
          ),

          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(width: 1.5, color: AppColors.red),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(width: 1.5, color: AppColors.primary),
          ),

          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              width: 2,
              color: borderColor ?? context.stroke,
            ),
          ),
        ),
      ),
    );
  }
}
