import 'package:equatable/equatable.dart';

abstract class DetalleSolicitudTrasladoEvent extends Equatable{

  const DetalleSolicitudTrasladoEvent();

  @override
  List<Object> get props => [];
}


class LoadSolicitudTrasladoById extends DetalleSolicitudTrasladoEvent {
  final int id;

  LoadSolicitudTrasladoById({required this.id});

  @override
  List<Object> get props => [id];
}