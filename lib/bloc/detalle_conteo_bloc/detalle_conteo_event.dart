  import 'package:equatable/equatable.dart';

abstract class DetalleConteoEvent extends Equatable{
  const DetalleConteoEvent();

  @override
  List<Object> get props => [];
}

class ObtenerDetalleConteoPorId extends DetalleConteoEvent {
  final int id;
  const ObtenerDetalleConteoPorId(this.id);
  @override
  List<Object> get props => [id];
}

class ActualizarCantidadDetalleConteo extends DetalleConteoEvent {
  final int idDetalle;
  final double cantidadAgregada;

  const ActualizarCantidadDetalleConteo({required this.idDetalle, required this.cantidadAgregada });

  @override
  List<Object> get props => [idDetalle, cantidadAgregada];
}

class ReiniciarCantidadDetalleConteo extends DetalleConteoEvent {
  final int idDetalle;
  final double cantidadAgregada;

  const ReiniciarCantidadDetalleConteo({required this.idDetalle, required this.cantidadAgregada });

  @override
  List<Object> get props => [idDetalle, cantidadAgregada];
}