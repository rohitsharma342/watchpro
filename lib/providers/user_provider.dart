import 'package:flutter/foundation.dart';
import '../data/models/user_model.dart';
import '../data/models/order_model.dart';
import '../data/repositories/static_data.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _currentUser;
  List<OrderModel> _orders = [];
  bool _isLoggedIn = true;
  bool _isLoading = false;

  UserModel? get currentUser => _currentUser;
  List<OrderModel> get orders => _orders;
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;

  UserProvider() {
    loadUser();
  }

  Future<void> loadUser() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 300));

    _currentUser = StaticData.currentUser;
    _orders = StaticData.orders;
    _isLoggedIn = true;

    _isLoading = false;
    notifyListeners();
  }

  void updateProfile({
    String? name,
    String? email,
    String? phone,
    String? location,
  }) {
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(
        name: name ?? _currentUser!.name,
        email: email ?? _currentUser!.email,
        phone: phone ?? _currentUser!.phone,
        location: location ?? _currentUser!.location,
      );
      notifyListeners();
    }
  }

  void logout() {
    _currentUser = null;
    _orders = [];
    _isLoggedIn = false;
    notifyListeners();
  }

  void login() {
    loadUser();
  }
}
