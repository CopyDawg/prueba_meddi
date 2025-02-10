import 'package:prueba_meddi/models/user/user.dart';

class RegisterRequest {
  final String username;
  final String password;
  final String name;
  final String cellphone;

  RegisterRequest({
    required this.username,
    required this.password,
    required this.name,
    required this.cellphone,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'name': name,
      'cellphone': cellphone,
    };
  }
}

class RegisterResponse {
  final bool ok;
  final int status;
  final User? user;
  final String? errorMessage;

  RegisterResponse({
    required this.ok,
    required this.status,
    this.user,
    this.errorMessage,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      ok: json['ok'],
      status: json['status'],
      user: json['data']['user'] != null ? User.fromJson(json['data']['user']) : null,
      errorMessage: json['data']?['message'] != null
          ? (json['data']['message'] is List
              ? (json['data']['message'] as List).join(', ')
              : json['data']['message'].toString())
          : null,
    );
  }
}