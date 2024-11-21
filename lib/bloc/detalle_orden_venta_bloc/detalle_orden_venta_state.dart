import 'package:equatable/equatable.dart';
import 'package:picking_app/models/venta/resultado_orden_venta_model.dart';

abstract class DetalleOrdenVentaState extends Equatable {
  const DetalleOrdenVentaState();

  @override
  List<Object> get props => [];
}

class DetalleOrdenVentaInicial extends DetalleOrdenVentaState{}
class DetalleOrdenVentaCargando extends DetalleOrdenVentaState {}
// class OrdenVentaCargada extends DetalleOrdenVentaState {
//   final ApiResponseList<ResultadoOrdenVentaModel> response;

//   const OrdenVentaCargada(this.response);

//   @override
//   List<Object> get props => [response];
// }

// Estado cuando se ha cargado una orden de venta específica
class OrdenVentaPorDocNumCargada extends DetalleOrdenVentaState {
  final ResultadoOrdenVentaModel orden;

  const OrdenVentaPorDocNumCargada(this.orden);

  @override
  List<Object> get props => [orden];
}


class DetalleOrdenVentaError extends DetalleOrdenVentaState {
  final String mensaje;
  const DetalleOrdenVentaError(this.mensaje);
  
  @override
  List<Object> get props => [mensaje];
}