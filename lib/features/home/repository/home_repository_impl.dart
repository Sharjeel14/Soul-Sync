import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:date_app/core/utils/failure.dart';
import 'package:date_app/features/global/models/user_model.dart';
import 'home_repository.dart';

@LazySingleton(as: HomeRepository)
class HomeRepositoryImpl implements HomeRepository {
  final SupabaseClient _supabase;

  HomeRepositoryImpl({SupabaseClient? supabase})
      : _supabase = supabase ?? Supabase.instance.client;

  @override
  Future<Either<Failure, List<UserModel>>> getAllUsers({
    String? excludeUid,
    String? gender,
  }) async {
    try {
      final response = await _supabase.from('users').select();
      final users = (response as List<dynamic>)
          .map((doc) => UserModel.fromSupabase(doc as Map<String, dynamic>))
          .where((user) {
            if (excludeUid != null && user.uid == excludeUid) return false;
            if (gender != null &&
                gender.isNotEmpty &&
                gender.toLowerCase() != 'all') {
              return user.gender.toLowerCase() == gender.toLowerCase();
            }
            return true;
          })
          .toList();

      return Right(users);
    } catch (e) {
      return Left(ServerFailure('Failed to load users: ${e.toString()}'));
    }
  }

  @override
  Stream<List<UserModel>> streamUsers({
    String? excludeUid,
    String? gender,
  }) {
    try {
      return _supabase
          .from('users')
          .stream(primaryKey: ['uid'])
          .map((data) {
            return data
                .map((doc) => UserModel.fromSupabase(doc))
                .where((user) {
                  if (excludeUid != null && user.uid == excludeUid) return false;
                  if (gender != null &&
                      gender.isNotEmpty &&
                      gender.toLowerCase() != 'all') {
                    return user.gender.toLowerCase() == gender.toLowerCase();
                  }
                  return true;
                })
                .toList();
          })
          .handleError((_) => <UserModel>[]);
    } catch (_) {
      return Stream.value(<UserModel>[]);
    }
  }
}
