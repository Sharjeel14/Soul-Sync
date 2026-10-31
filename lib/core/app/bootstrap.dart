import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:date_app/core/config/supabase_config.dart';
import 'package:date_app/core/di/injection_container.dart';
import 'package:date_app/core/services/flutter_local_notification_service.dart';
import 'package:date_app/core/services/in_app_notification_service.dart';
import 'package:date_app/core/services/presence_service.dart';
import 'package:date_app/core/storage/storage_manager.dart';
import 'package:date_app/core/utils/general_utils.dart';
import 'package:date_app/features/bottom_nav_bar/bloc/bottom_nav_cubit.dart';
import 'package:date_app/features/global/bloc/global_cubit.dart';

import 'app.dart';

/// Global navigator key used to access navigation
/// from anywhere in the application without context.

/// Bootstraps and initializes the application before running it.
///
/// Responsibilities:
/// - Ensures Flutter bindings are initialized
/// - Sets system UI styles (status bar & navigation bar)
/// - Loads environment variables from `.env`
/// - Initializes Supabase & Google Sign-In
/// - Initializes dependency injection
/// - Locks app orientation to portrait
/// - Starts the Flutter application
Future<void> bootstrap() async {
  /// Ensures that plugin services are initialized
  /// before the app starts.
  WidgetsFlutterBinding.ensureInitialized();

  /// Load environment variables from the `.env` file first.
  try {
    await dotenv.load(fileName: ".env");
  } catch (_) {}

  // Initialize Supabase
  try {
    await Supabase.initialize(
      url: SupabaseConfig.url,
      publishableKey: SupabaseConfig.anonKey,
    );
  } catch (e) {
    debugPrint('Supabase initialization error: $e');
  }

  // Initialize Google Sign-In for Android Credential Manager & Web
  try {
    final androidClientId = dotenv.env['GOOGLE_ANDROID_CLIENT_ID'];
    final webClientId = dotenv.env['GOOGLE_WEB_CLIENT_ID'];
    await GoogleSignIn.instance.initialize(
      clientId: Platform.isAndroid ? androidClientId : null,
      serverClientId: webClientId,
    );
  } catch (e) {
    debugPrint('Google Sign-In initialization error: $e');
  }

  configureDependencies();

  await getIt<NotificationService>().initialize();
  PresenceService().initialize();
  InAppNotificationService().initialize();

  /// Ensure storage is fresh (handling potential Keychain persistence on iOS)
  await StorageManager.ensureStorageFreshness();

  /// Apply system navigation and status bar styles.
  setNavigationStyles();

  /// Initialize dependency injection container.

  /// Restrict the app to portrait orientations only.
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  /// Launch the application and provide GlobalCubit
  /// to the widget tree using BlocProvider.
  runApp(
    GestureDetector(
      onTap: closeKeyboard,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => getIt<GlobalCubit>()),

          BlocProvider(create: (_) => getIt<BottomNavCubit>()),
        ],
        child: MyDatingApp(),
      ),
    ),
  );
}

/// Configures system UI styles such as:
/// - Navigation bar color
/// - Navigation bar icon brightness
/// - Status bar color
/// - Status bar icon brightness
void setNavigationStyles() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
}
