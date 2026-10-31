import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:date_app/core/extensions/app_extensions.dart';

class AppSpacing {
  const AppSpacing._();

  static double get p4 => 4.w;
  static double get p8 => 8.w;
  static double get p12 => 12.w;
  static double get p16 => 16.w;
  static double get p20 => 20.w;
  static double get p24 => 24.w;
  static double get p32 => 32.w;
  static double get p48 => 48.w;

  static SizedBox get horizontalSpace4 => p4.sbw;
  static SizedBox get horizontalSpace8 => p8.sbw;
  static SizedBox get horizontalSpace12 => p12.sbw;
  static SizedBox get horizontalSpace16 => p16.sbw;
  static SizedBox get horizontalSpace20 => p20.sbw;

  static SizedBox get verticalSpace4 => p4.sbh;
  static SizedBox get verticalSpace8 => p8.sbh;
  static SizedBox get verticalSpace12 => p12.sbh;
  static SizedBox get verticalSpace16 => p16.sbh;
  static SizedBox get verticalSpace20 => p20.sbh;
  static SizedBox get verticalSpace24 => p24.sbh;
  static SizedBox get verticalSpace32 => p32.sbh;
  static SizedBox get verticalSpace48 => p48.sbh;
}
