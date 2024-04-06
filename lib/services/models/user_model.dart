class User {
  final String token;

  User({required this.token});

  factory User.fromJson(Map<String, dynamic> json) => User(
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "token": token,
      };
}
