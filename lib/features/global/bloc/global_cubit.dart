import 'dart:developer';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:date_app/core/constants/app_constants.dart';
import 'package:date_app/core/services/presence_service.dart';
import 'package:date_app/core/di/injection_container.dart';
import 'package:date_app/core/router/app_router.dart';
import 'package:date_app/core/storage/storage_manager.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:date_app/features/auth/bloc/auth_cubit.dart';
import 'package:date_app/features/auth/services/auth_storage_service.dart';
import 'package:date_app/features/bottom_nav_bar/bloc/bottom_nav_cubit.dart';
import 'package:date_app/features/global/models/user_model.dart';

import 'package:date_app/core/router/routes.dart';

import '../repository/global_repository.dart';
part 'global_state.dart';

/// Cubit responsible for managing global app-level state.
///
/// This includes:
/// - User login state and profile data.
/// - App language (locale) settings.
/// - Navigation routing via `GoRouter`.
@lazySingleton
class GlobalCubit extends Cubit<GlobalState> {
  /// Repository responsible for fetching user-related data.
  final GlobalRepository _repository;

  /// Local storage manager for persisting settings like language.
  final StorageManager _storageManager;

  final AuthStorageService _authStorageService;

  /// App router for navigation.
  late final GoRouter router;

  /// Initializes the cubit with repository and storage manager.
  ///
  /// Also sets up the router and initial locale.
  GlobalCubit(this._repository, this._storageManager, this._authStorageService)
    : super(const GlobalState()) {
    router = createRouter(); // Initialize GoRouter for navigation
    setInitialLocale(); // Load saved locale or default
    setInitialTheme(); // Load saved theme
    getUser();
  }

  Future<void> setInitialTheme() async {
    final mode = await _storageManager.read(StorageKeys.themeMode);
    if (mode == 'light') {
      emit(state.copyWith(themeMode: ThemeMode.light));
    } else {
      emit(state.copyWith(themeMode: ThemeMode.dark));
    }
  }

  Future<void> toggleTheme() async {
    final newMode =
        state.themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await _storageManager.write(
      StorageKeys.themeMode,
      newMode == ThemeMode.dark ? 'dark' : 'light',
    );
    emit(state.copyWith(themeMode: newMode));
  }

  /// Loads the initial locale from local storage.
  ///
  /// If no locale is stored, defaults to Arabic.
  Future<void> setInitialLocale() async {
    var locale = await _storageManager.read(StorageKeys.appLanguage);
    _storageManager.write(
      StorageKeys.appLanguage,
      locale ?? AppLanguages.english,
    );

    emit(state.copyWith(locale: Locale(locale ?? AppLanguages.english)));
  }

  /// Updates the app's locale and persists it in local storage.
  ///
  /// Emits a new state with the updated `Locale`.
  Future<void> updateLocale(String locale) async {
    _storageManager.write(StorageKeys.appLanguage, locale);
    emit(state.copyWith(locale: Locale(locale)));
  }

  /// Fetches the current user profile from the repository.
  ///
  /// Updates state to show loading, success, or failure messages.
  Future<void> getUser() async {
    if (await _storageManager.read(StorageKeys.userToken) == null) {
      return;
    }

    final cachedUser = await _authStorageService.getUser();

    if (cachedUser != null) {
      emit(state.copyWith(user: cachedUser, isLoading: true, message: null));
    } else {
      emit(state.copyWith(isLoading: true, message: null));
    }

    final result = await _repository.getUser();

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            isLoading: false,
            isSuccess: false,
            message: failure.message,
          ),
        );
      },
      (currentUser) async {
        await _authStorageService.saveUser(currentUser);

        emit(
          state.copyWith(
            isLoading: false,
            isSuccess: true,
            user: currentUser,
            message: null,
          ),
        );
      },
    );
  }

  Future<void> updateUser({required UserModel user}) async {
    if (await _storageManager.read(StorageKeys.userToken) == null) {
      return;
    }

    await _authStorageService.saveUser(user);

    emit(state.copyWith(user: user));

    log('updated user is ${user.toJson()}');
  }

  static Future<void> logout(BuildContext context) async {
    await PresenceService().setOffline();
    await PresenceService().stopPresence();
    await getIt<AuthCubit>().clearUserSession();
    // 4. Navigate
    if (context.mounted) {
      context.read<BottomNavCubit>().logout();
      context.read<GlobalCubit>().resetState();
      context.go(AppRoutes.login);
    }
  }

  void resetState({bool keepLocale = true, bool keepTheme = true}) {
    emit(
      GlobalState(
        locale: keepLocale ? state.locale : const Locale(AppLanguages.arabic),
        themeMode: keepTheme ? state.themeMode : ThemeMode.dark,
      ),
    );
  }
}
