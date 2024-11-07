import 'package:equatable/equatable.dart';
import 'package:picking_app/models/auth/login_model.dart';
import 'package:picking_app/models/auth/usuario_model.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginRequested extends AuthEvent {
  final Login data;

  LoginRequested({required this.data});

  @override
  List<Object> get props => [data];
}

class LoginEvent extends AuthEvent {
  final Usuario usuario;
  final String token;
  final String tokenSap;
  LoginEvent(this.usuario, this.token, this.tokenSap);

  @override
  List<Object> get props => [usuario, token, tokenSap];
}
class LogoutEvent extends AuthEvent {}

