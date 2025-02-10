import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prueba_meddi/config/network/dio_config.dart';
import 'package:prueba_meddi/models/user/login_request.dart';
import 'package:prueba_meddi/models/user/register_request.dart';
import 'package:prueba_meddi/presentation/blocs/user_bloc/user_event.dart';
import 'package:prueba_meddi/presentation/blocs/user_bloc/user_state.dart';
import 'package:prueba_meddi/repositories/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserBloc extends Bloc<AuthEvent, UserState> {
  final UserRepository userRepository;

  UserBloc({required this.userRepository}) : super(UserInitial()) {
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
    on<LogoutEvent>(_onLogout);
  }

  void _onLogin(LoginEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final request = LoginRequest(
        username: event.email, 
        password: event.password
      );
      final response = await userRepository.login(request);
      if(response.ok) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt', response.jwtToken!);
        setupDioPrivateInterceptor(response.jwtToken!);
        emit(UserSuccess(jwt: response.jwtToken!));
      }
      else {
        emit(UserFailure(error: "Verifique sus credenciales e intente más tarde"));
      }
    } catch (e) {
      emit(UserFailure(error: "Ocurrió un error al iniciar sesión, intente más tarde"));
      throw("Error at login: $e");
    }
  }

  void _onRegister(RegisterEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final request = RegisterRequest(
        username: event.email,
        password: event.password,
        name: event.name,
        cellphone: event.phone,
      );
      final response = await userRepository.registerUser(request);
      if (response.ok) {
        emit(UserRegistered());
      } else {
        if (response.errorMessage != null 
        && response.errorMessage!.contains("E11000 duplicate key error collection")) {
          emit(UserFailure(error: "El correo electrónico que ingresó ya está registrado"));
        } else {
          emit(UserFailure(error: "Verifique sus datos e intente más tarde"));
        }
      }
    } catch (e) {
      emit(UserFailure(error: "Ocurrió un error al registrarse, intente más tarde"));
      throw("Error at register: $e");
    }
  }
  

  void _onLogout(LogoutEvent event, Emitter<UserState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt');
    emit(UserLoggedOut()); 
  }
}