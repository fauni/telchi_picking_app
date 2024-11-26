import 'package:equatable/equatable.dart';

abstract class OrdenVentaEvent extends Equatable{

  const OrdenVentaEvent();

  @override
  List<Object> get props => [];
}

class ObtenerOrdenesVenta extends OrdenVentaEvent {
  final String tipoDocumento;

  const ObtenerOrdenesVenta(this.tipoDocumento);

  @override
  List<Object> get props => [tipoDocumento];
}

class ObtenerOrdenesVentaBySearch extends OrdenVentaEvent {
  final String search;
  final String tipoDocumento;
  const ObtenerOrdenesVentaBySearch(this.search, this.tipoDocumento);
  @override
  List<Object> get props => [search, tipoDocumento];
}

// Nuevo evento para obtener una orden por DocNum
// class ObtenerOrdenVentaByDocNum extends OrdenVentaEvent {
//   final String docNum;

//   const ObtenerOrdenVentaByDocNum(this.docNum);

//   @override
//   List<Object> get props => [docNum];
// }