enum OrderStatus { pending, confirmed, shipped, delivered, cancelled }

class OrderModel {
  final String id;
  final String watchId;
  final String watchName;
  final String watchImage;
  final double price;
  final String sellerId;
  final String sellerName;
  final DateTime orderDate;
  final OrderStatus status;

  OrderModel({
    required this.id,
    required this.watchId,
    required this.watchName,
    required this.watchImage,
    required this.price,
    required this.sellerId,
    required this.sellerName,
    required this.orderDate,
    required this.status,
  });

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