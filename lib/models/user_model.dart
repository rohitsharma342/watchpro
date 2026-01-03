class UserModel {
  final String id;
  final String name;
  final String email;
  final String avatar;
  final String phone;
  final DateTime joinedDate;
  final int totalListings;
  final int totalSales;
  final double rating;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
    this.phone = '',
    required this.joinedDate,
    this.totalListings = 0,
    this.totalSales = 0,
    this.rating = 0.0,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? avatar,
    String? phone,
    DateTime? joinedDate,
    int? totalListings,
    int? totalSales,
    double? rating,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      phone: phone ?? this.phone,
      joinedDate: joinedDate ?? this.joinedDate,
      totalListings: totalListings ?? this.totalListings,
      totalSales: totalSales ?? this.totalSales,
      rating: rating ?? this.rating,
    );
  }
}