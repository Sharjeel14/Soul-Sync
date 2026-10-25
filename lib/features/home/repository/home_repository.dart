import 'package:dartz/dartz.dart';
import 'package:date_app/core/utils/failure.dart';
import 'package:date_app/features/global/models/user_model.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<UserModel>>> getAllUsers({
    String? excludeUid,
    String? gender,
  });
  Stream<List<UserModel>> streamUsers({
    String? excludeUid,
    String? gender,
  });
}
