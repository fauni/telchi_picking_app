
import 'package:equatable/equatable.dart';
import 'package:picking_app/models/traslado/resultado_solicitud_traslado.dart';

abstract class SolicitudTrasladoState extends Equatable {
  @override
  List<Object> get props => [];
}

class SolicitudTrasladoInitial extends SolicitudTrasladoState {}
class SolicitudTrasladoLoading extends SolicitudTrasladoState {}
class SolicitudesTrasladoLoaded extends SolicitudTrasladoState {
  final List<SolicitudTraslado> solicitudesTraslado;
  SolicitudesTrasladoLoaded({required this.solicitudesTraslado});
  @override
  List<Object> get props => [solicitudesTraslado];
}

class SolicitudTrasladoLoadError extends SolicitudTrasladoState {
  final String message;
  SolicitudTrasladoLoadError({required this.message});
  @override
  List<Object> get props => [message];
}

