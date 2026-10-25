import 'dart:async';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:date_app/core/services/presence_service.dart';
import 'package:date_app/core/utils/chat_filter_helper.dart';
import 'package:date_app/features/chat/models/chat_message.dart';
import 'package:date_app/features/chat/repository/chat_repository.dart';
import 'package:date_app/features/profile/repository/block_repository.dart';
import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository chatRepository;
  final BlockRepository blockRepository;
  final PresenceService presenceService;
  final String targetUserId;

  StreamSubscription<List<ChatMessage>>? _messageSubscription;
  StreamSubscription<bool>? _presenceSubscription;

  ChatCubit({
    required this.chatRepository,
    required this.blockRepository,
    PresenceService? presenceService,
    required this.targetUserId,
  })  : presenceService = presenceService ?? PresenceService(),
        super(ChatState(
          isOnline: (presenceService ?? PresenceService()).isUserOnline(targetUserId),
          isBlocked: blockRepository.isBlocked(targetUserId),
        )) {
    _init();
  }

  void _init() {
    // 1. Check blocked status
    emit(state.copyWith(
      isBlocked: blockRepository.isBlocked(targetUserId),
      isOnline: presenceService.isUserOnline(targetUserId),
    ));

    // 2. Stream Realtime Presence
    _presenceSubscription = presenceService
        .streamUserOnlineStatus(targetUserId)
        .listen((isOnline) {
      emit(state.copyWith(isOnline: isOnline));
    });

    presenceService.checkUserStatus(targetUserId).then((isOnline) {
      if (!isClosed) {
        emit(state.copyWith(isOnline: isOnline));
      }
    });

    // 3. Stream Realtime Messages
    _messageSubscription = chatRepository.streamMessages(targetUserId).listen(
      (messages) {
        emit(state.copyWith(
          messages: messages,
          isLoading: false,
        ));

        final hasUnread = messages.any(
          (m) => m.senderId == targetUserId && !m.isRead,
        );
        if (hasUnread) {
          chatRepository.markAsRead(targetUserId);
        }
      },
      onError: (err) {
        emit(state.copyWith(isLoading: false, error: err.toString()));
      },
    );

    // 4. Mark read
    chatRepository.markAsRead(targetUserId);
  }

  Future<void> sendMessage(String text) async {
    final clean = text.trim();
    if (clean.isEmpty ||
        state.isBlocked ||
        ChatFilterHelper.containsRestrictedContactInfo(clean)) {
      return;
    }

    await chatRepository.sendMessage(
      targetUserId: targetUserId,
      text: clean,
    );
  }

  Future<void> sendImageMessage(File imageFile, [String? text]) async {
    if (state.isBlocked) return;

    final cleanText = text?.trim();
    final safeText = (cleanText != null &&
            cleanText.isNotEmpty &&
            !ChatFilterHelper.containsRestrictedContactInfo(cleanText))
        ? cleanText
        : null;

    emit(state.copyWith(isUploadingImage: true));
    try {
      final imageUrl = await chatRepository.uploadChatImage(imageFile);
      if (imageUrl != null) {
        await chatRepository.sendMessage(
          targetUserId: targetUserId,
          text: safeText ?? '📷 Photo',
          imageUrl: imageUrl,
        );
      }
    } finally {
      emit(state.copyWith(isUploadingImage: false));
    }
  }

  Future<void> blockUser() async {
    await blockRepository.blockUser(targetUserId);
    emit(state.copyWith(isBlocked: true));
  }

  Future<void> unblockUser() async {
    await blockRepository.unblockUser(targetUserId);
    emit(state.copyWith(isBlocked: false));
  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    _presenceSubscription?.cancel();
    return super.close();
  }
}
