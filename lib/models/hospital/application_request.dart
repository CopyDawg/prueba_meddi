class ApplicationRequest {
  final String hospitalId;

  ApplicationRequest({
    required this.hospitalId,
  });

  Map<String, dynamic> toJson() {
    return {
      'hospitalId': hospitalId,
    };
  }
}

class ApplicationResponse {
  final bool ok;
  final int status;
  final Application? application;
  final String? errorMessage;

  ApplicationResponse({
    required this.ok,
    required this.status,
    this.application,
    this.errorMessage,
  });

  factory ApplicationResponse.fromJson(Map<String, dynamic> json) {
    return ApplicationResponse(
      ok: json['ok'],
      status: json['status'],
      application: json['data']['solicitud'] != null ? Application.fromJson(json['data']['solicitud']) : null,
      errorMessage: json['data']['message'] != null ? json['data']['message'].join(', ') : null,
    );
  }
}

class Application {
  final String id;
  final DateTime createdAt;

  Application({
    required this.id,
    required this.createdAt,
  });

  factory Application.fromJson(Map<String, dynamic> json) {
    return Application(
      id: json['id'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}