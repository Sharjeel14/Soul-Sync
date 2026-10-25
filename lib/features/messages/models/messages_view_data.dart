import 'package:equatable/equatable.dart';
import 'package:date_app/features/chat/models/conversation_item.dart';
import 'package:date_app/features/global/models/user_model.dart';

class MessagesViewData extends Equatable {
  final List<ConversationItem> conversations;
  final List<UserModel> recentMatches;
  final Set<String> onlineUserIds;

  const MessagesViewData({
    this.conversations = const [],
    this.recentMatches = const [],
    this.onlineUserIds = const {},
  });

  bool isUserOnline(String uid) => onlineUserIds.contains(uid);

  @override
  List<Object?> get props => [conversations, recentMatches, onlineUserIds];
}
