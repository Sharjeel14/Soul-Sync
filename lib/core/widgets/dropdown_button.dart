import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:date_app/core/extensions/app_extensions.dart';
import 'package:date_app/core/models/dropdown_model.dart';
import 'package:date_app/core/theme/app_colors.dart';
import 'package:date_app/core/widgets/app_text.dart';
import 'package:date_app/core/widgets/arrow_field_container.dart';

class DropdownButtonWidget extends StatelessWidget {
  const DropdownButtonWidget({
    super.key,
    required this.items,
    required this.value,
    required this.onChanged,
  });

  final List<DropdownModel> items;
  final String value;
  final Function(DropdownModel?) onChanged;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: Center(
        child: DropdownButtonHideUnderline(
          child: DropdownButton2<DropdownModel>(
            isExpanded: true,
            hint: GlassArrowField(text: value),

            items: items
                .map(
                  (DropdownModel item) => DropdownItem<DropdownModel>(
                    value: item,
                    height: 40,
                    child: AppText(
                      item.translation,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
                .toList(),
            onChanged: onChanged,

            iconStyleData: const IconStyleData(
              icon: Icon(Icons.arrow_forward_ios_outlined),
              iconSize: 0,
            ),
            dropdownStyleData: DropdownStyleData(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              maxHeight: 200,
              width: context.screenWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: AppColors.black,
              ),
              offset: const Offset(-20, 0),
              scrollbarTheme: ScrollbarThemeData(
                // radius: const Radius.circular(40),
                thickness: WidgetStateProperty.all<double>(2),
                thumbVisibility: WidgetStateProperty.all<bool>(true),
                thumbColor: WidgetStateProperty.all(Colors.white),
              ),
            ),
            menuItemStyleData: MenuItemStyleData(
              padding: const EdgeInsets.only(left: 14, right: 14),
            ),
          ),
        ),
      ),
    );
  }
}
