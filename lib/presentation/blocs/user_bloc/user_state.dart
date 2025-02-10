import 'package:equatable/equatable.dart';

abstract class UserState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserRegistered extends UserState {}

class UserSuccess extends UserState {
  final String jwt;

  UserSuccess({required this.jwt});

  @override
  List<Object?> get props => [jwt];
}

class UserFailure extends UserState {
  final String error;

  UserFailure({required this.error});

  @override
  List<Object?> get props => [error];
}

class UserLoggedOut extends UserState {}