import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:date_app/core/enums/gender.dart';
import 'package:date_app/core/services/presence_service.dart';
import 'package:date_app/core/utils/failure.dart';
import 'package:date_app/features/auth/services/auth_storage_service.dart';
import 'package:date_app/features/global/models/user_model.dart';
import 'profile_repository.dart';

@LazySingleton(as: ProfileRepository)
class ProfileRepositoryImpl implements ProfileRepository {
  final SupabaseClient _supabase;
  final AuthStorageService _storageService;

  ProfileRepositoryImpl({
    SupabaseClient? supabase,
    AuthStorageService? storageService,
  }) : _supabase = supabase ?? Supabase.instance.client,
       _storageService = storageService ?? AuthStorageService();

  @override
  Future<Either<Failure, UserModel>> getUserProfile(String uid) async {
    try {
      Map<String, dynamic>? doc;
      try {
        doc = await _supabase
            .from('users')
            .select()
            .eq('uid', uid)
            .maybeSingle();
      } catch (_) {}

      if (doc == null) {
        final currentUser = _supabase.auth.currentUser;
        return Right(
          UserModel(
            uid: uid,
            name: currentUser?.userMetadata?['name']?.toString() ?? 'User',
            email: currentUser?.email ?? '',
            phone: currentUser?.phone ?? '',
            gender: 'male',
            profileImageUrl:
                currentUser?.userMetadata?['profile_image_url']?.toString() ??
                '',
            isEmailVerified: currentUser?.emailConfirmedAt != null,
          ),
        );
      }
      return Right(UserModel.fromSupabase(doc, uid));
    } catch (e) {
      return Left(ServerFailure('Failed to fetch profile: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, UserModel>> updateProfile({
    required String uid,
    required String name,
    required String email,
    required String phone,
    required GenderType gender,
    File? newProfileImage,
  }) async {
    try {
      String? uploadedImageUrl;

      // 1. Upload new profile picture to Supabase Storage if selected
      if (newProfileImage != null) {
        final fileName = '${uid}_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final path = 'profiles/$fileName';
        await _supabase.storage.from('profile_images').upload(
              path,
              newProfileImage,
              fileOptions: const FileOptions(upsert: true),
            );
        uploadedImageUrl =
            _supabase.storage.from('profile_images').getPublicUrl(path);
      }

      // 2. Fetch existing data to preserve fields
      Map<String, dynamic>? existingData;
      try {
        existingData = await _supabase
            .from('users')
            .select()
            .eq('uid', uid)
            .maybeSingle();
      } catch (_) {}

      final dataMap = existingData ?? {};
      final profileImageUrl =
          uploadedImageUrl ??
          (dataMap['profile_image_url']?.toString() ??
              dataMap['profileImageUrl']?.toString() ??
              '');

      final updatedUser = UserModel(
        uid: uid,
        name: name.trim(),
        email: email.trim(),
        phone: phone.trim(),
        gender: gender.name,
        profileImageUrl: profileImageUrl,
        bio: (dataMap['bio'] ?? '').toString(),
        dob: (dataMap['dob'] ?? '').toString(),
        isEmailVerified: _supabase.auth.currentUser?.emailConfirmedAt != null,
      );

      // 3. Update Supabase users table
      try {
        await _supabase.from('users').upsert(updatedUser.toSupabase());
      } catch (_) {}

      // 4. Update Supabase Auth user metadata
      final currentUser = _supabase.auth.currentUser;
      if (currentUser != null) {
        try {
          await _supabase.auth.updateUser(
            UserAttributes(
              email: (email.isNotEmpty && email != currentUser.email)
                  ? email.trim()
                  : null,
              data: {
                'name': name.trim(),
                'profile_image_url': ?uploadedImageUrl,
              },
            ),
          );
        } catch (_) {}
      }

      // 5. Update local cache
      await _storageService.saveUser(updatedUser);

      return Right(updatedUser);
    } catch (e) {
      return Left(ServerFailure('Failed to update profile: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await PresenceService().setOffline();
      await PresenceService().stopPresence();
      await _supabase.auth.signOut();
      try {
        await GoogleSignIn.instance.signOut();
      } catch (_) {}
      await _storageService.logout();
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }
}
