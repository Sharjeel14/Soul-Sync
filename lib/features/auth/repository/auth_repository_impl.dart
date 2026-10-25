import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:date_app/core/enums/gender.dart';
import 'package:date_app/core/services/presence_service.dart';
import 'package:date_app/core/utils/failure.dart';
import 'package:date_app/features/auth/services/auth_storage_service.dart';
import 'package:date_app/features/global/models/user_model.dart';

import 'auth_repository.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final SupabaseClient _supabase;
  final GoogleSignIn _googleSignIn;
  final AuthStorageService _storageService;

  AuthRepositoryImpl({
    SupabaseClient? supabase,
    GoogleSignIn? googleSignIn,
    AuthStorageService? storageService,
  }) : _supabase = supabase ?? Supabase.instance.client,
       _googleSignIn = googleSignIn ?? GoogleSignIn.instance,
       _storageService = storageService ?? AuthStorageService();

  @override
  Future<Either<Failure, UserModel>> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final res = await _supabase.auth.signInWithPassword(
        email: email.trim(),
        password: password,
      );

      final user = res.user;
      if (user == null) {
        return const Left(AuthFailure('User authentication failed'));
      }

      Map<String, dynamic>? doc;
      try {
        doc = await _supabase
            .from('users')
            .select()
            .eq('uid', user.id)
            .maybeSingle();
      } catch (_) {}

      UserModel userModel;
      if (doc != null) {
        userModel = UserModel.fromSupabase(doc, user.id);
      } else {
        userModel = UserModel(
          uid: user.id,
          name: user.userMetadata?['name']?.toString() ?? 'User',
          email: user.email ?? email,
          phone: user.phone ?? '',
          gender: 'male',
          profileImageUrl:
              user.userMetadata?['profile_image_url']?.toString() ?? '',
          isEmailVerified: user.emailConfirmedAt != null,
        );
        try {
          await _supabase.from('users').upsert(userModel.toSupabase());
        } catch (_) {}
      }

      await _storageService.saveAccessToken(
        res.session?.accessToken ?? user.id,
      );
      if (res.session?.refreshToken != null) {
        await _storageService.saveRefreshToken(res.session!.refreshToken!);
      }
      await _storageService.saveUser(userModel);

      return Right(userModel);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserModel>> registerWithEmail({
    required String name,
    required String email,
    required String password,
    required String phone,
    required GenderType gender,
    File? profileImage,
  }) async {
    try {
      final res = await _supabase.auth.signUp(
        email: email.trim(),
        password: password,
        data: {
          'name': name.trim(),
          'phone': phone.trim(),
          'gender': gender.name,
        },
      );

      final user = res.user;
      if (user == null) {
        return const Left(AuthFailure('Registration failed'));
      }

      String profileImageUrl = '';
      if (profileImage != null) {
        final uploadResult = await uploadProfileImage(profileImage, user.id);
        uploadResult.fold((_) {}, (url) => profileImageUrl = url);
      }

      final userModel = UserModel(
        uid: user.id,
        name: name.trim(),
        email: email.trim(),
        phone: phone.trim(),
        gender: gender.name,
        profileImageUrl: profileImageUrl,
        createdAt: DateTime.now(),
        isEmailVerified: user.emailConfirmedAt != null,
      );

      try {
        await _supabase.from('users').upsert(userModel.toSupabase());
      } catch (_) {}

      if (profileImageUrl.isNotEmpty) {
        try {
          await _supabase.auth.updateUser(
            UserAttributes(data: {'profile_image_url': profileImageUrl}),
          );
        } catch (_) {}
      }

      await _storageService.saveAccessToken(
        res.session?.accessToken ?? user.id,
      );
      if (res.session?.refreshToken != null) {
        await _storageService.saveRefreshToken(res.session!.refreshToken!);
      }
      await _storageService.saveUser(userModel);

      return Right(userModel);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserModel>> loginWithGoogle() async {
    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();
      final String? idToken = googleUser.authentication.idToken;
      if (idToken == null) {
        return const Left(AuthFailure('Failed to obtain Google ID token'));
      }

      final res = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
      );

      final user = res.user;
      final session = res.session;
      if (user == null || session == null) {
        return const Left(AuthFailure('Google authentication failed'));
      }

      // Load existing profile, if any
      Map<String, dynamic>? doc;
      try {
        doc = await _supabase
            .from('users')
            .select()
            .eq('uid', user.id)
            .maybeSingle();
      } catch (e) {
        debugPrint('Fetch user profile failed: $e');
      }

      UserModel userModel;
      if (doc != null) {
        userModel = UserModel.fromSupabase(doc, user.id);
      } else {
        userModel = UserModel(
          uid: user.id,
          name:
              googleUser.displayName ??
              user.userMetadata?['name']?.toString() ??
              'Google User',
          email: googleUser.email,
          phone: user.phone ?? '',
          gender: '',
          profileImageUrl:
              googleUser.photoUrl ??
              user.userMetadata?['avatar_url']?.toString() ??
              '',
          createdAt: DateTime.now(),
          isEmailVerified: true,
        );
        try {
          await _supabase.from('users').upsert(userModel.toSupabase());
        } catch (e) {
          debugPrint('Create user profile failed: $e');
        }
      }

      await _storageService.saveAccessToken(session.accessToken);
      final refreshToken = session.refreshToken;
      if (refreshToken != null) {
        await _storageService.saveRefreshToken(refreshToken);
      }
      await _storageService.saveUser(userModel);

      return Right(userModel);
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        return const Left(AuthFailure('Sign-in cancelled'));
      }

      final details = e.details;
      final native = details is Map
          ? details['NSLocalizedDescription']?.toString()
          : null;

      return Left(
        AuthFailure(native ?? e.description ?? 'Google sign-in failed'),
      );
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> sendPhoneOtp({
    required String phoneNumber,
    required Function(String verificationId) onCodeSent,
    required Function(String error) onError,
  }) async {
    try {
      await _supabase.auth.signInWithOtp(phone: phoneNumber.trim());
      onCodeSent(phoneNumber.trim());
      return const Right(null);
    } on AuthException catch (e) {
      onError(e.message);
      return Left(AuthFailure(e.message));
    } catch (e) {
      onError(e.toString());
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserModel>> verifyPhoneOtp({
    required String verificationId,
    required String smsCode,
    String? name,
    GenderType? gender,
    File? profileImage,
  }) async {
    try {
      final res = await _supabase.auth.verifyOTP(
        phone: verificationId.trim(),
        token: smsCode.trim(),
        type: OtpType.sms,
      );

      final user = res.user;
      if (user == null) {
        return const Left(AuthFailure('Phone authentication failed'));
      }

      Map<String, dynamic>? doc;
      try {
        doc = await _supabase
            .from('users')
            .select()
            .eq('uid', user.id)
            .maybeSingle();
      } catch (_) {}

      UserModel userModel;
      if (doc != null) {
        userModel = UserModel.fromSupabase(doc, user.id);
      } else {
        String profileImageUrl = '';
        if (profileImage != null) {
          final uploadResult = await uploadProfileImage(profileImage, user.id);
          uploadResult.fold((_) {}, (url) => profileImageUrl = url);
        }

        userModel = UserModel(
          uid: user.id,
          name: (name != null && name.isNotEmpty)
              ? name
              : (user.userMetadata?['name']?.toString() ?? 'User'),
          email: user.email ?? '',
          phone: user.phone ?? verificationId,
          gender: gender?.name ?? 'male',
          profileImageUrl: profileImageUrl,
          createdAt: DateTime.now(),
          isEmailVerified: true,
        );
        try {
          await _supabase.from('users').upsert(userModel.toSupabase());
        } catch (_) {}
      }

      await _storageService.saveAccessToken(
        res.session?.accessToken ?? user.id,
      );
      if (res.session?.refreshToken != null) {
        await _storageService.saveRefreshToken(res.session!.refreshToken!);
      }
      await _storageService.saveUser(userModel);

      return Right(userModel);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> sendEmailVerification() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null || user.email == null) {
        return const Left(AuthFailure('No user signed in'));
      }
      await _supabase.auth.resend(type: OtpType.signup, email: user.email);
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> checkEmailVerified() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        return const Right(false);
      }
      final response = await _supabase.auth.getUser();
      final isVerified = response.user?.emailConfirmedAt != null;
      if (isVerified) {
        try {
          await _supabase
              .from('users')
              .update({'is_email_verified': true})
              .eq('uid', user.id);
        } catch (_) {}
      }
      return Right(isVerified);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> sendPasswordResetEmail(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email.trim());
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadProfileImage(
    File file,
    String uid,
  ) async {
    try {
      final fileName = '${uid}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final path = 'profiles/$fileName';
      await _supabase.storage
          .from('profile_images')
          .upload(path, file, fileOptions: const FileOptions(upsert: true));
      final downloadUrl = _supabase.storage
          .from('profile_images')
          .getPublicUrl(path);
      return Right(downloadUrl);
    } catch (e) {
      return Left(AuthFailure('Image upload failed: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, UserModel?>> getCurrentUser() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return const Right(null);

      Map<String, dynamic>? doc;
      try {
        doc = await _supabase
            .from('users')
            .select()
            .eq('uid', user.id)
            .maybeSingle();
      } catch (_) {}

      if (doc != null) {
        return Right(UserModel.fromSupabase(doc, user.id));
      }
      return Right(
        UserModel(
          uid: user.id,
          name: user.userMetadata?['name']?.toString() ?? 'User',
          email: user.email ?? '',
          phone: user.phone ?? '',
          gender: 'male',
          profileImageUrl:
              user.userMetadata?['profile_image_url']?.toString() ?? '',
          isEmailVerified: user.emailConfirmedAt != null,
        ),
      );
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await PresenceService().setOffline();
      await PresenceService().stopPresence();
      await _supabase.auth.signOut();
      try {
        await _googleSignIn.signOut();
      } catch (_) {}
      await _storageService.logout();
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user != null) {
        await PresenceService().setOffline(user.id);
        await PresenceService().stopPresence();
        try {
          await _supabase.from('users').delete().eq('uid', user.id);
        } catch (_) {}
        await _supabase.auth.signOut();
      }
      await _storageService.logout();
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }
}
