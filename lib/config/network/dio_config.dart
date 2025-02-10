import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final baseOptions = BaseOptions(
  baseUrl: dotenv.env['API_BASE_URL']!,
    headers: {
      'Content-Type': 'application/json',
    },
  connectTimeout: const Duration(seconds: 10),
  receiveTimeout: const Duration(seconds: 10),
);

final dioPublic = Dio(baseOptions);
final dioPrivate = Dio(baseOptions);

void setupDioPrivateInterceptor(String jwtToken) {
  dioPrivate.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        try {
          options.headers['Authorization'] = 'Bearer $jwtToken';
          handler.next(options);
        } catch (e) {
          handler.reject(DioException(
            requestOptions: options,
            error: 'Error at setting authentication header: $e',
          ));
        }
      },
    ),
  );
}