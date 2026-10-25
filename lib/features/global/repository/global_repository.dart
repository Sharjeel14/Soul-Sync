import 'package:dartz/dartz.dart';
import 'package:date_app/core/utils/failure.dart';
import 'package:date_app/features/global/models/user_model.dart';

abstract class GlobalRepository {
  Future<Either<Failure, UserModel>> getUser();
}
