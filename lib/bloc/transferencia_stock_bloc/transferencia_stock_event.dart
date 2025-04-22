
import 'package:equatable/equatable.dart';

abstract class TransferenciaStockEvent extends Equatable{

  @override
  List<Object?> get props => [];
}

class LoadTransferenciaStock extends TransferenciaStockEvent {
  final int pageNumber;
  final int pageSize;
  final String? search;
  final DateTime? docDate;

  LoadTransferenciaStock({
    required this.pageNumber, 
    required this.pageSize,
    this.search,
    this.docDate
  });

  @override
  List<Object?> get props => [pageNumber, pageSize, search, docDate];
}