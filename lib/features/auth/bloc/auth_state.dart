import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:date_app/core/enums/gender.dart';
import 'package:date_app/features/global/models/user_model.dart';

enum AuthStatus {
  initial,
  loading,
  success,
  failure,
  otpSent,
  otpResendLoading,
  otpResendSuccess,
  needsEmailVerification,
}

class AuthState extends Equatable {
  final bool isPasswordVisible;
  final bool isConfirmPasswordVisible;
  final bool isTermsPolicyAccepted;
  final bool isLoading;
  final bool isGoogleLoading;
  final AuthStatus loginStatus;
  final String? message;
  final GenderType gender;
  final File? profileImage;
  final String profileImageUrl;
  final String? phoneVerificationId;
  final UserModel? user;
  final bool isEmailVerified;

  const AuthState({
    this.isPasswordVisible = false,
    this.isConfirmPasswordVisible = false,
    this.isTermsPolicyAccepted = false,
    this.isLoading = false,
    this.isGoogleLoading = false,
    this.loginStatus = AuthStatus.initial,
    this.message,
    this.gender = GenderType.unknown,
    this.profileImage,
    this.profileImageUrl = '',
    this.phoneVerificationId,
    this.user,
    this.isEmailVerified = false,
  });

  AuthState copyWith({
    bool? isPasswordVisible,
    bool? isConfirmPasswordVisible,
    bool? isTermsPolicyAccepted,
    bool? isLoading,
    bool? isGoogleLoading,
    AuthStatus? loginStatus,
    String? message,
    GenderType? gender,
    bool isClearMessage = false,
    File? profileImage,
    String? profileImageUrl,
    String? phoneVerificationId,
    UserModel? user,
    bool? isEmailVerified,
  }) {
    return AuthState(
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isConfirmPasswordVisible:
          isConfirmPasswordVisible ?? this.isConfirmPasswordVisible,
      isTermsPolicyAccepted:
          isTermsPolicyAccepted ?? this.isTermsPolicyAccepted,
      isLoading: isLoading ?? this.isLoading,
      isGoogleLoading: isGoogleLoading ?? this.isGoogleLoading,
      loginStatus: loginStatus ?? this.loginStatus,
      message: isClearMessage ? null : message ?? this.message,
      gender: gender ?? this.gender,
      profileImage: profileImage ?? this.profileImage,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      phoneVerificationId: phoneVerificationId ?? this.phoneVerificationId,
      user: user ?? this.user,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
    );
  }

  @override
  List<Object?> get props => [
    isPasswordVisible,
    isConfirmPasswordVisible,
    isTermsPolicyAccepted,
    isLoading,
    isGoogleLoading,
    loginStatus,
    message,
    gender,
    profileImage,
    profileImageUrl,
    phoneVerificationId,
    user,
    isEmailVerified,
  ];
}
