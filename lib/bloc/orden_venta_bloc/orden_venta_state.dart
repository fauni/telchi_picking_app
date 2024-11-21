import 'package:equatable/equatable.dart';
import 'package:picking_app/models/api_reponse_list_model.dart';
import 'package:picking_app/models/venta/resultado_orden_venta_model.dart';

abstract class OrdenVentaState extends Equatable {
  const OrdenVentaState();

  @override
  List<Object> get props => [];
}

class OrdenVentaInicial extends OrdenVentaState{}
class OrdenVentaCargando extends OrdenVentaState {}
class OrdenVentaCargada extends OrdenVentaState {
  final ApiResponseList<ResultadoOrdenVentaModel> response;

  const OrdenVentaCargada(this.response);

  @override
  List<Object> get props => [response];
}

// Estado cuando se ha cargado una orden de venta específica
// class OrdenVentaPorDocNumCargada extends OrdenVentaState {
//   final ResultadoOrdenVentaModel orden;

//   const OrdenVentaPorDocNumCargada(this.orden);

//   @override
//   List<Object> get props => [orden];
// }


class OrdenVentaError extends OrdenVentaState {
  final String mensaje;
  const OrdenVentaError(this.mensaje);
  
  @override
  List<Object> get props => [mensaje];
}