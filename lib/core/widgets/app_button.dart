import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:date_app/core/theme/app_colors.dart';
import 'package:date_app/core/widgets/app_loader.dart';
import 'package:date_app/core/widgets/app_text.dart';

enum IconPosition { start, end }

class AppButton extends StatelessWidget {
  final String label;
  final String? label2;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final bool isFullWidth;
  final double height;
  final double? width;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final TextStyle? textStyle;
  final Widget? icon;
  final IconPosition iconPosition;
  final Color? borderColor;
  final double borderWidth;
  final bool isLoading;
  final AppFontFamily fontFamily;
  final double? fontSize;
  final List<BoxShadow>? boxShadow;
  final FontWeight fontWeight;
  final bool showArrow;
  final EdgeInsetsGeometry? contentPadding;
  final double horizontalSpace;

  const AppButton({
    super.key,
    required this.label,
    this.label2,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.isFullWidth = true,
    this.width,
    this.height = 46.0,
    this.borderRadius = 30.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 0.0),
    this.textStyle,
    this.icon,
    this.iconPosition = IconPosition.end,
    this.borderColor,
    this.borderWidth = 1.0,
    this.isLoading = false,
    this.fontFamily = AppFontFamily.inter,
    this.fontSize,
    this.boxShadow, // ✅ NEW
    this.fontWeight = FontWeight.w700,
    this.showArrow = false,
    this.contentPadding,
    this.horizontalSpace = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isFullWidth ? double.infinity : width?.w,
      height: height.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: boxShadow,
      ),
      child: Material(
        color: backgroundColor ?? AppColors.primary,
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(borderRadius),
          overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
            if (states.contains(WidgetState.pressed)) {
              return (textColor ?? AppColors.textPrimaryDark).withValues(
                alpha: 0.15,
              );
            }
            return null;
          }),

          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              border: borderColor != null
                  ? Border.all(color: borderColor!, width: borderWidth)
                  : null,
            ),
            child: isLoading
                ? Center(
                    child: AppLoader(
                      size: 24,
                      color: textColor ?? AppColors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : Padding(
                    padding:
                        contentPadding ??
                        const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: label2 != null
                          ? MainAxisAlignment.spaceBetween
                          : MainAxisAlignment.center,
                      children: [
                        if (icon != null &&
                            iconPosition == IconPosition.start) ...[
                          icon!,
                          if (label.isNotEmpty) horizontalSpace.horizontalSpace,
                        ],
                        if (label.isNotEmpty)
                          Row(
                            children: [
                              AppText(
                                label,
                                color: textColor ?? AppColors.white,
                                fontSize: fontSize ?? 14.0,
                                fontWeight: fontWeight,
                              ),
                              if (showArrow) ...[
                                horizontalSpace.horizontalSpace,
                                Icon(
                                  Icons.arrow_forward,
                                  color: textColor ?? AppColors.white,
                                  size: 14.sp,
                                ),
                              ],
                            ],
                          ),
                        if (label2 != null)
                          AppText(
                            label2!,
                            color: textColor ?? AppColors.white,
                            fontSize: fontSize ?? 14.0,
                            fontWeight: fontWeight,
                          ),
                        if (icon != null &&
                            iconPosition == IconPosition.end) ...[
                          if (label.isNotEmpty) 8.horizontalSpace,
                          icon!,
                        ],
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
