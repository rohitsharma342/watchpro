class WatchModel {
  final String id;
  final String name;
  final String brand;
  final double price;
  final String description;
  final List<String> images;
  final String sellerId;
  final String sellerName;
  final String sellerAvatar;
  final bool isVerified;
  final Map<String, String> specifications;
  final bool isTrending;
  final DateTime listedDate;
  bool isSaved;

  WatchModel({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    required this.description,
    required this.images,
    required this.sellerId,
    required this.sellerName,
    required this.sellerAvatar,
    this.isVerified = false,
    required this.specifications,
    this.isTrending = false,
    required this.listedDate,
    this.isSaved = false,
  });

  WatchModel copyWith({
    String? id,
    String? name,
    String? brand,
    double? price,
    String? description,
    List<String>? images,
    String? sellerId,
    String? sellerName,
    String? sellerAvatar,
    bool? isVerified,
    Map<String, String>? specifications,
    bool? isTrending,
    DateTime? listedDate,
    bool? isSaved,
  }) {
    return WatchModel(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      price: price ?? this.price,
      description: description ?? this.description,
      images: images ?? this.images,
      sellerId: sellerId ?? this.sellerId,
      sellerName: sellerName ?? this.sellerName,
      sellerAvatar: sellerAvatar ?? this.sellerAvatar,
      isVerified: isVerified ?? this.isVerified,
      specifications: specifications ?? this.specifications,
      isTrending: isTrending ?? this.isTrending,
      listedDate: listedDate ?? this.listedDate,
      isSaved: isSaved ?? this.isSaved,
    );
  }
}