import 'dart:async';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:date_app/core/di/injection_container.dart';
import 'package:date_app/features/global/models/user_model.dart';
import 'package:date_app/features/global/repository/global_repository.dart';
import 'package:date_app/features/home/repository/home_repository.dart';
import 'package:date_app/features/matches/repository/match_repository.dart';
import 'package:date_app/features/profile/repository/block_repository.dart';

part 'home_state.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  final HomeRepository _repository;
  final MatchRepository _matchRepository;
  final BlockRepository _blockRepository;
  final GlobalRepository _globalRepository;
  final SupabaseClient _supabase;
  StreamSubscription<List<UserModel>>? _subscription;

  HomeCubit(
    this._repository,
    this._matchRepository,
    this._blockRepository, {
    GlobalRepository? globalRepository,
    SupabaseClient? supabase,
  }) : _globalRepository = globalRepository ?? getIt<GlobalRepository>(),
       _supabase = supabase ?? Supabase.instance.client,
       super(const HomeState()) {
    loadUsers();
  }

  Future<void> loadUsers() async {
    emit(state.copyWith(isLoading: true, clearError: true));

    final currentUid = _supabase.auth.currentUser?.id;
    final blockedIds = await _blockRepository.getBlockedUserIds();

    // Determine opposite gender for discovery (male sees female, female sees male)
    String? targetGender;
    try {
      final userResult = await _globalRepository.getUser();
      userResult.fold((_) {}, (currentUser) {
        final g = currentUser.gender.toLowerCase().trim();

        log('current user is ${currentUser.gender}');
        if (g == 'male') {
          targetGender = 'female';
        } else if (g == 'female') {
          targetGender = 'male';
        }
      });
    } catch (_) {}

    final result = await _repository.getAllUsers(excludeUid: currentUid);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: failure.message,
            blockedUserIds: blockedIds,
            selectedGenderFilter: targetGender,
          ),
        );
      },
      (users) {
        emit(
          state.copyWith(
            isLoading: false,
            users: users,
            blockedUserIds: blockedIds,
            selectedGenderFilter: targetGender,
          ),
        );
      },
    );
  }

  void setViewMode(HomeViewMode mode) {
    emit(state.copyWith(viewMode: mode));
  }

  void filterByGender(String? gender) {
    emit(state.copyWith(selectedGenderFilter: gender));
  }

  Future<void> blockUser(String uid) async {
    await _blockRepository.blockUser(uid);
    final updated = Set<String>.from(state.blockedUserIds)..add(uid);
    emit(state.copyWith(blockedUserIds: updated));
  }

  Future<void> onSwipeRight(UserModel user) async {
    final updatedLikes = Set<String>.from(state.likedUserIds)..add(user.uid);
    final updatedSwiped = Set<String>.from(state.swipedUserIds)..add(user.uid);

    emit(
      state.copyWith(
        likedUserIds: updatedLikes,
        swipedUserIds: updatedSwiped,
        lastMatchedUser: user,
      ),
    );

    await _matchRepository.saveMatch(user);
  }

  void onSwipeLeft(UserModel user) {
    final updatedSwiped = Set<String>.from(state.swipedUserIds)..add(user.uid);
    emit(state.copyWith(swipedUserIds: updatedSwiped));
  }

  void undoSwipe(UserModel user) {
    final updatedLikes = Set<String>.from(state.likedUserIds)..remove(user.uid);
    final updatedSwiped = Set<String>.from(state.swipedUserIds)
      ..remove(user.uid);
    emit(
      state.copyWith(likedUserIds: updatedLikes, swipedUserIds: updatedSwiped),
    );
  }

  void dismissMatchDialog() {
    emit(state.copyWith(clearLastMatched: true));
  }

  void updateSelectedIndex(int index) {
    emit(state.copyWith(selectedIndex: index));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
