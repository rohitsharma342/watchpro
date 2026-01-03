import 'package:flutter/material.dart';
import '../models/watch_model.dart';
import '../models/user_model.dart';
import '../models/message_model.dart';
import '../models/order_model.dart';
import '../data/static_data.dart';

class AppController extends ChangeNotifier {
  bool _isLoggedIn = true;
  UserModel _currentUser = StaticData.currentUser;
  List<WatchModel> _allWatches = StaticData.allWatches;
  List<WatchModel> _userListings = StaticData.userListings;
  List<ConversationModel> _conversations = StaticData.conversations;
  List<OrderModel> _orders = StaticData.orders;
  int _selectedNavIndex = 0;
  String _selectedCategory = 'All';
  String _searchQuery = '';
  int _notificationCount = 3;

  bool get isLoggedIn => _isLoggedIn;
  UserModel get currentUser => _currentUser;
  List<WatchModel> get allWatches => _allWatches;
  List<WatchModel> get userListings => _userListings;
  List<ConversationModel> get conversations => _conversations;
  List<OrderModel> get orders => _orders;
  int get selectedNavIndex => _selectedNavIndex;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  int get notificationCount => _notificationCount;

  List<WatchModel> get trendingWatches =>
      _allWatches.where((w) => w.isTrending).toList();

  List<WatchModel> get savedWatches =>
      _allWatches.where((w) => w.isSaved).toList();

  List<WatchModel> get filteredWatches {
    List<WatchModel> result = _allWatches;

    if (_selectedCategory != 'All') {
      result = result.where((w) => w.brand == _selectedCategory).toList();
    }

    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      result = result.where((w) {
        return w.name.toLowerCase().contains(query) ||
            w.brand.toLowerCase().contains(query) ||
            w.description.toLowerCase().contains(query);
      }).toList();
    }

    return result;
  }

  void setNavIndex(int index) {
    _selectedNavIndex = index;
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query.replaceAll(RegExp(r'[^a-zA-Z0-9\s]'), '');
    notifyListeners();
  }

  void toggleSaved(String watchId) {
    final index = _allWatches.indexWhere((w) => w.id == watchId);
    if (index != -1) {
      _allWatches[index] = _allWatches[index].copyWith(
        isSaved: !_allWatches[index].isSaved,
      );
      notifyListeners();
    }
  }

  void sendMessage(String conversationId, String content) {
    if (content.trim().isEmpty) return;

    final convIndex = _conversations.indexWhere((c) => c.id == conversationId);
    if (convIndex != -1) {
      final newMessage = MessageModel(
        id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
        senderId: _currentUser.id,
        receiverId: _conversations[convIndex].otherUserId,
        content: content.trim(),
        timestamp: DateTime.now(),
      );

      final updatedMessages = [..._conversations[convIndex].messages, newMessage];
      _conversations[convIndex] = ConversationModel(
        id: _conversations[convIndex].id,
        otherUserId: _conversations[convIndex].otherUserId,
        otherUserName: _conversations[convIndex].otherUserName,
        otherUserAvatar: _conversations[convIndex].otherUserAvatar,
        watchId: _conversations[convIndex].watchId,
        watchName: _conversations[convIndex].watchName,
        messages: updatedMessages,
        lastMessageTime: DateTime.now(),
      );
      notifyListeners();
    }
  }

  ConversationModel? getOrCreateConversation(String sellerId, String sellerName, String sellerAvatar, String watchId, String watchName) {
    final existing = _conversations.where(
      (c) => c.otherUserId == sellerId && c.watchId == watchId,
    ).toList();

    if (existing.isNotEmpty) {
      return existing.first;
    }

    final newConv = ConversationModel(
      id: 'conv_${DateTime.now().millisecondsSinceEpoch}',
      otherUserId: sellerId,
      otherUserName: sellerName,
      otherUserAvatar: sellerAvatar,
      watchId: watchId,
      watchName: watchName,
      messages: [],
      lastMessageTime: DateTime.now(),
    );
    _conversations.add(newConv);
    notifyListeners();
    return newConv;
  }

  void updateProfile(String name, String email, String phone) {
    _currentUser = _currentUser.copyWith(
      name: name,
      email: email,
      phone: phone,
    );
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }

  void login() {
    _isLoggedIn = true;
    notifyListeners();
  }

  void clearNotifications() {
    _notificationCount = 0;
    notifyListeners();
  }
}