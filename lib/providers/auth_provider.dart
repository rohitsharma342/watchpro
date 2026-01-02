import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_service.dart';

class AuthProvider extends ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  String _error = '';
  bool _isLoggedIn = false;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String get error => _error;
  bool get isLoggedIn => _isLoggedIn;

  AuthProvider() {
    _initializeAuth();
  }

  void _initializeAuth() {
    _currentUser = SupabaseService.getCurrentUser();
    _isLoggedIn = _currentUser != null;
    
    // Listen to auth state changes
    SupabaseService.authStateChanges().listen((AuthState data) {
      _currentUser = data.session?.user;
      _isLoggedIn = _currentUser != null;
      notifyListeners();
    });
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

      final response = await SupabaseService.signUp(email, password, name);
      
      if (response?.user != null) {
        _currentUser = response!.user;
        _isLoggedIn = true;
        return true;
      }
      
      return false;
    } catch (e) {
      _error = _getErrorMessage(e.toString());
      print('SignUp error: $e');
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

      final response = await SupabaseService.signIn(email, password);
      
      if (response?.user != null) {
        _currentUser = response!.user;
        _isLoggedIn = true;
        return true;
      }
      
      return false;
    } catch (e) {
      _error = _getErrorMessage(e.toString());
      print('SignIn error: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    try {
      _isLoading = true;
      _error = '';
      notifyListeners();

      await SupabaseService.signOut();
      
      _currentUser = null;
      _isLoggedIn = false;
    } catch (e) {
      _error = _getErrorMessage(e.toString());
      print('SignOut error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
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
    } else if (error.contains('Network request failed')) {
      return 'Network error. Please check your connection';
    } else {
      return 'An error occurred. Please try again';
    }
  }

  void clearError() {
    _error = '';
    notifyListeners();
  }
}