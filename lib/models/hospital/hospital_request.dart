import 'package:prueba_meddi/models/hospital/hospital.dart';

class HospitalResponse {
  final bool ok;
  final int? status;
  final HospitalData? data;
  final String? errorMessage;

  HospitalResponse({
    required this.ok,
    this.status,
    this.data,
    this.errorMessage,
  });

  factory HospitalResponse.fromJson(Map<String, dynamic> json) {
    return HospitalResponse(
      ok: json['ok'] ?? false,
      status: json['status'] as int?,
      data: json['data'] != null && json['data']['data'] != null
        ? HospitalData.fromJson(json['data'])
        : null,
      errorMessage: json['data'] != null && json['data']['message'] != null
        ? json['data']['message']
        : null,
    );
  }
}

class HospitalRequest {
  final int page;
  final int rowsPerPage;
  final double? lat;
  final double? long;
  final String? estadoCode;

  HospitalRequest({
    required this.page,
    required this.rowsPerPage,
    this.lat,
    this.long,
    this.estadoCode,
  });

  Map<String, dynamic> toQueryParameters() {
    return {
      'page': page.toString(),
      'rowsPerPage': rowsPerPage.toString(),
      if (lat != null) 'lat': lat.toString(),
      if (long != null) 'long': long.toString(),
      if (estadoCode != null) 'estadoCode': estadoCode,
    };
  }
}

class HospitalData {
  final int total;
  final int currentPage;
  final int totalPages;
  final List<Hospital> hospitals;

  HospitalData({
    required this.total,
    required this.currentPage,
    required this.totalPages,
    required this.hospitals,
  });

  factory HospitalData.fromJson(Map<String, dynamic> json) {
    return HospitalData(
      total: json['total'] ?? 0,
      currentPage: json['currentPage'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      hospitals: json['data'] != null && json['data'] is List
          ? (json['data'] as List<dynamic>)
              .map((hospital) => Hospital.fromJson(hospital as Map<String, dynamic>))
              .toList()
          : [],
    );
  }

  HospitalData copyWith({
    int? total,
    int? currentPage,
    int? totalPages,
    List<Hospital>? hospitals,
  }) {
    return HospitalData(
      total: total ?? this.total,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      hospitals: hospitals ?? this.hospitals,
    );
  }
}
