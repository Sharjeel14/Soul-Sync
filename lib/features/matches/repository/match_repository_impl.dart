import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:date_app/features/global/models/user_model.dart';
import 'match_repository.dart';

@LazySingleton(as: MatchRepository)
class MatchRepositoryImpl implements MatchRepository {
  final SupabaseClient _supabase;

  final List<UserModel> _localMatches = [];
  final StreamController<List<UserModel>> _matchesController =
      StreamController<List<UserModel>>.broadcast();
  bool _isRealtimeSubscribed = false;

  MatchRepositoryImpl({
    SupabaseClient? supabase,
  }) : _supabase = supabase ?? Supabase.instance.client;

  String? get _currentUid => _supabase.auth.currentUser?.id;

  @override
  Future<void> saveMatch(UserModel targetUser) async {
    if (!_localMatches.any((u) => u.uid == targetUser.uid)) {
      _localMatches.add(targetUser);
      _matchesController.add(List.unmodifiable(_localMatches));
    }

    final uid = _currentUid;
    if (uid != null && uid.isNotEmpty) {
      try {
        await _supabase.from('matches').upsert({
          'user_id': uid,
          'target_uid': targetUser.uid,
          'matched_user': targetUser.toJson(),
        });
      } catch (_) {
        // Fallback to local
      }
    }
  }

  @override
  Future<List<UserModel>> getMatches() async {
    final uid = _currentUid;
    if (uid != null && uid.isNotEmpty) {
      try {
        final snap = await _supabase
            .from('matches')
            .select()
            .eq('user_id', uid);
        for (final item in snap) {
          final userData = item['matched_user'] as Map<String, dynamic>?;
          if (userData != null) {
            final user = UserModel.fromJson(userData);
            if (!_localMatches.any((u) => u.uid == user.uid)) {
              _localMatches.add(user);
            }
          }
        }
        _matchesController.add(List.unmodifiable(_localMatches));
      } catch (_) {}
    }
    return List.unmodifiable(_localMatches);
  }

  void _initRealtime(String uid) {
    if (_isRealtimeSubscribed) return;
    _isRealtimeSubscribed = true;

    try {
      _supabase
          .from('matches')
          .stream(primaryKey: ['id'])
          .eq('user_id', uid)
          .listen((snap) {
        for (final item in snap) {
          final userData = item['matched_user'] as Map<String, dynamic>?;
          if (userData != null) {
            final user = UserModel.fromJson(userData);
            if (!_localMatches.any((u) => u.uid == user.uid)) {
              _localMatches.add(user);
            }
          }
        }
        _matchesController.add(List.unmodifiable(_localMatches));
      }, onError: (err) {
        // Keep local matches if realtime not yet enabled
      });
    } catch (_) {}
  }

  @override
  Stream<List<UserModel>> streamMatches() async* {
    if (_localMatches.isNotEmpty) {
      yield List.unmodifiable(_localMatches);
    } else {
      await getMatches();
      yield List.unmodifiable(_localMatches);
    }

    final uid = _currentUid;
    if (uid != null && uid.isNotEmpty) {
      _initRealtime(uid);
    }

    yield* _matchesController.stream;
  }

  @override
  bool isMatched(String userId) {
    return _localMatches.any((u) => u.uid == userId);
  }
}
