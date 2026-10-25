import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PresenceService with WidgetsBindingObserver {
  static final PresenceService _instance = PresenceService._internal();
  factory PresenceService() => _instance;
  PresenceService._internal();

  SupabaseClient get _supabase => Supabase.instance.client;
  RealtimeChannel? _presenceChannel;
  RealtimeChannel? _dbPresenceChannel;

  final Set<String> _realtimeOnlineIds = {};
  final Set<String> _dbOnlineIds = {};
  final Set<String> _botOnlineIds = {};
  final StreamController<Set<String>> _onlineUsersController =
      StreamController<Set<String>>.broadcast();

  Timer? _heartbeatTimer;
  Timer? _staleCleanupTimer;
  bool _isObserverRegistered = false;
  String? _currentTrackedUid;

  Stream<Set<String>> get onlineUsersStream async* {
    yield onlineUserIds;
    yield* _onlineUsersController.stream;
  }

  Set<String> get onlineUserIds =>
      Set.unmodifiable({..._realtimeOnlineIds, ..._dbOnlineIds, ..._botOnlineIds});

  void _emitOnlineUsers() {
    if (!_onlineUsersController.isClosed) {
      _onlineUsersController.add(onlineUserIds);
    }
  }

  bool isUserOnline(String uid) {
    if (uid.isEmpty) return false;
    return _botOnlineIds.contains(uid) ||
        _realtimeOnlineIds.contains(uid) ||
        _dbOnlineIds.contains(uid);
  }

  Stream<bool> streamUserOnlineStatus(String uid) async* {
    yield isUserOnline(uid);
    yield* _onlineUsersController.stream
        .map((ids) => ids.contains(uid))
        .distinct();
  }

  Future<bool> checkUserStatus(String uid) async {
    if (uid.isEmpty) return false;
    if (_botOnlineIds.contains(uid) || _realtimeOnlineIds.contains(uid)) return true;

    try {
      final row = await _supabase
          .from('users')
          .select('is_online, last_seen, is_bot')
          .eq('uid', uid)
          .maybeSingle();

      if (row != null && row['is_bot'] == true) {
        _botOnlineIds.add(uid);
        _emitOnlineUsers();
        return true;
      }

      if (row != null && row['is_online'] == true) {
        final lastSeenRaw = row['last_seen']?.toString();
        if (lastSeenRaw != null) {
          final lastSeen = DateTime.tryParse(lastSeenRaw);
          if (lastSeen != null &&
              DateTime.now().toUtc().difference(lastSeen).inSeconds <= 75) {
            _dbOnlineIds.add(uid);
            _emitOnlineUsers();
            return true;
          }
        }
      }
    } catch (_) {}

    if (_dbOnlineIds.remove(uid) || _realtimeOnlineIds.remove(uid)) {
      _emitOnlineUsers();
    }
    return false;
  }

  void initialize() {
    if (!_isObserverRegistered) {
      WidgetsBinding.instance.addObserver(this);
      _isObserverRegistered = true;
    }

    _listenToDatabasePresence();
    _fetchInitialOnlineUsers();
    _startStaleCleanupTimer();

    _supabase.auth.onAuthStateChange.listen((data) {
      final session = data.session;
      if (session != null) {
        startPresence(session.user.id);
      } else {
        stopPresence();
      }
    });

    final currentUid = _supabase.auth.currentUser?.id;
    if (currentUid != null && currentUid.isNotEmpty) {
      startPresence(currentUid);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    debugPrint('📱 PresenceService AppLifecycleState: $state');
    switch (state) {
      case AppLifecycleState.resumed:
        setOnline();
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
      case AppLifecycleState.detached:
        setOffline();
        break;
      case AppLifecycleState.inactive:
        break;
    }
  }

  Future<void> _fetchInitialOnlineUsers() async {
    // 1. Fetch all bots (they are permanently online)
    try {
      final botRows = await _supabase
          .from('users')
          .select('uid')
          .eq('is_bot', true);
      final botIds = (botRows as List<dynamic>)
          .map((r) => r['uid']?.toString())
          .whereType<String>();
      _botOnlineIds.addAll(botIds);
      _emitOnlineUsers();
    } catch (_) {}

    try {
      final cutoff = DateTime.now()
          .toUtc()
          .subtract(const Duration(seconds: 75))
          .toIso8601String();

      final rows = await _supabase
          .from('users')
          .select('uid, last_seen')
          .eq('is_online', true)
          .gte('last_seen', cutoff);

      final freshIds = <String>{};
      for (final r in rows) {
        final id = r['uid']?.toString();
        if (id != null && id.isNotEmpty) {
          freshIds.add(id);
        }
      }
      if (_currentTrackedUid != null && _currentTrackedUid!.isNotEmpty) {
        freshIds.add(_currentTrackedUid!);
      }

      _dbOnlineIds
        ..clear()
        ..addAll(freshIds);
      _emitOnlineUsers();
    } catch (_) {
      try {
        final fallbackRows = await _supabase
            .from('users')
            .select('uid')
            .eq('is_online', true)
            .limit(50);
        final fallbackIds = <String>{};
        for (final r in fallbackRows) {
          final id = r['uid']?.toString();
          if (id != null && id.isNotEmpty) {
            fallbackIds.add(id);
          }
        }
        if (_currentTrackedUid != null && _currentTrackedUid!.isNotEmpty) {
          fallbackIds.add(_currentTrackedUid!);
        }
        _dbOnlineIds
          ..clear()
          ..addAll(fallbackIds);
        _emitOnlineUsers();
      } catch (_) {}
    }
  }

  void _listenToDatabasePresence() {
    if (_dbPresenceChannel != null) return;

    try {
      _dbPresenceChannel = _supabase
          .channel('public:users_presence')
          .onPostgresChanges(
            event: PostgresChangeEvent.all,
            schema: 'public',
            table: 'users',
            callback: (payload) {
              final newRecord = payload.newRecord;
              if (newRecord.isEmpty) return;

              final uid = newRecord['uid']?.toString();
              final isOnline = newRecord['is_online'] == true;
              if (uid != null && uid.isNotEmpty) {
                if (isOnline) {
                  _dbOnlineIds.add(uid);
                } else {
                  _dbOnlineIds.remove(uid);
                  _realtimeOnlineIds.remove(uid);
                }
                _emitOnlineUsers();
              }
            },
          )
          .subscribe();
    } catch (e) {
      debugPrint('Error subscribing to DB presence changes: $e');
    }
  }

  Future<void> startPresence(String uid) async {
    if (uid.isEmpty) return;
    _currentTrackedUid = uid;

    _listenToDatabasePresence();
    _startHeartbeat(uid);
    _startStaleCleanupTimer();

    _realtimeOnlineIds.add(uid);
    _dbOnlineIds.add(uid);
    _emitOnlineUsers();

    // Update database immediately
    _supabase.from('users').update({
      'is_online': true,
      'last_seen': DateTime.now().toUtc().toIso8601String(),
    }).eq('uid', uid).catchError((_) => null);

    if (_presenceChannel != null) {
      try {
        await _presenceChannel!.track({
          'uid': uid,
          'online_at': DateTime.now().toUtc().toIso8601String(),
        });
      } catch (_) {}
      return;
    }

    try {
      _presenceChannel = _supabase.channel('online_presence');

      _presenceChannel!.onPresenceSync((_) {
        final state = _presenceChannel!.presenceState();
        final currentSet = <String>{};
        for (final singleState in state) {
          for (final presence in singleState.presences) {
            final userUid = presence.payload['uid']?.toString();
            if (userUid != null && userUid.isNotEmpty) {
              currentSet.add(userUid);
            }
          }
        }
        _realtimeOnlineIds
          ..clear()
          ..addAll(currentSet);

        if (_currentTrackedUid != null && _currentTrackedUid!.isNotEmpty) {
          currentSet.add(_currentTrackedUid!);
        }
        _dbOnlineIds.retainAll(currentSet);
        _emitOnlineUsers();
      });

      _presenceChannel!.onPresenceJoin((payload) {
        for (final presence in payload.newPresences) {
          final userUid = presence.payload['uid']?.toString();
          if (userUid != null && userUid.isNotEmpty) {
            _realtimeOnlineIds.add(userUid);
            _dbOnlineIds.add(userUid);
          }
        }
        _emitOnlineUsers();
      });

      _presenceChannel!.onPresenceLeave((payload) {
        for (final presence in payload.leftPresences) {
          final userUid = presence.payload['uid']?.toString();
          if (userUid != null && userUid.isNotEmpty) {
            _realtimeOnlineIds.remove(userUid);
            _dbOnlineIds.remove(userUid);
          }
        }
        _emitOnlineUsers();
      });

      _presenceChannel!.subscribe((status, [error]) async {
        if (status == RealtimeSubscribeStatus.subscribed) {
          final currentUid = _currentTrackedUid ?? _supabase.auth.currentUser?.id;
          if (currentUid != null && currentUid.isNotEmpty) {
            try {
              await _presenceChannel!.track({
                'uid': currentUid,
                'online_at': DateTime.now().toUtc().toIso8601String(),
              });
            } catch (_) {}
            _realtimeOnlineIds.add(currentUid);
            _dbOnlineIds.add(currentUid);
            _emitOnlineUsers();
          }
        }
      });
    } catch (e) {
      debugPrint('Presence error: $e');
    }
  }

  void _startHeartbeat(String uid) {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(const Duration(seconds: 20), (_) async {
      final currentUid = _currentTrackedUid ?? _supabase.auth.currentUser?.id;
      if (currentUid == null || currentUid.isEmpty) {
        _heartbeatTimer?.cancel();
        return;
      }

      // 1. Touch DB last_seen
      try {
        await _supabase.from('users').update({
          'is_online': true,
          'last_seen': DateTime.now().toUtc().toIso8601String(),
        }).eq('uid', currentUid);
      } catch (_) {}

      // 2. Keep presence channel tracked
      if (_presenceChannel != null) {
        try {
          await _presenceChannel!.track({
            'uid': currentUid,
            'online_at': DateTime.now().toUtc().toIso8601String(),
          });
        } catch (_) {}
      }
    });
  }

  void _startStaleCleanupTimer() {
    _staleCleanupTimer?.cancel();
    _staleCleanupTimer = Timer.periodic(const Duration(seconds: 45), (_) {
      _fetchInitialOnlineUsers();
    });
  }

  Future<void> setOnline([String? explicitUid]) async {
    final uid = explicitUid ?? _currentTrackedUid ?? _supabase.auth.currentUser?.id;
    if (uid == null || uid.isEmpty) return;
    _currentTrackedUid = uid;

    _realtimeOnlineIds.add(uid);
    _dbOnlineIds.add(uid);
    _emitOnlineUsers();

    _listenToDatabasePresence();
    _startHeartbeat(uid);

    final futures = <Future<dynamic>>[];

    if (_presenceChannel != null) {
      futures.add(() async {
        try {
          await _presenceChannel!.track({
            'uid': uid,
            'online_at': DateTime.now().toUtc().toIso8601String(),
          });
        } catch (e) {
          debugPrint('Track online error: $e');
        }
      }());
    } else {
      futures.add(startPresence(uid));
    }

    futures.add(
      _supabase
          .from('users')
          .update({
            'is_online': true,
            'last_seen': DateTime.now().toUtc().toIso8601String(),
          })
          .eq('uid', uid)
          .catchError((e) {
            debugPrint('DB setOnline error: $e');
            return null;
          }),
    );

    try {
      await Future.wait(futures).timeout(const Duration(seconds: 2));
    } catch (_) {}
  }

  Future<void> setOffline([String? explicitUid]) async {
    _heartbeatTimer?.cancel();

    final uid = explicitUid ?? _currentTrackedUid ?? _supabase.auth.currentUser?.id;
    if (uid == null || uid.isEmpty) return;

    _realtimeOnlineIds.remove(uid);
    _dbOnlineIds.remove(uid);
    _emitOnlineUsers();

    final futures = <Future<dynamic>>[];

    if (_presenceChannel != null) {
      futures.add(() async {
        try {
          await _presenceChannel!.untrack();
        } catch (e) {
          debugPrint('Untrack offline error: $e');
        }
      }());
    }

    futures.add(
      _supabase
          .from('users')
          .update({
            'is_online': false,
            'last_seen': DateTime.now().toUtc().toIso8601String(),
          })
          .eq('uid', uid)
          .catchError((e) {
            debugPrint('DB setOffline error: $e');
            return null;
          }),
    );

    try {
      await Future.wait(futures).timeout(const Duration(milliseconds: 1500));
    } catch (_) {}
  }

  Future<void> stopPresence() async {
    _heartbeatTimer?.cancel();
    _staleCleanupTimer?.cancel();

    final uid = _currentTrackedUid ?? _supabase.auth.currentUser?.id;
    if (uid != null && uid.isNotEmpty) {
      await setOffline(uid);
    }
    _currentTrackedUid = null;

    if (_presenceChannel != null) {
      try {
        await _supabase.removeChannel(_presenceChannel!);
      } catch (_) {}
      _presenceChannel = null;
    }

    if (_dbPresenceChannel != null) {
      try {
        await _supabase.removeChannel(_dbPresenceChannel!);
      } catch (_) {}
      _dbPresenceChannel = null;
    }

    _realtimeOnlineIds.clear();
    _dbOnlineIds.clear();
    _emitOnlineUsers();
  }
}
