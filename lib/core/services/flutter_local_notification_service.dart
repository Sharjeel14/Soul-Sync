import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:date_app/core/di/injection_container.dart';
import 'package:date_app/core/router/app_router.dart';
import 'package:date_app/core/router/routes.dart';
import 'package:date_app/features/auth/services/auth_storage_service.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// Notification tap handlers (must be top-level)
/// ─────────────────────────────────────────────────────────────────────────────
@pragma('vm:entry-point')
Future<void> notificationTap(NotificationResponse response) async {
  final authStorage = getIt<AuthStorageService>();

  if (!(await authStorage.isLoggedIn())) {
    return;
  }
  debugPrint('👆 Notification tapped: ${response.payload}');

  final navState = navigatorKey.currentState;
  if (navState == null) {
    debugPrint('Navigator not ready for local notification tap.');
    return;
  }
  final context = navState.context;

  final isNotificationPageOpen =
      getIt<NotificationService>().isNotificationPageOpen;
  debugPrint('Is Notification Page Open: $isNotificationPageOpen');

  if (context.mounted && !isNotificationPageOpen) {
    context.push(AppRoutes.notificationPage);
  }
}

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse response) {
  debugPrint('👆 Background notification tapped: ${response.payload}');
}

class NotificationService {
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static final NotificationService _instance = NotificationService.internal();

  NotificationService.internal();

  static String? getToken() => _instance.token ?? '';

  // Tracks whether the notification page is currently open
  bool isNotificationPageOpen = false;

  void setNotificationPageOpen(bool isOpen) {
    isNotificationPageOpen = isOpen;
    debugPrint('📍 Notification page open: $isNotificationPageOpen');
  }

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'Used for important notifications',
    importance: Importance.high,
    playSound: true,
    enableVibration: true,
  );

  bool _isInitialized = false;

  String? token = 'device_local_token';

  /// ───────────────────────────────────────────────────────────────────────────
  /// Initialize
  /// ───────────────────────────────────────────────────────────────────────────
  Future<void> initialize() async {
    if (_isInitialized) return;

    await _setupLocalNotifications();

    _isInitialized = true;
  }

  /// ───────────────────────────────────────────────────────────────────────────
  /// Local notifications
  /// ───────────────────────────────────────────────────────────────────────────
  Future<void> _setupLocalNotifications() async {
    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_channel);

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: notificationTap,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
  }

  /// App opened from terminated state
  Future<void> checkInitialMessage() async {
    final details =
        await _localNotifications.getNotificationAppLaunchDetails();
    if (details != null && details.didNotificationLaunchApp) {
      debugPrint('🚀 App opened from notification: ${details.notificationResponse?.payload}');
    }
  }

  /// ───────────────────────────────────────────────────────────────────────────
  /// Show notification
  /// ───────────────────────────────────────────────────────────────────────────
  Future<void> showLocalNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    String? imageUrl,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      _channel.id,
      _channel.name,
      channelDescription: _channel.description,
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      icon: '@mipmap/ic_launcher',
      styleInformation: BigTextStyleInformation(body),
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: details,
      payload: payload,
    );
  }

  /// ───────────────────────────────────────────────────────────────────────────
  /// Cancel notifications
  /// ───────────────────────────────────────────────────────────────────────────
  Future<void> cancelNotification(int id) async {
    await _localNotifications.cancel(id: id);
  }

  Future<void> cancelAllNotifications() async {
    await _localNotifications.cancelAll();
  }

  /// ───────────────────────────────────────────────────────────────────────────
  /// Topics
  /// ───────────────────────────────────────────────────────────────────────────
  Future<void> subscribeToTopic(String topic) async {
    debugPrint('✅ Subscribed to topic $topic');
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    debugPrint('❌ Unsubscribed from topic $topic');
  }

  Future<void> sendTestNotification() async {
    await showLocalNotification(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title: 'Test Notification',
      body: 'This is a test notification triggered at ${DateTime.now()}',
      payload: 'test_payload',
    );
    debugPrint('🧪 Test notification sent');
  }
}
