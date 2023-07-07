class Token {
  String accessToken;
  String refreshToken;

  Token({required this.accessToken, required this.refreshToken});

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
    );
  }
  factory Token.fromMap(Map<String, dynamic> map) {
    return Token(
      accessToken: map['accessToken'],
      refreshToken: map['refreshToken'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
    };
  }

  @override
  String toString() {
    return 'Token{accessToken: $accessToken, refreshToken: $refreshToken}';
  }
}
