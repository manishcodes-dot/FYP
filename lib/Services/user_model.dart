class MyUser {
  final String id;
  final String name;
  final String email;
  final String token;
  final bool isAdmin;
  final bool isBlocked;

  MyUser({
    required this.id,
    required this.name,
    required this.email,
    required this.token,
    required this.isAdmin,
    this.isBlocked = false,
  });

  factory MyUser.fromJson(Map<String, dynamic> json) {
    return MyUser(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      token: json['token'],
      isAdmin: json['isAdmin'] ?? false,
      isBlocked: json['isBlocked'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'name': name,
    'email': email,
    'token': token,
    'isAdmin': isAdmin,
    'isBlocked': isBlocked,
  };
}
