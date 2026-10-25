import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:date_app/core/di/injection_container.dart';
import 'package:date_app/features/chat/models/chat_message.dart';
import 'package:date_app/features/chat/models/conversation_item.dart';
import 'package:date_app/features/global/models/user_model.dart';
import 'package:date_app/features/matches/repository/match_repository.dart';

import 'chat_repository.dart';

@LazySingleton(as: ChatRepository)
class ChatRepositoryImpl implements ChatRepository {
  final SupabaseClient _supabase;

  final Map<String, List<ChatMessage>> _localChats = {};
  final Map<String, StreamController<List<ChatMessage>>> _streamControllers =
      {};
  final Map<String, StreamSubscription?> _subscriptions = {};

  final Map<String, UserModel> _userCache = {};
  final Map<String, ChatMessage> _latestMessages = {}; // key: peerUid
  final Map<String, int> _unreadCounts = {}; // key: peerUid

  final StreamController<List<ConversationItem>> _conversationsController =
      StreamController<List<ConversationItem>>.broadcast();
  final StreamController<ChatMessage> _incomingMessageController =
      StreamController<ChatMessage>.broadcast();

  bool _isGlobalChannelSubscribed = false;
  List<ConversationItem> _cachedConversations = [];

  ChatRepositoryImpl({SupabaseClient? supabase})
      : _supabase = supabase ?? Supabase.instance.client;

  String get _currentUid => _supabase.auth.currentUser?.id ?? '';

  String _getChatId(String u1, String u2) {
    return u1.compareTo(u2) < 0 ? '${u1}_$u2' : '${u2}_$u1';
  }

  StreamController<List<ChatMessage>> _getController(String chatId) {
    if (!_streamControllers.containsKey(chatId) ||
        _streamControllers[chatId]!.isClosed) {
      _streamControllers[chatId] =
          StreamController<List<ChatMessage>>.broadcast();
    }
    return _streamControllers[chatId]!;
  }

  @override
  Stream<ChatMessage> get onNewIncomingMessage =>
      _incomingMessageController.stream;

  @override
  Future<UserModel?> getUserProfile(String uid) async {
    if (uid.isEmpty) return null;
    if (_userCache.containsKey(uid)) {
      return _userCache[uid];
    }

    try {
      final res = await _supabase
          .from('users')
          .select()
          .eq('uid', uid)
          .maybeSingle();

      if (res != null) {
        final user = UserModel.fromSupabase(res);
        _userCache[uid] = user;
        return user;
      }
    } catch (e) {
      debugPrint('Error fetching user profile for $uid: $e');
    }
    return null;
  }

  void _initGlobalMessagesListener() {
    if (_isGlobalChannelSubscribed) return;
    _isGlobalChannelSubscribed = true;

    try {
      _supabase
          .channel('public:messages_global')
          .onPostgresChanges(
            event: PostgresChangeEvent.all,
            schema: 'public',
            table: 'messages',
            callback: (payload) async {
              final newRecord = payload.newRecord;
              if (newRecord.isEmpty) return;

              final msg = ChatMessage.fromJson(newRecord);
              final myUid = _currentUid;
              if (myUid.isEmpty) return;

              // Check if relevant to current user
              if (msg.senderId != myUid && msg.receiverId != myUid) {
                return;
              }

              final peerUid =
                  msg.senderId == myUid ? msg.receiverId : msg.senderId;
              final chatId = _getChatId(msg.senderId, msg.receiverId);

              // 1. Update single active chat cache
              _localChats.putIfAbsent(chatId, () => []);
              final chatList = _localChats[chatId]!;
              final existingIndex = chatList.indexWhere((m) => m.id == msg.id);
              if (existingIndex >= 0) {
                chatList[existingIndex] = msg;
              } else {
                chatList.add(msg);
                chatList.sort((a, b) => a.timestamp.compareTo(b.timestamp));
              }
              _getController(chatId).add(List.unmodifiable(chatList));

              // 2. Update latest message for conversation listing
              final currentLatest = _latestMessages[peerUid];
              if (currentLatest == null ||
                  msg.timestamp.isAfter(currentLatest.timestamp) ||
                  msg.id == currentLatest.id) {
                _latestMessages[peerUid] = msg;
              }

              // 3. Update unread count
              if (payload.eventType == PostgresChangeEvent.insert &&
                  msg.receiverId == myUid &&
                  msg.senderId != myUid) {
                if (!msg.isRead) {
                  _unreadCounts[peerUid] = (_unreadCounts[peerUid] ?? 0) + 1;
                }
                _incomingMessageController.add(msg);
              } else if (payload.eventType == PostgresChangeEvent.update &&
                  msg.isRead) {
                if (msg.receiverId == myUid) {
                  _unreadCounts[peerUid] = 0;
                }
              }

              // 4. Ensure user profile is fetched & rebuild conversation list
              if (!_userCache.containsKey(peerUid)) {
                await getUserProfile(peerUid);
              }
              await _rebuildAndEmitConversations();
            },
          )
          .subscribe();
    } catch (e) {
      debugPrint('Error subscribing to global messages channel: $e');
    }
  }

  Future<void> _fetchConversationsData() async {
    final myUid = _currentUid;
    if (myUid.isEmpty) return;

    // 1. Fetch mutual matches first so all matched users are known in the user listing
    try {
      final matchRepo = getIt<MatchRepository>();
      final matches = await matchRepo.getMatches();
      for (final m in matches) {
        _userCache[m.uid] = m;
      }
    } catch (e) {
      debugPrint('Error fetching matches for conversations: $e');
    }

    // 2. Fetch only RECENT messages involving current user (descending order, limit 100)
    // Avoids downloading whole conversation history!
    try {
      final rawRecent = await _supabase
          .from('messages')
          .select()
          .or('sender_id.eq.$myUid,receiver_id.eq.$myUid')
          .order('timestamp', ascending: false)
          .limit(100);

      final recentMsgs = (rawRecent as List<dynamic>)
          .map((d) => ChatMessage.fromJson(d as Map<String, dynamic>))
          .toList();

      _latestMessages.clear();
      _unreadCounts.clear();

      for (final m in recentMsgs) {
        final peer = m.senderId == myUid ? m.receiverId : m.senderId;
        // Since messages are sorted newest first, the first time we encounter peer is their latest message!
        if (!_latestMessages.containsKey(peer)) {
          _latestMessages[peer] = m;
        }
        if (m.receiverId == myUid && !m.isRead) {
          _unreadCounts[peer] = (_unreadCounts[peer] ?? 0) + 1;
        }
      }

      // Fetch user profiles for peers who are not cached
      for (final peerUid in _latestMessages.keys) {
        if (!_userCache.containsKey(peerUid)) {
          await getUserProfile(peerUid);
        }
      }
    } catch (e) {
      debugPrint('Fetch conversations error: $e');
    }

    await _rebuildAndEmitConversations();
  }

  Future<void> _rebuildAndEmitConversations() async {
    final myUid = _currentUid;
    if (myUid.isEmpty) return;

    // Find all distinct peer user IDs (all matches + all users who sent/received messages)
    final allPeerUids = <String>{..._userCache.keys, ..._latestMessages.keys}
      ..remove(myUid)
      ..remove('');

    final items = <ConversationItem>[];

    for (final peerUid in allPeerUids) {
      UserModel? user = _userCache[peerUid];
      user ??= await getUserProfile(peerUid);
      if (user == null) continue;

      final lastMsg = _latestMessages[peerUid];
      final unreadCount = _unreadCounts[peerUid] ?? 0;
      final lastActivity =
          lastMsg?.timestamp ?? user.createdAt ?? DateTime(2020);

      items.add(
        ConversationItem(
          user: user,
          lastMessage: lastMsg,
          unreadCount: unreadCount,
          lastActivity: lastActivity,
        ),
      );
    }

    // Sort:
    // Conversations with recent messages on top, then newer matches ready to chat
    items.sort((a, b) {
      final aHasMsg = a.lastMessage != null;
      final bHasMsg = b.lastMessage != null;
      if (aHasMsg && !bHasMsg) return -1;
      if (!aHasMsg && bHasMsg) return 1;
      return b.lastActivity.compareTo(a.lastActivity);
    });

    _cachedConversations = items;
    _conversationsController.add(List.unmodifiable(items));
  }

  @override
  Future<void> refreshConversations() async {
    await _fetchConversationsData();
  }

  @override
  Stream<List<ConversationItem>> streamConversations() async* {
    _initGlobalMessagesListener();

    if (_cachedConversations.isNotEmpty) {
      yield List.unmodifiable(_cachedConversations);
    }

    await _fetchConversationsData();
    yield List.unmodifiable(_cachedConversations);

    yield* _conversationsController.stream;
  }

  @override
  Future<String?> uploadChatImage(File imageFile) async {
    final uid = _currentUid;
    final fileName = 'chat_${uid}_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final path = 'chat/$fileName';

    try {
      await _supabase.storage.from('chat_images').upload(
            path,
            imageFile,
            fileOptions: const FileOptions(upsert: true),
          );
      return _supabase.storage.from('chat_images').getPublicUrl(path);
    } catch (_) {
      try {
        await _supabase.storage.from('profile_images').upload(
              path,
              imageFile,
              fileOptions: const FileOptions(upsert: true),
            );
        return _supabase.storage.from('profile_images').getPublicUrl(path);
      } catch (e) {
        debugPrint('Upload image error: $e');
        return null;
      }
    }
  }

  @override
  Future<void> sendMessage({
    required String targetUserId,
    required String text,
    String? imageUrl,
  }) async {
    final senderId = _currentUid;
    if (senderId.isEmpty) return;

    final chatId = _getChatId(senderId, targetUserId);
    final msgId = '${DateTime.now().millisecondsSinceEpoch}_$senderId';
    final now = DateTime.now();

    final msg = ChatMessage(
      id: msgId,
      senderId: senderId,
      receiverId: targetUserId,
      text: text,
      imageUrl: imageUrl,
      timestamp: now,
      isRead: false,
    );

    // Optimistically update local single chat
    _localChats.putIfAbsent(chatId, () => []);
    if (!_localChats[chatId]!.any((m) => m.id == msgId)) {
      _localChats[chatId]!.add(msg);
      _getController(chatId).add(List.unmodifiable(_localChats[chatId]!));
    }

    // Optimistically update conversation listing
    _latestMessages[targetUserId] = msg;
    _rebuildAndEmitConversations();

    // Persist to Supabase messages table
    try {
      final payload = <String, dynamic>{
        'id': msg.id,
        'chat_id': chatId,
        'sender_id': senderId,
        'receiver_id': targetUserId,
        'text': text,
        'timestamp': msg.timestamp.toUtc().toIso8601String(),
        'is_read': false,
      };
      if (imageUrl != null && imageUrl.isNotEmpty) {
        payload['image_url'] = imageUrl;
      }

      await _supabase.from('messages').upsert(payload);
    } catch (e) {
      debugPrint('Send message error: $e');
    }
  }

  @override
  Stream<List<ChatMessage>> streamMessages(String targetUserId) async* {
    _initGlobalMessagesListener();

    final senderId = _currentUid;
    final chatId = _getChatId(senderId, targetUserId);

    _localChats.putIfAbsent(chatId, () => []);
    if (_localChats[chatId]!.isNotEmpty) {
      yield List.unmodifiable(_localChats[chatId]!);
    }

    _subscriptions[chatId]?.cancel();

    try {
      final initialData = await _supabase
          .from('messages')
          .select()
          .eq('chat_id', chatId)
          .order('timestamp', ascending: true);

      final fetchedMsgs = (initialData as List<dynamic>)
          .map((d) => ChatMessage.fromJson(d as Map<String, dynamic>))
          .toList();

      _localChats[chatId] = fetchedMsgs;
      _getController(chatId).add(List.unmodifiable(fetchedMsgs));
    } catch (_) {}

    try {
      final sub = _supabase
          .from('messages')
          .stream(primaryKey: ['id'])
          .eq('chat_id', chatId)
          .order('timestamp', ascending: true)
          .listen(
            (data) {
              final remoteMsgs =
                  data.map((d) => ChatMessage.fromJson(d)).toList();
              _localChats[chatId] = remoteMsgs;
              _getController(chatId).add(List.unmodifiable(remoteMsgs));
            },
            onError: (err) {
              debugPrint('Stream messages error: $err');
            },
          );

      _subscriptions[chatId] = sub;
    } catch (_) {}

    yield* _getController(chatId).stream;
  }

  @override
  Future<void> markAsRead(String targetUserId) async {
    final senderId = _currentUid;
    if (senderId.isEmpty) return;

    final chatId = _getChatId(senderId, targetUserId);
    final msgs = _localChats[chatId];
    if (msgs != null) {
      for (int i = 0; i < msgs.length; i++) {
        if (msgs[i].senderId == targetUserId && !msgs[i].isRead) {
          msgs[i] = ChatMessage(
            id: msgs[i].id,
            senderId: msgs[i].senderId,
            receiverId: msgs[i].receiverId,
            text: msgs[i].text,
            imageUrl: msgs[i].imageUrl,
            timestamp: msgs[i].timestamp,
            isRead: true,
          );
        }
      }
      _getController(chatId).add(List.unmodifiable(msgs));
    }

    _unreadCounts[targetUserId] = 0;
    _rebuildAndEmitConversations();

    try {
      await _supabase
          .from('messages')
          .update({'is_read': true})
          .eq('chat_id', chatId)
          .eq('sender_id', targetUserId);
    } catch (_) {}
  }
}
