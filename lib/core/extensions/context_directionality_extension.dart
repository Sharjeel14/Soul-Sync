import 'package:flutter/widgets.dart';

extension DirectionalityExtensions on BuildContext {
  /// Returns true if the current directionality is Right-to-Left (RTL)
  bool get isRTL => Directionality.of(this) == TextDirection.rtl;

  /// Returns true if the current directionality is Left-to-Right (LTR)
  bool get isLTR => Directionality.of(this) == TextDirection.ltr;
}
