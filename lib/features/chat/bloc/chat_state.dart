import 'package:equatable/equatable.dart';
import 'package:date_app/features/chat/models/chat_message.dart';

class ChatState extends Equatable {
  final List<ChatMessage> messages;
  final bool isLoading;
  final bool isOnline;
  final bool isUploadingImage;
  final bool isBlocked;
  final String? error;

  const ChatState({
    this.messages = const [],
    this.isLoading = true,
    this.isOnline = false,
    this.isUploadingImage = false,
    this.isBlocked = false,
    this.error,
  });

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
    bool? isOnline,
    bool? isUploadingImage,
    bool? isBlocked,
    String? error,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      isOnline: isOnline ?? this.isOnline,
      isUploadingImage: isUploadingImage ?? this.isUploadingImage,
      isBlocked: isBlocked ?? this.isBlocked,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        messages,
        isLoading,
        isOnline,
        isUploadingImage,
        isBlocked,
        error,
      ];
}
