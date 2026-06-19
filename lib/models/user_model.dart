class User {
  final String id;
  final String fullName;
  final String email;
  final String company;
  final String role;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.company,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      company: json['company'] ?? '',
      role: json['role'] ?? 'Recruiter',
    );
  }
}
