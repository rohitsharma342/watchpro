import 'package:flutter/foundation.dart';
import '../data/models/message_model.dart';
import '../data/repositories/static_data.dart';

class MessageProvider extends ChangeNotifier {
  List<ConversationModel> _conversations = [];
  Map<String, List<MessageModel>> _messages = {};
  bool _isLoading = false;

  List<ConversationModel> get conversations => _conversations;
  bool get isLoading => _isLoading;

  int get totalUnreadCount =>
      _conversations.fold(0, (sum, c) => sum + c.unreadCount);

  MessageProvider() {
    loadConversations();
  }

  Future<void> loadConversations() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 300));

    _conversations = StaticData.conversations;

    _isLoading = false;
    notifyListeners();
  }

  List<MessageModel> getMessages(String participantId) {
    if (!_messages.containsKey(participantId)) {
      _messages[participantId] =
          StaticData.getMessagesForConversation(participantId);
    }
    return _messages[participantId] ?? [];
  }

  void sendMessage(String participantId, String content) {
    if (content.trim().isEmpty) return;

    final newMessage = MessageModel(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      senderId: 'user_001',
      receiverId: participantId,
      content: content.trim(),
      timestamp: DateTime.now(),
      isRead: true,
    );

    if (!_messages.containsKey(participantId)) {
      _messages[participantId] = [];
    }
    _messages[participantId]!.add(newMessage);

    final convIndex =
        _conversations.indexWhere((c) => c.participantId == participantId);
    if (convIndex != -1) {
      final conv = _conversations[convIndex];
      _conversations[convIndex] = ConversationModel(
        id: conv.id,
        participantId: conv.participantId,
        participantName: conv.participantName,
        participantImage: conv.participantImage,
        lastMessage: content.trim(),
        lastMessageTime: DateTime.now(),
        unreadCount: 0,
        watchTitle: conv.watchTitle,
      );
    }

    notifyListeners();
  }

  void markAsRead(String participantId) {
    final convIndex =
        _conversations.indexWhere((c) => c.participantId == participantId);
    if (convIndex != -1) {
      final conv = _conversations[convIndex];
      _conversations[convIndex] = ConversationModel(
        id: conv.id,
        participantId: conv.participantId,
        participantName: conv.participantName,
        participantImage: conv.participantImage,
        lastMessage: conv.lastMessage,
        lastMessageTime: conv.lastMessageTime,
        unreadCount: 0,
        watchTitle: conv.watchTitle,
      );
      notifyListeners();
    }
  }

  void startNewConversation({
    required String sellerId,
    required String sellerName,
    required String sellerImage,
    required String watchTitle,
  }) {
    final existingIndex =
        _conversations.indexWhere((c) => c.participantId == sellerId);
    if (existingIndex == -1) {
      _conversations.insert(
        0,
        ConversationModel(
          id: 'conv_${DateTime.now().millisecondsSinceEpoch}',
          participantId: sellerId,
          participantName: sellerName,
          participantImage: sellerImage,
          lastMessage: '',
          lastMessageTime: DateTime.now(),
          unreadCount: 0,
          watchTitle: watchTitle,
        ),
      );
      notifyListeners();
    }
  }
}
