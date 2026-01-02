enum OrderStatus { pending, confirmed, shipped, delivered, cancelled }

class OrderModel {
  final String id;
  final String watchId;
  final String watchTitle;
  final String watchImage;
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
    required this.sellerId,
    required this.sellerName,
    required this.price,
    required this.orderDate,
    required this.status,
    required this.shippingAddress,
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
