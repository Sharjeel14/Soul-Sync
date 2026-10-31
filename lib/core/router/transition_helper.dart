import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

/// ---------------- Transition Helpers ----------------

/// Standard route using [CupertinoPage] to preserve the native iOS
/// swipe-back gesture while still feeling platform-appropriate on Android.
GoRoute goRoute<T>(String path, Widget Function(BuildContext, T?) builder) {
  return GoRoute(
    path: path,
    pageBuilder: (context, state) {
      final data = state.extra as T?;
      return CupertinoPage(key: state.pageKey, child: builder(context, data));
    },
  );
}

/// Bottom-to-top transition (commonly used for modals / pages like Upload).
/// Does NOT use [CupertinoPage], so swipe-back is not active — this is
/// intentional for modal-style presentation.
CustomTransitionPage buildBottomToTopPage(
  BuildContext context,
  GoRouterState state,
  Widget child,
) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 350),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final slideAnimation = Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));
      return SlideTransition(position: slideAnimation, child: child);
    },
  );
}

/// Builds a bottom-to-top slide [PageRoute] compatible with [Navigator.push].
///
/// Use for upload / modal-style screens navigated imperatively.
Route<T> buildBottomUpRoute<T>({required Widget child}) {
  return PageRouteBuilder<T>(
    transitionDuration: const Duration(milliseconds: 350),
    reverseTransitionDuration: const Duration(milliseconds: 350),
    pageBuilder: (_, _, _) => child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final slideAnimation = Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));
      return SlideTransition(position: slideAnimation, child: child);
    },
  );
}
