import 'package:equatable/equatable.dart';
import 'package:picking_app/models/traslado/resultado_solicitud_traslado.dart';

abstract class DetalleTransferenciaStockState extends Equatable {
  const DetalleTransferenciaStockState();

  @override
  List<Object> get props => [];
}

// estados para solicitudes por Id
class DetalleTransferenciaStockByIdInitial extends DetalleTransferenciaStockState {}
class DetalleTransferenciaStockByIdLoading extends DetalleTransferenciaStockState {}
class DetalleTransferenciaStockByIdLoaded extends DetalleTransferenciaStockState {
  final SolicitudTraslado solicitudTraslado;
  const DetalleTransferenciaStockByIdLoaded({required this.solicitudTraslado});
  @override
  List<Object> get props => [solicitudTraslado];
}
class DetalleTransferenciaStockByIdError extends DetalleTransferenciaStockState {
  final String message;
  const DetalleTransferenciaStockByIdError({required this.message});
  @override
  List<Object> get props => [message];
}
class UnauthorizedErrorTransferenciaStock extends DetalleTransferenciaStockState{}