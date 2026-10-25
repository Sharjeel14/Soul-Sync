import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:date_app/core/enums/gender.dart';
import 'package:date_app/core/utils/failure.dart';
import 'package:date_app/features/global/models/user_model.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserModel>> loginWithEmail({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserModel>> registerWithEmail({
    required String name,
    required String email,
    required String password,
    required String phone,
    required GenderType gender,
    File? profileImage,
  });

  Future<Either<Failure, UserModel>> loginWithGoogle();

  Future<Either<Failure, void>> sendPhoneOtp({
    required String phoneNumber,
    required Function(String verificationId) onCodeSent,
    required Function(String error) onError,
  });

  Future<Either<Failure, UserModel>> verifyPhoneOtp({
    required String verificationId,
    required String smsCode,
    String? name,
    GenderType? gender,
    File? profileImage,
  });

  Future<Either<Failure, void>> sendEmailVerification();

  Future<Either<Failure, bool>> checkEmailVerified();

  Future<Either<Failure, void>> sendPasswordResetEmail(String email);

  Future<Either<Failure, String>> uploadProfileImage(File file, String uid);

  Future<Either<Failure, UserModel?>> getCurrentUser();

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, void>> deleteAccount();
}
