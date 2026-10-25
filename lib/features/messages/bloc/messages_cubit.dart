import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:date_app/core/services/presence_service.dart';
import 'package:date_app/features/chat/models/conversation_item.dart';
import 'package:date_app/features/chat/repository/chat_repository.dart';
import 'package:date_app/features/global/models/user_model.dart';
import 'package:date_app/features/matches/repository/match_repository.dart';
import 'package:date_app/features/profile/repository/block_repository.dart';
import 'messages_state.dart';

@injectable
class MessagesCubit extends Cubit<MessagesState> {
  final ChatRepository _chatRepository;
  final MatchRepository _matchRepository;
  final BlockRepository _blockRepository;

  StreamSubscription<List<ConversationItem>>? _conversationsSub;
  StreamSubscription<List<UserModel>>? _matchesSub;
  StreamSubscription<Set<String>>? _presenceSub;

  MessagesCubit(
    this._chatRepository,
    this._matchRepository,
    this._blockRepository,
  ) : super(const MessagesState()) {
    init();
  }

  void init() {
    emit(state.copyWith(status: MessagesStatus.loading));

    // Listen to conversations
    _conversationsSub?.cancel();
    _conversationsSub = _chatRepository.streamConversations().listen(
      (items) {
        final filtered = items
            .where((c) => !_blockRepository.isBlocked(c.user.uid))
            .toList();

        emit(state.copyWith(
          status: MessagesStatus.loaded,
          conversations: filtered,
        ));
      },
      onError: (err) {
        emit(state.copyWith(
          status: MessagesStatus.error,
          errorMessage: err.toString(),
        ));
      },
    );

    // Listen to matches for active top avatar row
    _matchesSub?.cancel();
    _matchesSub = _matchRepository.streamMatches().listen(
      (users) {
        final filtered = users
            .where((u) => !_blockRepository.isBlocked(u.uid))
            .toList();

        emit(state.copyWith(
          recentMatches: filtered,
        ));
      },
    );

    // Listen to presence
    _presenceSub?.cancel();
    _presenceSub = PresenceService().onlineUsersStream.listen(
      (onlineIds) {
        emit(state.copyWith(onlineUserIds: onlineIds));
      },
    );
  }

  @override
  Future<void> close() {
    _conversationsSub?.cancel();
    _matchesSub?.cancel();
    _presenceSub?.cancel();
    return super.close();
  }
}
