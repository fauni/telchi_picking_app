
import 'package:equatable/equatable.dart';
import 'package:picking_app/models/traslado/resultado_solicitud_traslado.dart';

abstract class TransferenciaStockState extends Equatable {
  @override
  List<Object> get props => [];
}

class TransferenciaStockInitial extends TransferenciaStockState {}
class TransferenciaStockLoading extends TransferenciaStockState {}
class TransferenciasStockLoaded extends TransferenciaStockState {
  final List<SolicitudTraslado> solicitudesTraslado;
  TransferenciasStockLoaded({required this.solicitudesTraslado});
  @override
  List<Object> get props => [solicitudesTraslado];
}

class TransferenciaStockLoadError extends TransferenciaStockState {
  final String message;
  TransferenciaStockLoadError({required this.message});
  @override
  List<Object> get props => [message];
}

