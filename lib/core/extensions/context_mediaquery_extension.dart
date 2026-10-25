import 'package:flutter/widgets.dart';

extension ContextMediaQuery on BuildContext {
  /// Returns the full width of the screen
  double get screenWidth => MediaQuery.sizeOf(this).width;

  /// Returns the full height of the screen
  double get screenHeight => MediaQuery.sizeOf(this).height;

  /// Returns the device pixel ratio
  double get pixelRatio => MediaQuery.of(this).devicePixelRatio;

  /// Returns the current text scaling factor
  double get textScaleFactor => MediaQuery.textScalerOf(this).scale(1.0);

  /// Returns the padding around the screen
  EdgeInsets get padding => MediaQuery.paddingOf(this);

  /// Returns the view insets of the screen (e.g., keyboard height)
  EdgeInsets get viewInsets => MediaQuery.viewInsetsOf(this);

  /// Returns padding that remains constant regardless of system UI
  EdgeInsets get viewPadding => MediaQuery.viewPaddingOf(this);
}
