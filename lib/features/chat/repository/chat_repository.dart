import 'dart:io';
import 'package:date_app/features/chat/models/chat_message.dart';
import 'package:date_app/features/chat/models/conversation_item.dart';
import 'package:date_app/features/global/models/user_model.dart';

abstract class ChatRepository {
  Future<void> sendMessage({
    required String targetUserId,
    required String text,
    String? imageUrl,
  });

  Future<String?> uploadChatImage(File imageFile);

  Stream<List<ChatMessage>> streamMessages(String targetUserId);

  Future<void> markAsRead(String targetUserId);

  Stream<List<ConversationItem>> streamConversations();

  Stream<ChatMessage> get onNewIncomingMessage;

  Future<UserModel?> getUserProfile(String uid);

  Future<void> refreshConversations();
}
