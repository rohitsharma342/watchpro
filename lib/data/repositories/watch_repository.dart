import '../models/watch_model.dart';
import '../../services/supabase_service.dart';

class WatchRepository {
  static Future<List<WatchModel>> fetchAllWatches() async {
    try {
      final data = await SupabaseService.fetchData('watches', orderBy: 'created_at', ascending: false);
      return data.map((json) => WatchModel.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching watches: $e');
      return [];
    }
  }
  
  static Future<List<WatchModel>> fetchTrendingWatches() async {
    try {
      final data = await SupabaseService.fetchData('watches');
      final watches = data.map((json) => WatchModel.fromJson(json)).toList();
      return watches.where((watch) => watch.isTrending).toList();
    } catch (e) {
      print('Error fetching trending watches: $e');
      return [];
    }
  }
  
  static Future<List<WatchModel>> fetchWatchesByCategory(String category) async {
    try {
      if (category == 'All') {
        return await fetchAllWatches();
      }
      
      final data = await SupabaseService.fetchData('watches');
      final watches = data.map((json) => WatchModel.fromJson(json)).toList();
      return watches.where((watch) => watch.category == category).toList();
    } catch (e) {
      print('Error fetching watches by category: $e');
      return [];
    }
  }
  
  static Future<List<WatchModel>> fetchUserWatches(String userId) async {
    try {
      final data = await SupabaseService.fetchUserWatches(userId);
      return data.map((json) => WatchModel.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching user watches: $e');
      return [];
    }
  }
  
  static Future<WatchModel?> fetchWatchById(String id) async {
    try {
      final data = await SupabaseService.fetchById('watches', id);
      if (data != null) {
        return WatchModel.fromJson(data);
      }
      return null;
    } catch (e) {
      print('Error fetching watch by id: $e');
      return null;
    }
  }
  
  static Future<void> addWatch(WatchModel watch) async {
    try {
      await SupabaseService.insertData('watches', watch.toJson());
    } catch (e) {
      print('Error adding watch: $e');
      rethrow;
    }
  }
  
  static Future<void> updateWatch(String id, WatchModel watch) async {
    try {
      await SupabaseService.updateData('watches', id, watch.toJson());
    } catch (e) {
      print('Error updating watch: $e');
      rethrow;
    }
  }
  
  static Future<void> deleteWatch(String id) async {
    try {
      await SupabaseService.deleteData('watches', id);
    } catch (e) {
      print('Error deleting watch: $e');
      rethrow;
    }
  }
  
  static Future<void> toggleSavedWatch(String userId, String watchId) async {
    try {
      // Check if already saved
      final existingSaved = await SupabaseService.fetchData('saved_watches');
      final isAlreadySaved = existingSaved.any((item) => 
        item['user_id'] == userId && item['watch_id'] == watchId);
      
      if (isAlreadySaved) {
        // Remove from saved
        final savedItem = existingSaved.firstWhere((item) => 
          item['user_id'] == userId && item['watch_id'] == watchId);
        await SupabaseService.deleteData('saved_watches', savedItem['id']);
      } else {
        // Add to saved
        await SupabaseService.insertData('saved_watches', {
          'user_id': userId,
          'watch_id': watchId,
        });
      }
    } catch (e) {
      print('Error toggling saved watch: $e');
      rethrow;
    }
  }
  
  static Future<List<String>> fetchSavedWatchIds(String userId) async {
    try {
      final data = await SupabaseService.fetchData('saved_watches');
      return data
          .where((item) => item['user_id'] == userId)
          .map((item) => item['watch_id'] as String)
          .toList();
    } catch (e) {
      print('Error fetching saved watch ids: $e');
      return [];
    }
  }
  
  static Future<List<WatchModel>> fetchSavedWatches(String userId) async {
    try {
      final data = await SupabaseService.fetchUserSavedWatches(userId);
      return data.map((item) => WatchModel.fromJson(item['watches'])).toList();
    } catch (e) {
      print('Error fetching saved watches: $e');
      return [];
    }
  }
}