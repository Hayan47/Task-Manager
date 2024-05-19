class Auth {
  final String token;

  Auth({required this.token});

  factory Auth.fromJson(Map<String, dynamic> json) => Auth(
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "token": token,
      };
}
