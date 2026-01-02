import '../models/message_model.dart';
import '../../services/supabase_service.dart';

class MessageRepository {
  static Future<List<ConversationModel>> fetchConversations(String userId) async {
    try {
      final data = await SupabaseService.fetchConversations(userId);
      return data.map((json) => ConversationModel.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching conversations: $e');
      return [];
    }
  }
  
  static Future<List<MessageModel>> fetchMessages(String conversationId) async {
    try {
      final data = await SupabaseService.fetchMessages(conversationId);
      return data.map((json) => MessageModel.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching messages: $e');
      return [];
    }
  }
  
  static Future<void> sendMessage(MessageModel message) async {
    try {
      await SupabaseService.insertData('messages', message.toJson());
      
      // Update conversation's last message and timestamp
      await SupabaseService.updateData('conversations', message.conversationId, {
        'last_message': message.content,
        'last_message_time': message.timestamp.toIso8601String(),
      });
    } catch (e) {
      print('Error sending message: $e');
      rethrow;
    }
  }
  
  static Future<String> createConversation({
    required String buyerId,
    required String sellerId,
    required String watchId,
    required String watchTitle,
  }) async {
    try {
      // Check if conversation already exists
      final existingConversations = await SupabaseService.fetchData('conversations');
      final existing = existingConversations.where((conv) => 
        conv['buyer_id'] == buyerId && 
        conv['seller_id'] == sellerId && 
        conv['watch_id'] == watchId).toList();
      
      if (existing.isNotEmpty) {
        return existing.first['id'];
      }
      
      // Create new conversation
      final conversationData = {
        'buyer_id': buyerId,
        'seller_id': sellerId,
        'watch_id': watchId,
        'watch_title': watchTitle,
        'last_message': '',
        'last_message_time': DateTime.now().toIso8601String(),
        'unread_count': 0,
      };
      
      await SupabaseService.insertData('conversations', conversationData);
      
      // Fetch the created conversation to get its ID
      final newConversations = await SupabaseService.fetchData('conversations');
      final newConv = newConversations.where((conv) => 
        conv['buyer_id'] == buyerId && 
        conv['seller_id'] == sellerId && 
        conv['watch_id'] == watchId).first;
      
      return newConv['id'];
    } catch (e) {
      print('Error creating conversation: $e');
      rethrow;
    }
  }
  
  static Future<void> markConversationAsRead(String conversationId) async {
    try {
      await SupabaseService.updateData('conversations', conversationId, {
        'unread_count': 0,
      });
    } catch (e) {
      print('Error marking conversation as read: $e');
      rethrow;
    }
  }
  
  static Future<void> incrementUnreadCount(String conversationId) async {
    try {
      final conversation = await SupabaseService.fetchById('conversations', conversationId);
      if (conversation != null) {
        final currentCount = conversation['unread_count'] ?? 0;
        await SupabaseService.updateData('conversations', conversationId, {
          'unread_count': currentCount + 1,
        });
      }
    } catch (e) {
      print('Error incrementing unread count: $e');
      rethrow;
    }
  }
}