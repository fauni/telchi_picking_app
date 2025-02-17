import 'package:equatable/equatable.dart';
import 'package:picking_app/models/almacen/almacen_model.dart';

abstract class AlmacenState extends Equatable{
  @override
  List<Object?> get props => [];
}

class AlmacenInitial extends AlmacenState {}
class AlmacenLoading extends AlmacenState {}
class AlmacenesLoaded extends AlmacenState {
  final List<Almacen> almacenes;
  AlmacenesLoaded({required this.almacenes});

  @override
  List<Object?> get props => [almacenes];
}

class AlmacenError extends AlmacenState {
  final String message;
  AlmacenError({required this.message});
  
  @override
  List<Object?> get props => [message];
}
