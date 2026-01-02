class UserModel {
  final String id;
  final String name;
  final String email;
  final String profileImage;
  final String phone;
  final String location;
  final DateTime memberSince;
  final int totalSales;
  final double rating;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.profileImage,
    required this.phone,
    required this.location,
    required this.memberSince,
    required this.totalSales,
    required this.rating,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      profileImage: json['profile_image'] as String,
      phone: json['phone'] as String? ?? '',
      location: json['location'] as String? ?? '',
      memberSince: DateTime.parse(json['created_at'] as String),
      totalSales: json['total_sales'] as int? ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profile_image': profileImage,
      'phone': phone,
      'location': location,
      'total_sales': totalSales,
      'rating': rating,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? profileImage,
    String? phone,
    String? location,
    DateTime? memberSince,
    int? totalSales,
    double? rating,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
      phone: phone ?? this.phone,
      location: location ?? this.location,
      memberSince: memberSince ?? this.memberSince,
      totalSales: totalSales ?? this.totalSales,
      rating: rating ?? this.rating,
    );
  }
}