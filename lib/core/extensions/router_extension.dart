import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:date_app/core/router/routes.dart';

extension NavigationExtensions on BuildContext {
  /// Safely pops the current route.
  ///
  /// If there is a previous route in the navigation stack,
  /// it will pop normally and optionally return a value.
  ///
  /// If this is the last route (cannot pop), it will navigate
  /// to the root route ('/') instead to prevent the app from closing
  /// or throwing a navigation error.
  void safePop([dynamic value]) {
    final popStatus = canPop();
    final valueText = value != null ? ', value: $value' : '';
    debugPrint('canPop: $popStatus$valueText');
    // Check if there is a previous screen in the navigation stack
    if (popStatus) {
      // Pop the current screen and optionally return a value
      pop(value);
    } else {
      // If no screen to pop (this is the root screen),
      // navigate to the home/root route instead
      go(AppRoutes.splash);
    }
  }
}
