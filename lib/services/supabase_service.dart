import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class SupabaseService {
  static final SupabaseClient _client = Supabase.instance.client;
  
  // Authentication methods
  static Future<AuthResponse?> signUp(String email, String password, String name) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {'name': name},
      );
      
      if (response.user != null) {
        await _saveUserToken(response.session?.accessToken);
        await _saveUserId(response.user!.id);
        
        // Create user profile in database
        await insertData('user_profiles', {
          'id': response.user!.id,
          'name': name,
          'email': email,
          'profile_image': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200',
          'phone': '',
          'location': '',
          'total_sales': 0,
          'rating': 0.0,
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        });
      }
      
      return response;
    } catch (e) {
      print('Error signing up: $e');
      rethrow;
    }
  }
  
  static Future<AuthResponse?> signIn(String email, String password) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      
      if (response.user != null) {
        await _saveUserToken(response.session?.accessToken);
        await _saveUserId(response.user!.id);
      }
      
      return response;
    } catch (e) {
      print('Error signing in: $e');
      rethrow;
    }
  }
  
  static Future<void> signOut() async {
    try {
      await _client.auth.signOut();
      await _clearUserData();
    } catch (e) {
      print('Error signing out: $e');
      rethrow;
    }
  }
  
  static User? getCurrentUser() {
    return _client.auth.currentUser;
  }
  
  static Stream<AuthState> authStateChanges() {
    return _client.auth.onAuthStateChange;
  }
  
  // Database CRUD operations
  static Future<List<Map<String, dynamic>>> fetchData(String table, {String? orderBy, bool ascending = true}) async {
    try {
      var query = _client.from(table).select();
      
      if (orderBy != null) {
        query = query.order(orderBy, ascending: ascending);
      }
      
      final response = await query;
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching data from $table: $e');
      rethrow;
    }
  }
  
  static Future<Map<String, dynamic>?> fetchById(String table, String id) async {
    try {
      final response = await _client
          .from(table)
          .select()
          .eq('id', id)
          .single();
      return response;
    } catch (e) {
      print('Error fetching $table by id $id: $e');
      return null;
    }
  }
  
  static Future<void> insertData(String table, Map<String, dynamic> data) async {
    try {
      data['created_at'] = DateTime.now().toIso8601String();
      data['updated_at'] = DateTime.now().toIso8601String();
      
      await _client.from(table).insert(data);
    } catch (e) {
      print('Error inserting data into $table: $e');
      rethrow;
    }
  }
  
  static Future<void> updateData(String table, String id, Map<String, dynamic> data) async {
    try {
      data['updated_at'] = DateTime.now().toIso8601String();
      
      await _client
          .from(table)
          .update(data)
          .eq('id', id);
    } catch (e) {
      print('Error updating data in $table: $e');
      rethrow;
    }
  }
  
  static Future<void> deleteData(String table, String id) async {
    try {
      await _client
          .from(table)
          .delete()
          .eq('id', id);
    } catch (e) {
      print('Error deleting data from $table: $e');
      rethrow;
    }
  }
  
  // Storage operations
  static Future<String> uploadFile(String bucket, String path, File file) async {
    try {
      await _client.storage.from(bucket).upload(path, file);
      return _client.storage.from(bucket).getPublicUrl(path);
    } catch (e) {
      print('Error uploading file: $e');
      rethrow;
    }
  }
  
  static Future<void> deleteFile(String bucket, String path) async {
    try {
      await _client.storage.from(bucket).remove([path]);
    } catch (e) {
      print('Error deleting file: $e');
      rethrow;
    }
  }
  
  // User-specific queries
  static Future<List<Map<String, dynamic>>> fetchUserWatches(String userId) async {
    try {
      final response = await _client
          .from('watches')
          .select()
          .eq('seller_id', userId)
          .order('created_at', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching user watches: $e');
      rethrow;
    }
  }
  
  static Future<List<Map<String, dynamic>>> fetchUserSavedWatches(String userId) async {
    try {
      final response = await _client
          .from('saved_watches')
          .select('*, watches(*)')
          .eq('user_id', userId);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching saved watches: $e');
      rethrow;
    }
  }
  
  static Future<List<Map<String, dynamic>>> fetchUserOrders(String userId) async {
    try {
      final response = await _client
          .from('orders')
          .select('*, watches(*)')
          .eq('buyer_id', userId)
          .order('created_at', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching user orders: $e');
      rethrow;
    }
  }
  
  static Future<List<Map<String, dynamic>>> fetchConversations(String userId) async {
    try {
      final response = await _client
          .from('conversations')
          .select('*, messages(content, created_at), watches(title)')
          .or('buyer_id.eq.$userId,seller_id.eq.$userId')
          .order('updated_at', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching conversations: $e');
      rethrow;
    }
  }
  
  static Future<List<Map<String, dynamic>>> fetchMessages(String conversationId) async {
    try {
      final response = await _client
          .from('messages')
          .select()
          .eq('conversation_id', conversationId)
          .order('created_at', ascending: true);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching messages: $e');
      rethrow;
    }
  }
  
  // Helper methods for local storage
  static Future<void> _saveUserToken(String? token) async {
    if (token != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_token', token);
    }
  }
  
  static Future<void> _saveUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', userId);
  }
  
  static Future<String?> getUserToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_token');
  }
  
  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }
  
  static Future<void> _clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_token');
    await prefs.remove('user_id');
  }
}