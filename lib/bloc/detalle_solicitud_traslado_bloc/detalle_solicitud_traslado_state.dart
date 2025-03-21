import 'package:equatable/equatable.dart';
import 'package:picking_app/models/traslado/resultado_solicitud_traslado.dart';

abstract class DetalleSolicitudTrasladoState extends Equatable {
  const DetalleSolicitudTrasladoState();

  @override
  List<Object> get props => [];
}

// estados para solicitudes por Id
class DetalleSolicitudTrasladoByIdInitial extends DetalleSolicitudTrasladoState {}
class DetalleSolicitudTrasladoByIdLoading extends DetalleSolicitudTrasladoState {}
class DetalleSolicitudTrasladoByIdLoaded extends DetalleSolicitudTrasladoState {
  final SolicitudTraslado solicitudTraslado;
  const DetalleSolicitudTrasladoByIdLoaded({required this.solicitudTraslado});
  @override
  List<Object> get props => [solicitudTraslado];
}
class DetalleSolicitudTrasladoByIdError extends DetalleSolicitudTrasladoState {
  final String message;
  const DetalleSolicitudTrasladoByIdError({required this.message});
  @override
  List<Object> get props => [message];
}