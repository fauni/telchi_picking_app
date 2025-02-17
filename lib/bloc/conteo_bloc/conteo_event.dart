

import 'package:equatable/equatable.dart';
import 'package:picking_app/models/conteo/conteo_request_model.dart';

abstract class ConteoEvent extends Equatable {
  const ConteoEvent();

  @override
  List<Object> get props => [];
}

class ObtenerConteosPorUsuario extends ConteoEvent {
  const ObtenerConteosPorUsuario();
  @override
  List<Object> get props => [];
}

class CrearConteo extends ConteoEvent {
  const CrearConteo(this.conteo);
  final ConteoRequest conteo;
  @override
  List<Object> get props => [conteo];
}