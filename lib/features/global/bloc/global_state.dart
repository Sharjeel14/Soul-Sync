part of 'global_cubit.dart';

/// Represents the global state of the app.
///
/// Includes loading state, success flags, error messages,
/// user data, app locale, and theme mode.
class GlobalState extends Equatable {
  /// Indicates if an operation (like fetching user) is in progress.
  final bool isLoading;

  /// Indicates if the last operation was successful.
  final bool isSuccess;

  /// Optional message for errors or notifications.
  final String? message;

  /// Stores the current user profile.
  final UserModel? user;

  /// Current app locale (language).
  final Locale locale;

  /// Current app theme mode (dark or light).
  final ThemeMode themeMode;

  /// Default constructor with optional values.
  const GlobalState({
    this.isLoading = false,
    this.isSuccess = false,
    this.message,
    this.user,
    this.locale = const Locale(AppLanguages.english),
    this.themeMode = ThemeMode.dark,
  });

  /// Returns a copy of the state with updated fields.
  GlobalState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? message,
    UserModel? user,
    Locale? locale,
    ThemeMode? themeMode,
  }) {
    return GlobalState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      message: message ?? this.message,
      user: user ?? this.user,
      locale: locale ?? this.locale,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isSuccess,
    message,
    user,
    locale,
    themeMode,
  ];
}
