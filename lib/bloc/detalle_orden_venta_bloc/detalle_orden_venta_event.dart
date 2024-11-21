import 'package:equatable/equatable.dart';

abstract class DetalleOrdenVentaEvent extends Equatable{

  const DetalleOrdenVentaEvent();

  @override
  List<Object> get props => [];
}

// Nuevo evento para obtener una orden por DocNum
class ObtenerOrdenVentaByDocNum extends DetalleOrdenVentaEvent {
  final String docNum;

  const ObtenerOrdenVentaByDocNum(this.docNum);

  @override
  List<Object> get props => [docNum];
}