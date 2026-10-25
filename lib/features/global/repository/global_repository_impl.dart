import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:date_app/core/utils/failure.dart';
import 'package:date_app/features/global/models/user_model.dart';
import 'global_repository.dart';

@LazySingleton(as: GlobalRepository)
class GlobalRepositoryImpl implements GlobalRepository {
  final SupabaseClient _supabase;

  GlobalRepositoryImpl({
    SupabaseClient? supabase,
  }) : _supabase = supabase ?? Supabase.instance.client;

  @override
  Future<Either<Failure, UserModel>> getUser() async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        return const Left(AuthFailure('User not authenticated'));
      }

      Map<String, dynamic>? doc;
      try {
        doc = await _supabase
            .from('users')
            .select()
            .eq('uid', currentUser.id)
            .maybeSingle();
      } catch (_) {}

      if (doc == null) {
        final fallbackUser = UserModel(
          uid: currentUser.id,
          name: currentUser.userMetadata?['name']?.toString() ?? 'User',
          email: currentUser.email ?? '',
          phone: currentUser.phone ?? '',
          gender: 'male',
          profileImageUrl:
              currentUser.userMetadata?['profile_image_url']?.toString() ??
              currentUser.userMetadata?['avatar_url']?.toString() ??
              '',
          isEmailVerified: currentUser.emailConfirmedAt != null,
        );
        return Right(fallbackUser);
      }

      return Right(UserModel.fromSupabase(doc, currentUser.id));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
