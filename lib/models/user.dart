class User {
  final int id;
  final String name;
  final String email;
  final String role;
  final String? phoneNumber;
  final String? farmName;
  final String? profileImage;
  final bool isVerified;
  final bool isActive;
  final DateTime? createdAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.phoneNumber,
    this.farmName,
    this.profileImage,
    required this.isVerified,
    required this.isActive,
    this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}') ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'farmer',
      phoneNumber: json['phone_number'],
      farmName: json['farm_name'],
      profileImage: json['profile_image'],
      isVerified: json['is_verified'] ?? false,
      isActive: json['is_active'] ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'phone_number': phoneNumber,
      'farm_name': farmName,
      'profile_image': profileImage,
      'is_verified': isVerified,
      'is_active': isActive,
    };
  }
}
