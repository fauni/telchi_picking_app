import 'package:equatable/equatable.dart';
import 'package:picking_app/models/api_response_model.dart';
import 'package:picking_app/models/auth/resultado_login_model.dart';
import 'package:picking_app/models/auth/usuario_model.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final ApiResponse<ResultadoLogin> response;

  AuthSuccess(this.response);

  @override
  List<Object> get props=> [response];
}

class AuthFailure extends AuthState {
  final String message;

  AuthFailure(this.message);

  @override
  List<Object> get props=> [message];
}

class Authenticated extends AuthState {
  final Usuario usuario;
  Authenticated(this.usuario);

  @override
  List<Object> get props => [usuario];
}
class Unauthenticated extends AuthState {}

class AuthChecking extends AuthState {}

class ChangeTokenSapSuccess extends AuthState{}