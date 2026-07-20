class User {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String? fullName;
  final String? phoneNumber;
  final String role;
  final String? farmName;
  final String? profileImage;
  final bool isVerified;
  final DateTime dateJoined;
  
  User({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.fullName,
    this.phoneNumber,
    required this.role,
    this.farmName,
    this.profileImage,
    required this.isVerified,
    required this.dateJoined,
  });
  
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      fullName: json['full_name'],
      phoneNumber: json['phone_number'],
      role: json['role'] ?? 'farmer',
      farmName: json['farm_name'],
      profileImage: json['profile_image'],
      isVerified: json['is_verified'] ?? false,
      dateJoined: DateTime.parse(json['date_joined']),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'phone_number': phoneNumber,
      'role': role,
      'farm_name': farmName,
      'profile_image': profileImage,
      'is_verified': isVerified,
    };
  }
}