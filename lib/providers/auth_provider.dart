import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/auth_service.dart';
import '../data/models/user_model.dart';
import '../data/repositories/user_repository.dart';

class AuthProvider extends ChangeNotifier {
  User? _currentUser;
  UserModel? _userProfile;
  bool _isLoading = false;
  String _error = '';
  bool _isLoggedIn = false;

  User? get currentUser => _currentUser;
  UserModel? get userProfile => _userProfile;
  bool get isLoading => _isLoading;
  String get error => _error;
  bool get isLoggedIn => _isLoggedIn;

  AuthProvider() {
    _initializeAuth();
  }

  void _initializeAuth() {
    _currentUser = AuthService.getCurrentUser();
    _isLoggedIn = _currentUser != null;
    
    if (_isLoggedIn && _currentUser != null) {
      _loadUserProfile(_currentUser!.id);
    }
    
    // Listen to auth state changes
    AuthService.authStateChanges().listen((AuthState data) {
      _currentUser = data.session?.user;
      _isLoggedIn = _currentUser != null;
      
      if (_isLoggedIn && _currentUser != null) {
        _loadUserProfile(_currentUser!.id);
      } else {
        _userProfile = null;
      }
      
      notifyListeners();
    });
  }

  Future<void> _loadUserProfile(String userId) async {
    try {
      _userProfile = await UserRepository.fetchUserProfile(userId);
      notifyListeners();
    } catch (e) {
      print('Error loading user profile: $e');
    }
  }

  Future<bool> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      _isLoading = true;
      _error = '';
      notifyListeners();

      final response = await AuthService.signUp(
        email: email,
        password: password,
        name: name,
      );

      if (response?.user != null) {
        _currentUser = response!.user;
        _isLoggedIn = true;
        await _loadUserProfile(_currentUser!.id);
        return true;
      }
      
      return false;
    } catch (e) {
      _error = _getErrorMessage(e.toString());
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    try {
      _isLoading = true;
      _error = '';
      notifyListeners();

      final response = await AuthService.signIn(
        email: email,
        password: password,
      );

      if (response?.user != null) {
        _currentUser = response!.user;
        _isLoggedIn = true;
        await _loadUserProfile(_currentUser!.id);
        return true;
      }
      
      return false;
    } catch (e) {
      _error = _getErrorMessage(e.toString());
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    try {
      _isLoading = true;
      notifyListeners();

      await AuthService.signOut();
      
      _currentUser = null;
      _userProfile = null;
      _isLoggedIn = false;
      _error = '';
    } catch (e) {
      _error = _getErrorMessage(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProfile({
    String? name,
    String? phone,
    String? location,
  }) async {
    if (_userProfile == null || _currentUser == null) return;

    try {
      _isLoading = true;
      _error = '';
      notifyListeners();

      final updatedProfile = _userProfile!.copyWith(
        name: name ?? _userProfile!.name,
        phone: phone ?? _userProfile!.phone,
        location: location ?? _userProfile!.location,
      );

      await UserRepository.updateUserProfile(_currentUser!.id, updatedProfile);
      _userProfile = updatedProfile;
    } catch (e) {
      _error = _getErrorMessage(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = '';
    notifyListeners();
  }

  String _getErrorMessage(String error) {
    if (error.contains('Invalid login credentials')) {
      return 'Invalid email or password';
    } else if (error.contains('User already registered')) {
      return 'An account with this email already exists';
    } else if (error.contains('Password should be at least 6 characters')) {
      return 'Password must be at least 6 characters long';
    } else if (error.contains('Unable to validate email address')) {
      return 'Please enter a valid email address';
    } else if (error.contains('Network')) {
      return 'Network error. Please check your connection';
    } else {
      return 'An error occurred. Please try again';
    }
  }
}