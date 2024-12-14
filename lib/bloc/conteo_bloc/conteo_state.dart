

import 'package:equatable/equatable.dart';
import 'package:picking_app/models/api_reponse_list_model.dart';
import 'package:picking_app/models/conteo/conteo_model.dart';

abstract class ConteoState extends Equatable {
  const ConteoState();
  
  @override
  List<Object> get props => [];
}

class ConteoInitial extends ConteoState {}
class ConteoCargando extends ConteoState {}
class ConteoCargado extends ConteoState {
  final ApiResponseList<Conteo> response;
  const ConteoCargado(this.response);

  @override
  List<Object> get props => [response];
}

class ConteoError extends ConteoState {
  final int codigoEstado;
  final String mensaje;
  const ConteoError(this.codigoEstado, this.mensaje);

  @override
  List<Object> get props => [codigoEstado, mensaje];
}

