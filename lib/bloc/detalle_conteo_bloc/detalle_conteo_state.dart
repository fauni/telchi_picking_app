import 'package:equatable/equatable.dart';
import 'package:picking_app/models/api_reponse_list_model.dart';
import 'package:picking_app/models/conteo/detalle_conteo_model.dart';

abstract class DetalleConteoState extends Equatable {
  const DetalleConteoState();
  @override
  List<Object> get props => [];
}

class DetalleConteoInitial extends DetalleConteoState {}
class DetalleConteoCargando extends DetalleConteoState {}


class DetalleConteoCargado extends DetalleConteoState {
  final ApiResponseList<DetalleConteo> response;
  const DetalleConteoCargado(this.response);

  @override
  List<Object> get props => [response];
}

class DetalleActualizaCantidadSuccess extends DetalleConteoState{
  final String mensaje;

  const DetalleActualizaCantidadSuccess(this.mensaje);
  @override
  List<Object> get props => [mensaje];
}

class DetalleConteoError extends DetalleConteoState {
  final int codigoEstado;
  final String mensaje;
  const DetalleConteoError(this.codigoEstado, this.mensaje);

  @override
  List<Object> get props => [codigoEstado, mensaje];
}



class DetalleContetoReiniciado extends DetalleConteoState {}

class DetalleReiniciarCantidadSuccess extends DetalleConteoState{
  final String mensaje;

  const DetalleReiniciarCantidadSuccess(this.mensaje);
  @override
  List<Object> get props => [mensaje];
}
