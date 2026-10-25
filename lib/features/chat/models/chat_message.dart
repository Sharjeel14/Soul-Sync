class ChatMessage {
  final String id;
  final String senderId;
  final String receiverId;
  final String text;
  final String? imageUrl;
  final DateTime timestamp;
  final bool isRead;

  const ChatMessage({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.text,
    this.imageUrl,
    required this.timestamp,
    this.isRead = false,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json, [String? id]) {
    DateTime parsedTime = DateTime.now();
    if (json['timestamp'] != null) {
      if (json['timestamp'] is DateTime) {
        parsedTime = json['timestamp'] as DateTime;
      } else if (json['timestamp'] is int) {
        parsedTime = DateTime.fromMillisecondsSinceEpoch(json['timestamp'] as int);
      } else {
        parsedTime = DateTime.tryParse(json['timestamp'].toString()) ?? DateTime.now();
      }
    }

    final rawImage = json['image_url'] ?? json['imageUrl'];

    return ChatMessage(
      id: id ?? (json['id'] ?? '').toString(),
      senderId: (json['senderId'] ?? json['sender_id'] ?? '').toString(),
      receiverId: (json['receiverId'] ?? json['receiver_id'] ?? '').toString(),
      text: (json['text'] ?? json['message'] ?? '').toString(),
      imageUrl: (rawImage != null && rawImage.toString().trim().isNotEmpty)
          ? rawImage.toString().trim()
          : null,
      timestamp: parsedTime,
      isRead: json['isRead'] == true || json['is_read'] == true,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'senderId': senderId,
    'receiverId': receiverId,
    'sender_id': senderId,
    'receiver_id': receiverId,
    'text': text,
    'image_url': imageUrl,
    'imageUrl': imageUrl,
    'timestamp': timestamp.toIso8601String(),
    'isRead': isRead,
    'is_read': isRead,
  };
}
