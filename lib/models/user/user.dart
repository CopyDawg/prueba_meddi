class User {
  final String username;
  final String name;
  final String cellphone;

  User({
    required this.username,
    required this.name,
    required this.cellphone,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      name: json['name'],
      cellphone: json['cellphone'],
    );
  }
}