import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:date_app/core/enums/gender.dart';
import 'package:date_app/core/extensions/app_extensions.dart';
import 'package:date_app/core/theme/app_colors.dart';
import 'package:date_app/core/widgets/app_text.dart';

import 'auth_logo_widget.dart';

class RegisterGenderField extends StatelessWidget {
  final GenderType value;

  /// Pass null to disable the field.
  final ValueChanged<GenderType?>? onChanged;

  const RegisterGenderField({required this.value, this.onChanged, super.key});

  bool get _isEnabled => onChanged != null;

  String _getGenderText(BuildContext context, GenderType gender) {
    switch (gender) {
      case GenderType.male:
        return context.tr.male;
      case GenderType.female:
        return context.tr.female;
      case GenderType.unknown:
        return context.tr.pleaseSelectGender;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          context.tr.gender,
          color: context.textSecondary,
          fontWeight: FontWeight.w400,
          fontSize: 13,
        ),
        5.verticalSpace,
        DropdownButtonFormField2<GenderType>(
          hint: AppText(_getGenderText(context, value)),
          onChanged: onChanged, // null => field is disabled
          isExpanded: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: _isEnabled
                ? context.appBackground
                : context.appBackground.withValues(alpha: 0.6),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 14.w,
              vertical: 14.h,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(width: 2, color: context.stroke),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                width: 2,
                color: context.stroke.withValues(alpha: 0.5),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(width: 2, color: AppColors.primary),
            ),
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: 200,
            decoration: BoxDecoration(
              color: context.surfaceCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: context.stroke),
            ),
          ),
          iconStyleData: IconStyleData(
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: _isEnabled
                  ? context.textSecondary
                  : context.textSecondary.withValues(alpha: 0.4),
              size: 22,
            ),
          ),
          menuItemStyleData: const MenuItemStyleData(
            padding: EdgeInsets.symmetric(horizontal: 12),
          ),
          items: GenderType.values.map((gender) {
            return DropdownItem<GenderType>(
              value: gender,
              child: AppText(_getGenderText(context, gender), fontSize: 13),
            );
          }).toList(),
        ),
        6.verticalSpace,
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.info_outline_rounded,
              size: 14.r,
              color: context.textSecondary.withValues(alpha: 0.8),
            ),
            6.horizontalSpace,
            Expanded(
              child: AppText(
                context.tr.genderCannotBeChangedNote,
                color: context.textSecondary.withValues(alpha: 0.85),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class RegisterBrandHeader extends StatelessWidget {
  const RegisterBrandHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 10,
          right: context.isRTL ? 0 : null,
          left: context.isRTL ? null : 0,
          child: IconButton(
            padding: EdgeInsets.zero,
            splashRadius: 1,
            onPressed: () => context.safePop(),
            icon: Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: context.stroke),
                color: context.surfaceCard,
              ),
              child: Icon(
                Icons.chevron_left,
                color: context.textPrimary,
                size: 22,
              ),
            ),
          ),
        ),

        Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              20.verticalSpace,
              const MyDatingLogo(),
              10.verticalSpace,
              AppText(
                title,
                textAlign: TextAlign.center,
                color: context.textPrimary,
                fontWeight: FontWeight.w400,
                fontSize: 20,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
