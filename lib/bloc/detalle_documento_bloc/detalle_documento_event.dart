
import 'package:equatable/equatable.dart';

abstract class DetalleDocumentoEvent extends Equatable{

  const DetalleDocumentoEvent();

  @override
  List<Object?> get props => [];
}

class ActualizarCantidadPorDetalle extends DetalleDocumentoEvent {
  final int idDetalle;
  final double cantidadAgregada;
  final String? fechaVencimiento;

  const ActualizarCantidadPorDetalle({required this.idDetalle, required this.cantidadAgregada, this.fechaVencimiento });

  @override
  List<Object?> get props => [idDetalle, cantidadAgregada, fechaVencimiento];
}

class ReiniciarCantidadPorDetalle extends DetalleDocumentoEvent {
  final int idDetalle;
  final double cantidadAgregada;

  const ReiniciarCantidadPorDetalle({required this.idDetalle, required this.cantidadAgregada });

  @override
  List<Object?> get props => [idDetalle, cantidadAgregada];
}