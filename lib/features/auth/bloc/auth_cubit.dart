import 'dart:developer';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:date_app/core/constants/app_constants.dart';
import 'package:date_app/core/enums/gender.dart';
import 'package:date_app/core/enums/signup_page_type.dart';
import 'package:date_app/core/storage/storage_manager.dart';
import 'package:date_app/features/auth/bloc/auth_state.dart';
import 'package:date_app/features/auth/repository/auth_repository.dart';
import 'package:date_app/features/auth/services/auth_storage_service.dart';

@injectable
class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repository;
  final AuthStorageService _storageService;

  AuthCubit(this._repository, this._storageService) : super(const AuthState());

  void updateGender(GenderType gender) {
    emit(state.copyWith(gender: gender));
  }

  void togglePasswordVisibility() {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

  void toggleConfirmPasswordVisibility() {
    emit(
      state.copyWith(isConfirmPasswordVisible: !state.isConfirmPasswordVisible),
    );
  }

  void pickImage(File? profileImage) {
    emit(state.copyWith(profileImage: profileImage));
  }

  void toggleTermsPolicy() {
    emit(state.copyWith(isTermsPolicyAccepted: !state.isTermsPolicyAccepted));
  }

  void clearMessage() {
    emit(state.copyWith(isClearMessage: true, loginStatus: AuthStatus.initial));
  }

  // ─── Email & Password Login ───────────────────────────────────────────────
  Future<void> loginWithEmail({
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(isLoading: true, message: null));

    final result = await _repository.loginWithEmail(
      email: email,
      password: password,
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            isLoading: false,
            loginStatus: AuthStatus.failure,
            message: failure.message,
          ),
        );
      },
      (user) {
        emit(
          state.copyWith(
            isLoading: false,
            loginStatus: user.isEmailVerified
                ? AuthStatus.success
                : AuthStatus.needsEmailVerification,
            user: user,
            message: user.isEmailVerified ? null : 'Please verify your email',
          ),
        );
      },
    );
  }

  // ─── Legacy / Unified Login identifier ───────────────────────────────────
  Future<void> login({required String identifier, String? password}) async {
    if (identifier.contains('@')) {
      await loginWithEmail(email: identifier, password: password ?? '');
    } else {
      await sendPhoneOtp(identifier);
    }
  }

  // ─── Email Registration ──────────────────────────────────────────────────
  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    File? profileImage,
  }) async {
    emit(state.copyWith(isLoading: true, message: null));

    final result = await _repository.registerWithEmail(
      name: name,
      email: email,
      password: password,
      phone: phone,
      gender: state.gender,
      profileImage: profileImage ?? state.profileImage,
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            isLoading: false,
            loginStatus: AuthStatus.failure,
            message: failure.message,
          ),
        );
      },
      (user) {
        emit(
          state.copyWith(
            isLoading: false,
            loginStatus: AuthStatus.needsEmailVerification,
            user: user,
            message: 'Registration successful! Verification email sent.',
          ),
        );
      },
    );
  }

  // ─── Google Sign-In ───────────────────────────────────────────────────────
  Future<void> loginWithGoogle() async {
    emit(state.copyWith(isLoading: true, isGoogleLoading: true, message: null));

    final result = await _repository.loginWithGoogle();

    result.fold(
      (failure) {
        log('failure is ${failure.message}');
        emit(
          state.copyWith(
            isLoading: false,
            isGoogleLoading: false,
            loginStatus: AuthStatus.failure,
            message: failure.message,
          ),
        );
      },
      (user) {
        emit(
          state.copyWith(
            isLoading: false,
            isGoogleLoading: false,
            loginStatus: AuthStatus.success,
            user: user,
          ),
        );
      },
    );
  }

  // ─── Phone OTP Authentication ─────────────────────────────────────────────
  Future<void> sendPhoneOtp(String phoneNumber) async {
    emit(state.copyWith(isLoading: true, message: null));

    final result = await _repository.sendPhoneOtp(
      phoneNumber: phoneNumber,
      onCodeSent: (verificationId) {
        emit(
          state.copyWith(
            isLoading: false,
            loginStatus: AuthStatus.otpSent,
            phoneVerificationId: verificationId,
            message: 'Verification code sent to $phoneNumber',
          ),
        );
      },
      onError: (error) {
        emit(
          state.copyWith(
            isLoading: false,
            loginStatus: AuthStatus.failure,
            message: error,
          ),
        );
      },
    );

    result.fold((failure) {
      emit(
        state.copyWith(
          isLoading: false,
          loginStatus: AuthStatus.failure,
          message: failure.message,
        ),
      );
    }, (_) {});
  }

  Future<void> verifyPhoneOtp({
    required String verificationId,
    required String smsCode,
    String? name,
    GenderType? gender,
    File? profileImage,
  }) async {
    emit(state.copyWith(isLoading: true, message: null));

    final result = await _repository.verifyPhoneOtp(
      verificationId: verificationId,
      smsCode: smsCode,
      name: name,
      gender: gender ?? state.gender,
      profileImage: profileImage ?? state.profileImage,
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            isLoading: false,
            loginStatus: AuthStatus.failure,
            message: failure.message,
          ),
        );
      },
      (user) {
        emit(
          state.copyWith(
            isLoading: false,
            loginStatus: AuthStatus.success,
            user: user,
          ),
        );
      },
    );
  }

  // ─── Compatibility verifyOtp for existing OtpPage ────────────────────────
  Future<void> verifyOtp({
    required OtpPageRouteType type,
    required String code,
    required Map<String, dynamic> data,
  }) async {
    final verificationId =
        data['verificationId'] as String? ?? state.phoneVerificationId ?? '';
    await verifyPhoneOtp(
      verificationId: verificationId,
      smsCode: code,
      name: data['name'] as String?,
      gender: state.gender,
    );
  }

  // ─── Email Verification ───────────────────────────────────────────────────
  Future<void> sendEmailVerification() async {
    emit(state.copyWith(isLoading: true, message: null));
    final result = await _repository.sendEmailVerification();
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, message: failure.message)),
      (_) => emit(
        state.copyWith(isLoading: false, message: 'Verification email sent!'),
      ),
    );
  }

  Future<void> checkEmailVerified() async {
    emit(state.copyWith(isLoading: true, message: null));
    final result = await _repository.checkEmailVerified();
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, message: failure.message)),
      (isVerified) {
        emit(
          state.copyWith(
            isLoading: false,
            isEmailVerified: isVerified,
            loginStatus: isVerified
                ? AuthStatus.success
                : AuthStatus.needsEmailVerification,
            message: isVerified
                ? 'Email verified successfully!'
                : 'Email is not verified yet.',
          ),
        );
      },
    );
  }

  // ─── Logout & Session Cleanup ─────────────────────────────────────────────
  Future<void> clearUserSession() async {
    final storageManager = StorageManager();
    final locale = await storageManager.read(StorageKeys.appLanguage);
    final themeMode = await storageManager.read(StorageKeys.themeMode);

    await _storageService.logout();
    await storageManager.clearAll();

    if (locale != null) {
      await storageManager.write(StorageKeys.appLanguage, locale);
    }
    if (themeMode != null) {
      await storageManager.write(StorageKeys.themeMode, themeMode);
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    await clearUserSession();
    emit(const AuthState());
  }

  Future<void> deleteAccount() async {
    emit(state.copyWith(isLoading: true, message: null));
    final result = await _repository.deleteAccount();
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, message: failure.message)),
      (_) async {
        await clearUserSession();
        emit(const AuthState());
      },
    );
  }

  Future<void> resendOtp(OtpPageRouteType pageType) async {
    emit(
      state.copyWith(
        loginStatus: AuthStatus.otpResendSuccess,
        message: 'Code resent',
      ),
    );
  }
}
