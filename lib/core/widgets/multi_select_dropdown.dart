import 'package:flutter/foundation.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:date_app/core/extensions/app_extensions.dart';
import 'package:date_app/core/theme/app_colors.dart';
import 'package:date_app/core/widgets/app_text.dart';
import 'package:date_app/core/widgets/arrow_field_container.dart';

class MultiSelectDropdownWidget<T> extends StatefulWidget {
  const MultiSelectDropdownWidget({
    super.key,
    required this.items,
    required this.selectedItems,
    required this.onChanged,
    required this.hintText,
    required this.itemLabelBuilder,
  });

  final List<T> items;
  final List<T> selectedItems;
  final Function(List<T>) onChanged;
  final String hintText;
  final String Function(T) itemLabelBuilder;

  @override
  State<MultiSelectDropdownWidget<T>> createState() =>
      _MultiSelectDropdownWidgetState<T>();
}

class _MultiSelectDropdownWidgetState<T>
    extends State<MultiSelectDropdownWidget<T>> {
  late ValueNotifier<List<T>> _selectedItemsNotifier;

  @override
  void initState() {
    super.initState();
    _selectedItemsNotifier = ValueNotifier(List<T>.from(widget.selectedItems));
  }

  @override
  void didUpdateWidget(MultiSelectDropdownWidget<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listEquals(widget.selectedItems, oldWidget.selectedItems) &&
        !listEquals(widget.selectedItems, _selectedItemsNotifier.value)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _selectedItemsNotifier.value = List<T>.from(widget.selectedItems);
        }
      });
    }
  }

  @override
  void dispose() {
    _selectedItemsNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<T>(
              isExpanded: true,
              hint: GlassArrowField(text: widget.hintText),
              items: widget.items.map((T item) {
                return DropdownItem<T>(
                  value: item,
                  height: 40,
                  key: ValueKey(item),
                  child: ValueListenableBuilder<List<T>>(
                    valueListenable: _selectedItemsNotifier,
                    builder: (context, selectedList, _) {
                      final isSelected = selectedList.contains(item);
                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            final newSelectedItems = List<T>.from(selectedList);
                            if (isSelected) {
                              newSelectedItems.remove(item);
                            } else {
                              newSelectedItems.add(item);
                            }
                            _selectedItemsNotifier.value = newSelectedItems;
                            widget.onChanged(newSelectedItems);
                          },
                          child: Container(
                            height: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              children: [
                                isSelected
                                    ? const Icon(
                                        Icons.check_box_outlined,
                                        color: AppColors.primary,
                                      )
                                    : const Icon(
                                        Icons.check_box_outline_blank,
                                        color: Colors.white24,
                                      ),
                                16.horizontalSpace,
                                Expanded(
                                  child: AppText(
                                    widget.itemLabelBuilder(item),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }).toList(),
              onChanged: (_) {},
              buttonStyleData: ButtonStyleData(
                padding: EdgeInsets.zero,
                height: 50.h,
              ),
              iconStyleData: const IconStyleData(icon: SizedBox.shrink()),
              dropdownStyleData: DropdownStyleData(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                maxHeight: 300.h,
                width: context.screenWidth - 32.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: AppColors.black,
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.3),
                  ),
                ),
                offset: Offset(0, -4.h),
                scrollbarTheme: ScrollbarThemeData(
                  thickness: WidgetStateProperty.all<double>(2),
                  thumbVisibility: WidgetStateProperty.all<bool>(true),
                  thumbColor: WidgetStateProperty.all(AppColors.primary),
                ),
              ),
              menuItemStyleData: const MenuItemStyleData(
                padding: EdgeInsets.zero,
              ),
            ),
          ),
        ),
        ValueListenableBuilder<List<T>>(
          valueListenable: _selectedItemsNotifier,
          builder: (context, selectedList, _) {
            if (selectedList.isEmpty) return const SizedBox.shrink();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                12.verticalSpace,
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: selectedList.map((item) {
                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.black,
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(color: AppColors.primary),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppText(
                            widget.itemLabelBuilder(item),
                            fontSize: 12,
                            color: Colors.white,
                          ),
                          8.horizontalSpace,
                          GestureDetector(
                            onTap: () {
                              final newSelectedItems = List<T>.from(
                                selectedList,
                              );
                              newSelectedItems.remove(item);
                              _selectedItemsNotifier.value = newSelectedItems;
                              widget.onChanged(newSelectedItems);
                            },
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
