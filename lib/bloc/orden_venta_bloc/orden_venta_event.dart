import 'package:equatable/equatable.dart';

abstract class OrdenVentaEvent extends Equatable{

  const OrdenVentaEvent();

  @override
  List<Object> get props => [];
}

class ObtenerOrdenesVenta extends OrdenVentaEvent {}

class ObtenerOrdenesVentaBySearch extends OrdenVentaEvent {
  final String search;
  const ObtenerOrdenesVentaBySearch(this.search);
  @override
  List<Object> get props => [search];
}

// Nuevo evento para obtener una orden por DocNum
class ObtenerOrdenVentaByDocNum extends OrdenVentaEvent {
  final String docNum;

  const ObtenerOrdenVentaByDocNum(this.docNum);

  @override
  List<Object> get props => [docNum];
}