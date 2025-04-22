import 'package:equatable/equatable.dart';

abstract class DetalleTransferenciaStockEvent extends Equatable{

  const DetalleTransferenciaStockEvent();

  @override
  List<Object> get props => [];
}


class LoadTransferenciaStockById extends DetalleTransferenciaStockEvent {
  final int id;

  LoadTransferenciaStockById({required this.id});

  @override
  List<Object> get props => [id];
}