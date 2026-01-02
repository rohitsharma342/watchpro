import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_service.dart';

class AuthService {
  static Future<AuthResponse?> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      return await SupabaseService.signUp(email, password, name);
    } catch (e) {
      print('AuthService signUp error: $e');
      rethrow;
    }
  }
  
  static Future<AuthResponse?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return await SupabaseService.signIn(email, password);
    } catch (e) {
      print('AuthService signIn error: $e');
      rethrow;
    }
  }
  
  static Future<void> signOut() async {
    try {
      await SupabaseService.signOut();
    } catch (e) {
      print('AuthService signOut error: $e');
      rethrow;
    }
  }
  
  static User? getCurrentUser() {
    return SupabaseService.getCurrentUser();
  }
  
  static Stream<AuthState> authStateChanges() {
    return SupabaseService.authStateChanges();
  }
  
  static bool isLoggedIn() {
    return getCurrentUser() != null;
  }
}