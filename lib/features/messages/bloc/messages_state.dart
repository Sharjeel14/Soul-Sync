import 'package:equatable/equatable.dart';
import 'package:date_app/features/chat/models/conversation_item.dart';
import 'package:date_app/features/global/models/user_model.dart';

enum MessagesStatus { initial, loading, loaded, error }

class MessagesState extends Equatable {
  final MessagesStatus status;
  final List<ConversationItem> conversations;
  final List<UserModel> recentMatches;
  final Set<String> onlineUserIds;
  final String? errorMessage;

  const MessagesState({
    this.status = MessagesStatus.initial,
    this.conversations = const [],
    this.recentMatches = const [],
    this.onlineUserIds = const {},
    this.errorMessage,
  });

  bool get isLoading => status == MessagesStatus.loading || status == MessagesStatus.initial;

  bool isUserOnline(String uid) => onlineUserIds.contains(uid);

  MessagesState copyWith({
    MessagesStatus? status,
    List<ConversationItem>? conversations,
    List<UserModel>? recentMatches,
    Set<String>? onlineUserIds,
    String? errorMessage,
  }) {
    return MessagesState(
      status: status ?? this.status,
      conversations: conversations ?? this.conversations,
      recentMatches: recentMatches ?? this.recentMatches,
      onlineUserIds: onlineUserIds ?? this.onlineUserIds,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        conversations,
        recentMatches,
        onlineUserIds,
        errorMessage,
      ];
}
