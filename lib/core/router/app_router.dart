library;

import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:date_app/features/auth/models/otp_page_data.dart';
import 'package:date_app/features/auth/presentation/pages/email_verification_page.dart';
import 'package:date_app/features/auth/presentation/pages/login_page.dart';
import 'package:date_app/features/auth/presentation/pages/otp_page.dart';
import 'package:date_app/features/auth/presentation/pages/register_screen.dart';
import 'package:date_app/features/bottom_nav_bar/presentation/bottom_nav_bar.dart';
import 'package:date_app/features/chat/presentation/chat_screen.dart';
import 'package:date_app/features/global/models/user_model.dart';
import 'package:date_app/features/onboarding/presentation/onboarding_screen.dart';
import 'package:date_app/features/profile/presentation/blocked_users_page.dart';
import 'package:date_app/features/profile/presentation/profile_page.dart';
import 'package:date_app/features/splash/presentation/splash_screen.dart';
import 'routes.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

GoRouter createRouter({String initialLocation = AppRoutes.splash}) => GoRouter(
  initialLocation: initialLocation,
  navigatorKey: navigatorKey,
  routes: [
    _goRoute<void>(AppRoutes.splash, (context, _) => const SplashScreen()),
    _goRoute<void>(
      AppRoutes.onboarding,
      (context, _) => const OnboardingScreen(),
    ),
    _goRoute<void>(AppRoutes.login, (context, _) => const LoginPage()),
    _goRoute<void>(AppRoutes.otp, (context, data) {
      var info = data as OtpPageData;
      return OtpPage(data: info.data, pageType: info.pageType);
    }),
    _goRoute<dynamic>(AppRoutes.register, (context, data) {
      return const RegisterScreen();
    }),
    _goRoute<void>(
      AppRoutes.emailVerification,
      (context, _) => const EmailVerificationPage(),
    ),
    _goRoute<void>(
      AppRoutes.bottomNavBar,
      (context, _) => const BottomNavBar(),
    ),
    _goRoute<void>(AppRoutes.profile, (context, _) => const ProfilePage()),
    _goRoute<void>(
      AppRoutes.blockedUsers,
      (context, _) => const BlockedUsersPage(),
    ),
    _goRoute<UserModel>(AppRoutes.chat, (context, data) {
      return ChatScreen(
        targetUser: data ?? UserModel.empty(),
      );
    }),
  ],
);

GoRoute _goRoute<T>(String path, Widget Function(BuildContext, T?) builder) {
  return GoRoute(
    path: path,
    pageBuilder: (context, state) {
      final data = state.extra as T?;
      return CupertinoPage(key: state.pageKey, child: builder(context, data));
    },
  );
}
