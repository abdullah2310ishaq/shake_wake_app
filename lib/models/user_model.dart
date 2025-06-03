class UserModel {
  final String id;
  final String email;
  final String name;
  final String phone;
  final String? profileImage;
  final List<String> addresses;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.phone,
    this.profileImage,
    required this.addresses,
    required this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      profileImage: map['profileImage'],
      addresses: List<String>.from(map['addresses'] ?? []),
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'profileImage': profileImage,
      'addresses': addresses,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}