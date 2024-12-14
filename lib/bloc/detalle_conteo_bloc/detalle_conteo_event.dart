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