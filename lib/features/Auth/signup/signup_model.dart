class User {
  final String username;
  final String password;
  final String realname;

  User({required this.username, required this.password, required this.realname});

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "password": password,
      "realname": realname,
    };
  }
}
