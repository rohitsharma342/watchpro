enum OrderStatus {
  pending,
  confirmed,
  shipped,
  delivered,
  cancelled,
}

class Order {
  final String id;
  final String watchId;
  final String watchName;
  final String watchImage;
  final String sellerId;
  final String sellerName;
  final String buyerId;
  final double price;
  final OrderStatus status;
  final DateTime orderDate;
  final DateTime? deliveryDate;

  Order({
    required this.id,
    required this.watchId,
    required this.watchName,
    required this.watchImage,
    required this.sellerId,
    required this.sellerName,
    required this.buyerId,
    required this.price,
    required this.status,
    required this.orderDate,
    this.deliveryDate,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] ?? '',
      watchId: json['watchId'] ?? '',
      watchName: json['watchName'] ?? '',
      watchImage: json['watchImage'] ?? '',
      sellerId: json['sellerId'] ?? '',
      sellerName: json['sellerName'] ?? '',
      buyerId: json['buyerId'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      status: OrderStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => OrderStatus.pending,
      ),
      orderDate: json['orderDate'] != null
          ? DateTime.parse(json['orderDate'])
          : DateTime.now(),
      deliveryDate: json['deliveryDate'] != null
          ? DateTime.parse(json['deliveryDate'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'watchId': watchId,
      'watchName': watchName,
      'watchImage': watchImage,
      'sellerId': sellerId,
      'sellerName': sellerName,
      'buyerId': buyerId,
      'price': price,
      'status': status.name,
      'orderDate': orderDate.toIso8601String(),
      'deliveryDate': deliveryDate?.toIso8601String(),
    };
  }
}