class LoginRequest {
  final String username;
  final String password;

  LoginRequest({
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
    };
  }
}

class LoginResponse {
  final bool ok;
  final int status;
  final String? jwtToken;
  final String? errorMessage;

  LoginResponse({
    required this.ok,
    required this.status,
    this.jwtToken,
    this.errorMessage,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      ok: json['ok'],
      status: json['status'],
      jwtToken: json['data']?['jwtToken'],
      errorMessage: json['data']?['message'] != null
          ? (json['data']['message'] is List
              ? (json['data']['message'] as List).join(', ')
              : json['data']['message'].toString())
          : null,
    );
  }
}