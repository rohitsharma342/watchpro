import '../models/user_model.dart';
import '../../services/supabase_service.dart';

class UserRepository {
  static Future<UserModel?> fetchUserProfile(String userId) async {
    try {
      final data = await SupabaseService.fetchById('user_profiles', userId);
      if (data != null) {
        return UserModel.fromJson(data);
      }
      return null;
    } catch (e) {
      print('Error fetching user profile: $e');
      return null;
    }
  }
  
  static Future<void> updateUserProfile(String userId, UserModel user) async {
    try {
      await SupabaseService.updateData('user_profiles', userId, user.toJson());
    } catch (e) {
      print('Error updating user profile: $e');
      rethrow;
    }
  }
  
  static Future<void> createUserProfile(UserModel user) async {
    try {
      await SupabaseService.insertData('user_profiles', user.toJson());
    } catch (e) {
      print('Error creating user profile: $e');
      rethrow;
    }
  }
  
  static Future<void> deleteUserProfile(String userId) async {
    try {
      await SupabaseService.deleteData('user_profiles', userId);
    } catch (e) {
      print('Error deleting user profile: $e');
      rethrow;
    }
  }
}