class Hospital {
  final String id;
  final String name;
  final String photo;
  final String logo;
  final String address;
  final String googleMapsUrl;
  final bool enabled;
  final String phone;
  final String schedule;
  final String stateCode;
  final String municipality;
  final String observations;
  final Map<String, dynamic> location;
  final List<int> insurers;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic> distance;
  bool hasApplication;

  Hospital({
    required this.id,
    required this.name,
    required this.photo,
    required this.logo,
    required this.address,
    required this.googleMapsUrl,
    required this.enabled,
    required this.phone,
    required this.schedule,
    required this.stateCode,
    required this.municipality,
    required this.observations,
    required this.location,
    required this.insurers,
    required this.createdAt,
    required this.updatedAt,
    required this.distance,
    this.hasApplication = false
  });

  factory Hospital.fromJson(Map<String, dynamic> json) {
    return Hospital(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      photo: json['foto'] ?? '',
      logo: json['logo'] ?? '',
      address: json['direccion'] ?? '',
      googleMapsUrl: json['urlGoogleMaps'] ?? '',
      enabled: json['enabled'] ?? false,
      phone: json['telefono'] ?? '',
      schedule: json['horario'] ?? '',
      stateCode: json['estadoCode'] ?? '',
      municipality: json['municipio'] ?? '',
      observations: json['observaciones'] ?? '',
      location: json['location'] ?? {},
      insurers: json['aseguradora'] != null
          ? List<int>.from(json['aseguradora'])
          : [],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      distance: json['dist'] ?? {},
      hasApplication: false,
    );
  }

  Hospital copyWith({bool? hasApplication}) {
    return Hospital(
      id: id,
      name: name,
      photo: photo,
      logo: logo,
      address: address,
      googleMapsUrl: googleMapsUrl,
      enabled: enabled,
      phone: phone,
      schedule: schedule,
      stateCode: stateCode,
      municipality: municipality,
      observations: observations,
      location: location,
      insurers: insurers,
      createdAt: createdAt,
      updatedAt: updatedAt,
      distance: distance,
      hasApplication: hasApplication!,
    );
  }
}