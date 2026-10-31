import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:date_app/core/theme/app_colors.dart';

class ToastService {
  // Private method to show toast
  static void _showToast({
    required String message,
    required Color backgroundColor,
    Color textColor = Colors.white,
    ToastGravity gravity = ToastGravity.BOTTOM,
    Toast length = Toast.LENGTH_SHORT,
  }) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: length,
      gravity: gravity,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: 16.0,
    );
  }

  // Success toast
  static void showSuccess(String message) {
    _showToast(
      message: message,
      backgroundColor: AppColors.primary,
      textColor: AppColors.black,
      length: Toast.LENGTH_SHORT,
    );
  }

  // Error toast
  static void showError(String message) {
    _showToast(
      message: message,
      backgroundColor: AppColors.redColor,
      textColor: AppColors.white,
      length: Toast.LENGTH_LONG,
    );
  }

  // Primary toast
  static void showPrimary(String message, {Toast? length}) {
    _showToast(
      message: message,
      backgroundColor: AppColors.primary,
      textColor: AppColors.black,
      length: length ?? Toast.LENGTH_SHORT,
    );
  }

  // Primary toast
  static void showWaring(String message) {
    _showToast(message: message, backgroundColor: Colors.orange);
  }

  // Custom toast
  static void showCustom({
    required String message,
    required Color backgroundColor,
    Color textColor = Colors.white,
    ToastGravity gravity = ToastGravity.BOTTOM,
    Toast length = Toast.LENGTH_SHORT,
  }) {
    _showToast(
      message: message,
      backgroundColor: backgroundColor,
      textColor: textColor,
      gravity: gravity,
      length: length,
    );
  }
}
