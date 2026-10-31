import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:date_app/core/enums/gender.dart';
import 'package:date_app/core/utils/failure.dart';
import 'package:date_app/features/global/models/user_model.dart';

abstract class ProfileRepository {
  Future<Either<Failure, UserModel>> getUserProfile(String uid);

  Future<Either<Failure, UserModel>> updateProfile({
    required String uid,
    required String name,
    required String email,
    required String phone,
    required GenderType gender,
    File? newProfileImage,
  });

  Future<Either<Failure, void>> logout();
}
