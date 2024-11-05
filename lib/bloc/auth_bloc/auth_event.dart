import 'package:equatable/equatable.dart';
import 'package:picking_app/models/auth/login_model.dart';

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