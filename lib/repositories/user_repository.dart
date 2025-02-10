import 'package:dio/dio.dart';
import 'package:prueba_meddi/config/network/dio_config.dart';
import 'package:prueba_meddi/models/user/login_request.dart';
import 'package:prueba_meddi/models/user/register_request.dart';

class UserRepository {
  UserRepository();

  Future<RegisterResponse> registerUser(RegisterRequest request) async {
    try {
      final response = await dioPublic.post(
        '/user/create',
        data: request.toJson(),
      );
      return RegisterResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        return RegisterResponse.fromJson(e.response!.data);
      } else {
        throw Exception('Error at register: ${e.message}');
      }
    }
  }

  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await dioPublic.post(
        '/user/login',
        data: request.toJson(),
      );
      return LoginResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        return LoginResponse.fromJson(e.response!.data);
      } else {
        throw Exception('Error at login: ${e.message}');
      }
    }
  }
}