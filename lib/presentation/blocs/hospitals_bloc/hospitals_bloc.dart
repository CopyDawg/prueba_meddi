import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prueba_meddi/models/hospital/application_request.dart';
import 'package:prueba_meddi/models/hospital/hospital_request.dart';
import 'package:prueba_meddi/presentation/blocs/hospitals_bloc/hospitals_event.dart';
import 'package:prueba_meddi/presentation/blocs/hospitals_bloc/hospitals_state.dart';
import 'package:prueba_meddi/repositories/hospital_repository.dart';

class HospitalsBloc extends Bloc<HospitalsEvent, HospitalsState> {
  final HospitalRepository hospitalRepository;

  HospitalsBloc({required this.hospitalRepository}) : super(HospitalsInitial()) {
    on<LoadHospitals>(_onLoadHospitals);
    on<FetchHospitals>(_onFetchHospitals);
    on<SendRequest>(_onApplicationRequest);
  }

  Future<void> _onFetchHospitals(FetchHospitals event, Emitter<HospitalsState> emit) async {
    emit(HospitalsLoading());
    try {
      final request = HospitalRequest(
        page: event.page, 
        rowsPerPage: event.rowsPerPage,
        lat: 20.7244704,
        long: -103.397476,
        estadoCode: "JC"
      );
      final hospitals = await hospitalRepository.getHospitals(request);
      if (hospitals.errorMessage?.contains("La sesión ha expirado") == true) {
        emit(HospitalsTokenExpired());
      } else {
        emit(HospitalsLoaded(hospitals.data!));
      }
    } catch (e) {
      emit(const HospitalsError("Ocurrió un error al obtener la información, intente más tarde"));
      throw("Error at get data: $e");
    }
  }

  Future<void> _onLoadHospitals(LoadHospitals event, Emitter<HospitalsState> emit) async {
    emit(HospitalsLoaded(event.hospitalData));
  }

  Future<void> _onApplicationRequest(SendRequest event, Emitter<HospitalsState> emit) async {
    try {
      final request = ApplicationRequest(hospitalId: event.hospitalId);
      final response = await hospitalRepository.createApplication(request);

      if (!response.ok) {
        if (response.errorMessage?.contains("La sesión ha expirado") == true) {
          emit(HospitalsTokenExpired());
        } else {
          emit(HospitalsError(response.errorMessage!));
        }
      }
    } catch (e) {
      emit(const HospitalsError("Ocurrió un error al mandar la solicitud, intente más tarde"));
      throw("Error at application: $e");
    }
  }
}

