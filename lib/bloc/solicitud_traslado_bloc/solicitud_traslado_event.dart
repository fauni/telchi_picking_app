
import 'package:equatable/equatable.dart';

abstract class SolicitudTrasladoEvent extends Equatable{

  @override
  List<Object?> get props => [];
}

class LoadSolicitudesTraslado extends SolicitudTrasladoEvent {
  final int pageNumber;
  final int pageSize;
  final String? search;
  final DateTime? docDate;

  LoadSolicitudesTraslado({
    required this.pageNumber, 
    required this.pageSize,
    this.search,
    this.docDate
  });

  @override
  List<Object?> get props => [pageNumber, pageSize, search, docDate];
}