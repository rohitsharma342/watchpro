class MessageModel {
  final String id;
  final String senderId;
  final String receiverId;
  final String conversationId;
  final String content;
  final DateTime timestamp;
  final bool isRead;

  MessageModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.conversationId,
    required this.content,
    required this.timestamp,
    this.isRead = false,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as String,
      senderId: json['sender_id'] as String,
      receiverId: json['receiver_id'] as String,
      conversationId: json['conversation_id'] as String,
      content: json['content'] as String,
      timestamp: DateTime.parse(json['created_at'] as String),
      isRead: json['is_read'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'conversation_id': conversationId,
      'content': content,
      'is_read': isRead,
    };
  }

  MessageModel copyWith({
    String? id,
    String? senderId,
    String? receiverId,
    String? conversationId,
    String? content,
    DateTime? timestamp,
    bool? isRead,
  }) {
    return MessageModel(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      conversationId: conversationId ?? this.conversationId,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
    );
  }
}

class ConversationModel {
  final String id;
  final String buyerId;
  final String sellerId;
  final String watchId;
  final String watchTitle;
  final String participantId;
  final String participantName;
  final String participantImage;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;

  ConversationModel({
    required this.id,
    required this.buyerId,
    required this.sellerId,
    required this.watchId,
    required this.watchTitle,
    required this.participantId,
    required this.participantName,
    required this.participantImage,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['id'] as String,
      buyerId: json['buyer_id'] as String,
      sellerId: json['seller_id'] as String,
      watchId: json['watch_id'] as String,
      watchTitle: json['watch_title'] as String,
      participantId: json['participant_id'] as String? ?? '',
      participantName: json['participant_name'] as String? ?? '',
      participantImage: json['participant_image'] as String? ?? '',
      lastMessage: json['last_message'] as String? ?? '',
      lastMessageTime: DateTime.parse(json['last_message_time'] as String),
      unreadCount: json['unread_count'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'buyer_id': buyerId,
      'seller_id': sellerId,
      'watch_id': watchId,
      'watch_title': watchTitle,
      'participant_id': participantId,
      'participant_name': participantName,
      'participant_image': participantImage,
      'last_message': lastMessage,
      'last_message_time': lastMessageTime.toIso8601String(),
      'unread_count': unreadCount,
    };
  }
}