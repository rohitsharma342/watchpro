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
