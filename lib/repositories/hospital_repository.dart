import 'package:dio/dio.dart';
import 'package:prueba_meddi/config/network/dio_config.dart';
import 'package:prueba_meddi/models/hospital/application_request.dart';
import 'package:prueba_meddi/models/hospital/hospital_request.dart';

class HospitalRepository {

  HospitalRepository();

  Future<HospitalResponse> getHospitals(HospitalRequest request) async {
    try {
      final response = await dioPrivate.get(
        '/hospital/get/all',
        queryParameters: request.toQueryParameters(),
      );
      return HospitalResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        return HospitalResponse.fromJson(e.response!.data);
      } else {
        throw Exception('Error at get hospitals: ${e.message}');
      }
    }
  }

  Future<ApplicationResponse> createApplication(ApplicationRequest request) async {
    try {
      final response = await dioPrivate.post(
        '/solicitud/create',
        data: request.toJson(),
      );

      return ApplicationResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        return ApplicationResponse.fromJson(e.response!.data);
      } else {
        throw Exception('Error at create application: ${e.message}');
      }
    }
  }
}