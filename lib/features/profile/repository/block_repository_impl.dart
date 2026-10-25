import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:date_app/features/global/models/user_model.dart';
import 'block_repository.dart';

@LazySingleton(as: BlockRepository)
class BlockRepositoryImpl implements BlockRepository {
  final SupabaseClient _supabase;
  final Set<String> _blockedUserIds = {};
  final List<UserModel> _blockedUsersCache = [];
  final StreamController<List<UserModel>> _blockedUsersController =
      StreamController<List<UserModel>>.broadcast();

  BlockRepositoryImpl({SupabaseClient? supabase})
      : _supabase = supabase ?? Supabase.instance.client {
    _init();
  }

  String? get _currentUid => _supabase.auth.currentUser?.id;

  void _init() {
    if (_currentUid != null) {
      getBlockedUsers();
    }
    _supabase.auth.onAuthStateChange.listen((data) {
      if (data.session != null) {
        getBlockedUsers();
      } else {
        _blockedUserIds.clear();
        _blockedUsersCache.clear();
        _blockedUsersController.add([]);
      }
    });
  }

  @override
  bool isBlocked(String uid) {
    return _blockedUserIds.contains(uid);
  }

  @override
  Future<Set<String>> getBlockedUserIds() async {
    final uid = _currentUid;
    if (uid == null) return Set.unmodifiable(_blockedUserIds);

    try {
      final response = await _supabase
          .from('blocked_users')
          .select('blocked_id')
          .eq('blocker_id', uid);

      final list = (response as List<dynamic>)
          .map((row) => row['blocked_id']?.toString() ?? '')
          .where((id) => id.isNotEmpty)
          .toSet();

      _blockedUserIds
        ..clear()
        ..addAll(list);
    } catch (_) {}

    return Set.unmodifiable(_blockedUserIds);
  }

  @override
  Future<List<UserModel>> getBlockedUsers() async {
    final uid = _currentUid;
    if (uid == null) return [];

    try {
      final response = await _supabase
          .from('blocked_users')
          .select('blocked_id')
          .eq('blocker_id', uid);

      final ids = (response as List<dynamic>)
          .map((row) => row['blocked_id']?.toString() ?? '')
          .where((id) => id.isNotEmpty)
          .toList();

      _blockedUserIds
        ..clear()
        ..addAll(ids);

      if (ids.isEmpty) {
        _blockedUsersCache.clear();
        _blockedUsersController.add([]);
        return [];
      }

      final usersResponse = await _supabase
          .from('users')
          .select()
          .filter('uid', 'in', ids);

      final users = (usersResponse as List<dynamic>)
          .map((row) => UserModel.fromSupabase(row as Map<String, dynamic>))
          .toList();

      _blockedUsersCache
        ..clear()
        ..addAll(users);

      _blockedUsersController.add(List.unmodifiable(_blockedUsersCache));
      return List.unmodifiable(_blockedUsersCache);
    } catch (_) {
      return List.unmodifiable(_blockedUsersCache);
    }
  }

  @override
  Stream<List<UserModel>> streamBlockedUsers() async* {
    yield List.unmodifiable(_blockedUsersCache);
    getBlockedUsers();
    yield* _blockedUsersController.stream;
  }

  @override
  Future<void> blockUser(String blockedUid) async {
    if (blockedUid.isEmpty) return;
    _blockedUserIds.add(blockedUid);

    final uid = _currentUid;
    if (uid != null) {
      try {
        await _supabase.from('blocked_users').upsert({
          'blocker_id': uid,
          'blocked_id': blockedUid,
        });
      } catch (_) {}
    }
    await getBlockedUsers();
  }

  @override
  Future<void> unblockUser(String blockedUid) async {
    if (blockedUid.isEmpty) return;
    _blockedUserIds.remove(blockedUid);
    _blockedUsersCache.removeWhere((u) => u.uid == blockedUid);
    _blockedUsersController.add(List.unmodifiable(_blockedUsersCache));

    final uid = _currentUid;
    if (uid != null) {
      try {
        await _supabase
            .from('blocked_users')
            .delete()
            .eq('blocker_id', uid)
            .eq('blocked_id', blockedUid);
      } catch (_) {}
    }
  }
}
