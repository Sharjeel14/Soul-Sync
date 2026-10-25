import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Keys used for storing data locally, e.g., in SharedPreferences
class StorageKeys {
  /// Stores the user authentication token
  static const String userToken = "userToken";

  /// Stores the currently selected app language
  static const String appLanguage = "kappLanguage";

  /// Stores the current theme mode ('dark' or 'light')
  static const String themeMode = "app_theme_mode";

  /// Stores whether the user has completed onboarding
  static const String onboardingCompleted = "onboarding_completed";
}

/// Supported languages in the app
class AppLanguages {
  /// English language code
  static const String english = 'en';

  /// Arabic language code
  static const String arabic = 'ar';

  /// List of all supported language codes
  static const List<String> locales = [english, arabic];
}

/// Network-related configuration settings
class NetworkConfig {
  /// Base URL of the API, loaded from .env file with a fallback
  static String baseUrl = dotenv.get(
    'LIVE_BASE_URL',
    // 'OTE_BASE_URL',
    // 'DEV_BASE_URL',
    fallback: "https://dev-api.mydating.sa/",
  );

  /// Timeout durations for network requests
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  /// Maximum number of retries for failed requests
  static const int maxRetries = 2;

  /// Interval between retry attempts
  static const Duration retryInterval = Duration(seconds: 2);

  /// Cache settings
  static const String cacheName = "api_cache"; // Name of cache storage
  static const Duration cacheMaxAge = Duration(days: 7); // Cache expiry

  /// Default headers for requests
  static const String contentType = 'application/json';
  static const String accept = 'application/json';
  static const String acceptAll = '*/*';
}

/// API endpoints for authentication-related operations
class ApiEndpoints {
  static const apiV1 = "api/v1";

  static const String loginStep1 = '$apiV1/auth/login';
  static const String loginStep2 = '$apiV1/auth/login/customer/verify';
  static const String loginResendOtp = '$apiV1/auth/login/customer/resendotp';
  static const String logout = '$apiV1/auth/logout';
  static const String getRefreshToken = '$apiV1/auth/refresh';
  static const String deleteAccountStep1 =
      '$apiV1/mobile/customer/profile/delete/s1';
  static const String deleteAccountStep2 =
      '$apiV1/mobile/customer/profile/delete/s2';

  static const String registerStep1 =
      '$apiV1/mobile/customer/profile/create/s1';
  static const String registerStep2 =
      '$apiV1/mobile/customer/profile/create/s2';
  static const String registerResendOtp =
      '$apiV1/mobile/customer/profile/create/s3';
  static const String getMe = '$apiV1/mobile/customer/profile';
  static const String editProfile = '$apiV1/mobile/customer/profile/update';
  static const String updateMobileStep1 =
      '$apiV1/mobile/customer/profile/mobile/update/s1';
  static const String updateMobileStep2 =
      '$apiV1/mobile/customer/profile/mobile/update/s2';
  static const String uploadProfilePic =
      '$apiV1/mobile/customer/profile/upload/pic';

  static String uploadImage(String ticketId) =>
      '$apiV1/system/support/$ticketId/file/upload';

  static const String submitSupportForm = '$apiV1/system/support';

  static const String menuStep1 = '$apiV1/mobile/food/menu/s1';
  static const String menuStep2 = '$apiV1/mobile/food/menu/s2';
  static const String categoryList = '$apiV1/mobile/food/category';

  static String categoryItems(String categoryId) =>
      '$apiV1/mobile/food/category/$categoryId/item';

  static const String address = '$apiV1/mobile/customer/address/';
  static String addressAction(String id) =>
      '$apiV1/mobile/customer/address/$id';

  static String toggleFavorite = '$apiV1/mobile/food/item/myfavorite';

  static String customizableItesm(String itemId) =>
      '$apiV1/mobile/food/item/$itemId/detail';

  static const String branches = '$apiV1/mobile/customer/address/branch';
  static const String getPaymentLike = '$apiV1/mobile/order/create';
  static const String getOrders = '$apiV1/mobile/order';
  static String orderDetail(String orderId) =>
      '$apiV1/mobile/order/detail/$orderId';
  static const String pointHistory = '$apiV1/mobile/customer/points';
  static const String notificationSettings =
      '$apiV1/mobile/customer/notification/setting';
  static const String notification = '$apiV1/mobile/customer/notification';
  static const String dashboard = '$apiV1/mobile/customer/dashboard';

  static final paymentSuccessUrl =
      "${NetworkConfig.baseUrl}api/v1/payment/network/return";
  static final paymentFailUrl =
      "${NetworkConfig.baseUrl}api/v1/payment/network/cancel";

  static String placeOrder(int orderId) =>
      "$apiV1/mobile/order/status/$orderId";

  static const String validateCart = "$apiV1/mobile/order/validate";
}

/// Secrets or keys loaded from environment variables
class AppSecrets {
  /// API key loaded from .env file (empty string fallback)
  static final String apiKey = dotenv.get('keyName', fallback: '');
}

class AppCountryCodes {
  static const lhr = '910';
  static const ksa = 'ksa';

  static const saCountryCode = '966';
}
