import 'package:date_app/features/chat/models/chat_message.dart';
import 'package:date_app/features/global/models/user_model.dart';

class ConversationItem {
  final UserModel user;
  final ChatMessage? lastMessage;
  final int unreadCount;
  final DateTime lastActivity;

  const ConversationItem({
    required this.user,
    this.lastMessage,
    this.unreadCount = 0,
    required this.lastActivity,
  });

  ConversationItem copyWith({
    UserModel? user,
    ChatMessage? lastMessage,
    int? unreadCount,
    DateTime? lastActivity,
  }) {
    return ConversationItem(
      user: user ?? this.user,
      lastMessage: lastMessage ?? this.lastMessage,
      unreadCount: unreadCount ?? this.unreadCount,
      lastActivity: lastActivity ?? this.lastActivity,
    );
  }
}
