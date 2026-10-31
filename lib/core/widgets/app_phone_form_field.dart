import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:date_app/core/extensions/app_extensions.dart';
import 'package:date_app/core/theme/app_colors.dart';
import 'package:date_app/core/widgets/app_text.dart';

// ─── State ───────────────────────────────────────────────────────────────────

class _PhoneFieldState {
  final bool hasFocus;

  const _PhoneFieldState({this.hasFocus = false});

  _PhoneFieldState copyWith({bool? hasFocus}) =>
      _PhoneFieldState(hasFocus: hasFocus ?? this.hasFocus);
}

// ─── Cubit ───────────────────────────────────────────────────────────────────

class _PhoneFieldCubit extends Cubit<_PhoneFieldState> {
  _PhoneFieldCubit() : super(const _PhoneFieldState());

  void setFocus(bool value) => emit(state.copyWith(hasFocus: value));
}

// ─── Public FormField ─────────────────────────────────────────────────────────

class AppPhoneFormField extends FormField<String> {
  AppPhoneFormField({
    super.key,
    required String phoneCode,
    String? hintText,
    TextEditingController? controller,
    Widget? suffix,
    ValueChanged<String>? onChanged,
    VoidCallback? onTap,
    bool enabled = true,
    super.validator,
  }) : super(
         initialValue: controller?.text ?? '',
         builder: (FormFieldState<String> fieldState) {
           return _AppPhoneFormFieldInner(
             phoneCode: phoneCode,
             hintText: hintText,
             onChanged: (val) {
               fieldState.didChange(val);
               onChanged?.call(val);
             },
             onTap: onTap,
             enabled: enabled,
             controller: controller,
             errorText: fieldState.errorText,
             suffix: suffix,
           );
         },
       );
}

// ─── Inner Widget ─────────────────────────────────────────────────────────────

class _AppPhoneFormFieldInner extends StatefulWidget {
  final String phoneCode;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final bool enabled;
  final TextEditingController? controller;
  final String? errorText;
  final Widget? suffix;

  const _AppPhoneFormFieldInner({
    required this.phoneCode,
    this.hintText,
    this.onChanged,
    this.onTap,
    this.enabled = true,
    this.controller,
    this.errorText,
    this.suffix,
  });

  @override
  State<_AppPhoneFormFieldInner> createState() =>
      _AppPhoneFormFieldInnerState();
}

class _AppPhoneFormFieldInnerState extends State<_AppPhoneFormFieldInner> {
  late final FocusNode _focusNode;
  late final _PhoneFieldCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = _PhoneFieldCubit();
    _focusNode = FocusNode()
      ..addListener(() => _cubit.setFocus(_focusNode.hasFocus));
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocBuilder<_PhoneFieldCubit, _PhoneFieldState>(
        builder: (context, state) {
          final borderColor = widget.errorText != null
              ? Colors.red
              : state.hasFocus
              ? AppColors.primary
              : context.stroke;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(width: 2, color: borderColor),
                ),
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: widget.enabled ? widget.onTap : null,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            10.horizontalSpace,
                            AppText(
                              widget.phoneCode,
                              color: context.textPrimary,
                              fontSize: 13,
                            ),
                            10.horizontalSpace,
                          ],
                        ),
                      ),

                      Container(
                        width: 1,
                        height: 50,
                        color: context.stroke,
                      ),

                      Expanded(
                        child: TextField(
                          controller: widget.controller,
                          focusNode: _focusNode,
                          enabled: widget.enabled,
                          keyboardType: TextInputType.phone,
                          textAlign: TextAlign.left,
                          onChanged: widget.onChanged,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(9),
                          ],
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            color: context.textPrimary,
                          ),
                          decoration: InputDecoration(
                            hintText: widget.hintText,
                            fillColor: AppColors.transparent,
                            hintStyle: GoogleFonts.inter(
                              fontSize: 13.sp,
                              color: context.textSecondary,
                            ),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                            ),
                          ),
                        ),
                      ),

                      if (widget.suffix != null) ...[
                        8.horizontalSpace,
                        widget.suffix!,
                        10.horizontalSpace,
                      ],
                    ],
                  ),
                ),
              ),
              if (widget.errorText != null) ...[
                6.verticalSpace,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: AppText(
                    widget.errorText!,
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
