// Suggested code may be subject to a license. Learn more: ~LicenseLog:2035559345.
// Suggested code may be subject to a license. Learn more: ~LicenseLog:2227835362.
// Suggested code may be subject to a license. Learn more: ~LicenseLog:1146579827.
// Suggested code may be subject to a license. Learn more: ~LicenseLog:1765674835.
class User {
  final String id;
  final String name;
  final String email;
  final String password;
  final String role;
  final String createdAt;
  final String updatedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        password: json["password"],
        role: json["role"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "password": password,
        "role": role,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
      };
}
