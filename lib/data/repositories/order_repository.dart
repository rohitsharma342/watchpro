import '../models/order_model.dart';
import '../../services/supabase_service.dart';

class OrderRepository {
  static Future<List<OrderModel>> fetchUserOrders(String userId) async {
    try {
      final data = await SupabaseService.fetchUserOrders(userId);
      return data.map((json) => OrderModel.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching user orders: $e');
      return [];
    }
  }
  
  static Future<OrderModel?> fetchOrderById(String orderId) async {
    try {
      final data = await SupabaseService.fetchById('orders', orderId);
      if (data != null) {
        return OrderModel.fromJson(data);
      }
      return null;
    } catch (e) {
      print('Error fetching order by id: $e');
      return null;
    }
  }
  
  static Future<void> createOrder(OrderModel order) async {
    try {
      await SupabaseService.insertData('orders', order.toJson());
    } catch (e) {
      print('Error creating order: $e');
      rethrow;
    }
  }
  
  static Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    try {
      await SupabaseService.updateData('orders', orderId, {
        'status': status.toString().split('.').last,
      });
    } catch (e) {
      print('Error updating order status: $e');
      rethrow;
    }
  }
  
  static Future<void> cancelOrder(String orderId) async {
    try {
      await updateOrderStatus(orderId, OrderStatus.cancelled);
    } catch (e) {
      print('Error cancelling order: $e');
      rethrow;
    }
  }
  
  static Future<List<OrderModel>> fetchSellerOrders(String sellerId) async {
    try {
      final data = await SupabaseService.fetchData('orders');
      final orders = data.map((json) => OrderModel.fromJson(json)).toList();
      return orders.where((order) => order.sellerId == sellerId).toList();
    } catch (e) {
      print('Error fetching seller orders: $e');
      return [];
    }
  }
}