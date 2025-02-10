import 'package:equatable/equatable.dart';
import 'package:prueba_meddi/models/hospital/hospital_request.dart';

abstract class HospitalsState extends Equatable {
  const HospitalsState();
  @override
  List<Object?> get props => [];
}

class HospitalsInitial extends HospitalsState {}

class HospitalsLoading extends HospitalsState {}

class HospitalsLoaded extends HospitalsState {
  final HospitalData hospitalData;

  const HospitalsLoaded(this.hospitalData);

  @override
  List<Object?> get props => [hospitalData];
}

class HospitalsError extends HospitalsState {
  final String error;

  const HospitalsError(this.error);

  @override
  List<Object?> get props => [error];
}

class HospitalsTokenExpired extends HospitalsState {}