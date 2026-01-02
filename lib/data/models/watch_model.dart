class WatchModel {
  final String id;
  final String title;
  final String brand;
  final double price;
  final String description;
  final List<String> images;
  final String category;
  final Map<String, String> specifications;
  final String sellerId;
  final String sellerName;
  final String sellerImage;
  final double sellerRating;
  final bool isVerified;
  final DateTime listedDate;
  final String condition;
  final bool isTrending;

  WatchModel({
    required this.id,
    required this.title,
    required this.brand,
    required this.price,
    required this.description,
    required this.images,
    required this.category,
    required this.specifications,
    required this.sellerId,
    required this.sellerName,
    required this.sellerImage,
    required this.sellerRating,
    required this.isVerified,
    required this.listedDate,
    required this.condition,
    this.isTrending = false,
  });

  factory WatchModel.fromJson(Map<String, dynamic> json) {
    return WatchModel(
      id: json['id'] as String,
      title: json['title'] as String,
      brand: json['brand'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String,
      images: List<String>.from(json['images'] ?? []),
      category: json['category'] as String,
      specifications: Map<String, String>.from(json['specifications'] ?? {}),
      sellerId: json['seller_id'] as String,
      sellerName: json['seller_name'] as String,
      sellerImage: json['seller_image'] as String,
      sellerRating: (json['seller_rating'] as num).toDouble(),
      isVerified: json['is_verified'] as bool? ?? false,
      listedDate: DateTime.parse(json['listed_date'] as String),
      condition: json['condition'] as String,
      isTrending: json['is_trending'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'brand': brand,
      'price': price,
      'description': description,
      'images': images,
      'category': category,
      'specifications': specifications,
      'seller_id': sellerId,
      'seller_name': sellerName,
      'seller_image': sellerImage,
      'seller_rating': sellerRating,
      'is_verified': isVerified,
      'listed_date': listedDate.toIso8601String(),
      'condition': condition,
      'is_trending': isTrending,
    };
  }

  WatchModel copyWith({
    String? id,
    String? title,
    String? brand,
    double? price,
    String? description,
    List<String>? images,
    String? category,
    Map<String, String>? specifications,
    String? sellerId,
    String? sellerName,
    String? sellerImage,
    double? sellerRating,
    bool? isVerified,
    DateTime? listedDate,
    String? condition,
    bool? isTrending,
  }) {
    return WatchModel(
      id: id ?? this.id,
      title: title ?? this.title,
      brand: brand ?? this.brand,
      price: price ?? this.price,
      description: description ?? this.description,
      images: images ?? this.images,
      category: category ?? this.category,
      specifications: specifications ?? this.specifications,
      sellerId: sellerId ?? this.sellerId,
      sellerName: sellerName ?? this.sellerName,
      sellerImage: sellerImage ?? this.sellerImage,
      sellerRating: sellerRating ?? this.sellerRating,
      isVerified: isVerified ?? this.isVerified,
      listedDate: listedDate ?? this.listedDate,
      condition: condition ?? this.condition,
      isTrending: isTrending ?? this.isTrending,
    );
  }
}