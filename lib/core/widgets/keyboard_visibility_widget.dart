import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class KeyboardHiddenWidget extends StatelessWidget {
  final Widget child;

  const KeyboardHiddenWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
      builder: (context, visible) {
        return visible ? const SizedBox.shrink() : child;
      },
    );
  }
}
