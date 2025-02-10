import 'package:equatable/equatable.dart';
import 'package:prueba_meddi/models/hospital/hospital_request.dart';

abstract class HospitalsEvent extends Equatable {
  const HospitalsEvent();
  @override
  List<Object?> get props => [];
}

class FetchHospitals extends HospitalsEvent {
  final int page;
  final int rowsPerPage;

  const FetchHospitals(this.page, this.rowsPerPage);

  @override
  List<Object?> get props => [page, rowsPerPage];
}

class LoadHospitals extends HospitalsEvent {
  final HospitalData hospitalData;

  const LoadHospitals(this.hospitalData);

  @override
  List<Object?> get props => [hospitalData];
}

class SendRequest extends HospitalsEvent {
  final String hospitalId;

  const SendRequest(this.hospitalId);

  @override
  List<Object?> get props => [hospitalId];
}