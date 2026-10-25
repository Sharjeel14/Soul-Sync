import 'dart:developer';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:date_app/core/enums/gender.dart';
import 'package:date_app/features/global/models/user_model.dart';
import 'package:date_app/features/profile/repository/profile_repository.dart';

part 'profile_state.dart';

@injectable
class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository _repository;
  final SupabaseClient _supabase;

  ProfileCubit(this._repository, {SupabaseClient? supabase})
    : _supabase = supabase ?? Supabase.instance.client,
      super(const ProfileState()) {
    loadProfile();
  }

  Future<void> loadProfile() async {
    final uid = _supabase.auth.currentUser?.id;
    if (uid == null) {
      emit(state.copyWith(errorMessage: 'User not logged in'));
      return;
    }

    emit(state.copyWith(isLoading: true, clearMessages: true));

    final result = await _repository.getUserProfile(uid);

    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (user) {
        final gender = GenderType.values.firstWhere(
          (g) => g.name.toLowerCase() == user.gender.toLowerCase(),
          orElse: () => GenderType.male,
        );
        emit(
          state.copyWith(isLoading: false, user: user, selectedGender: gender),
        );
      },
    );
  }

  void pickImage(File? image) {
    emit(state.copyWith(selectedImage: image));
  }

  void updateGender(GenderType gender) {
    emit(state.copyWith(selectedGender: gender));
  }

  Future<void> updateProfile({
    required String name,
    required String email,
    required String phone,
  }) async {
    emit(state.copyWith(errorMessage: '', successMessage: ''));

    final uid = _supabase.auth.currentUser?.id;
    if (uid == null) {
      emit(state.copyWith(errorMessage: 'User not logged in'));
      return;
    }

    emit(state.copyWith(isSaving: true, clearMessages: true));

    final result = await _repository.updateProfile(
      uid: uid,
      name: name,
      email: email,
      phone: phone,
      gender: state.selectedGender,
      newProfileImage: state.selectedImage,
    );

    result.fold(
      (failure) {
        log('failure is ${failure.message}');
        emit(state.copyWith(isSaving: false, errorMessage: failure.message));
      },
      (updatedUser) {
        emit(
          state.copyWith(
            isSaving: false,
            isSuccess: true,
            user: updatedUser,
            selectedImage: null,
            successMessage: 'Profile updated successfully!',
          ),
        );
      },
    );
  }

  Future<void> resetMessages() async {
    emit(state.copyWith(errorMessage: '', successMessage: ''));
  }

  Future<void> logout() async {
    await _repository.logout();
  }
}
