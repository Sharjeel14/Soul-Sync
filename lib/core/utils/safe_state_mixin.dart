import 'package:flutter/material.dart';

mixin SafeStateMixin<T extends StatefulWidget> on State<T> {
  bool get isSafelyMounted => mounted;

  void safeSetState(VoidCallback fn) {
    if (mounted) {
      // ignore: invalid_use_of_protected_member
      setState(fn);
    }
  }
}
