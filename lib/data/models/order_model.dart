enum OrderStatus { pending, confirmed, shipped, delivered, cancelled }

class OrderModel {
  final String id;
  final String watchId;
  final String watchTitle;
  final String watchImage;
  final String buyerId;
  final String sellerId;
  final String sellerName;
  final double price;
  final DateTime orderDate;
  final OrderStatus status;
  final String shippingAddress;

  OrderModel({
    required this.id,
    required this.watchId,
    required this.watchTitle,
    required this.watchImage,
    required this.buyerId,
    required this.sellerId,
    required this.sellerName,
    required this.price,
    required this.orderDate,
    required this.status,
    required this.shippingAddress,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String,
      watchId: json['watch_id'] as String,
      watchTitle: json['watch_title'] as String,
      watchImage: json['watch_image'] as String,
      buyerId: json['buyer_id'] as String,
      sellerId: json['seller_id'] as String,
      sellerName: json['seller_name'] as String,
      price: (json['price'] as num).toDouble(),
      orderDate: DateTime.parse(json['order_date'] as String),
      status: OrderStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => OrderStatus.pending,
      ),
      shippingAddress: json['shipping_address'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'watch_id': watchId,
      'watch_title': watchTitle,
      'watch_image': watchImage,
      'buyer_id': buyerId,
      'seller_id': sellerId,
      'seller_name': sellerName,
      'price': price,
      'order_date': orderDate.toIso8601String(),
      'status': status.toString().split('.').last,
      'shipping_address': shippingAddress,
    };
  }

  String get statusText {
    switch (status) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }
}