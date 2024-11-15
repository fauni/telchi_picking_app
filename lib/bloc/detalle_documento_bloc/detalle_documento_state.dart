import 'package:equatable/equatable.dart';

abstract class DetalleDocumentoState extends Equatable{

  const DetalleDocumentoState();
  @override
  List<Object?> get props => [];
}

class DetalleDocumentoInitial extends DetalleDocumentoState {}

class DetalleDocumentoLoading extends DetalleDocumentoState {}

class DetalleDocumentoSuccess extends DetalleDocumentoState {
  final String mensaje;

  const DetalleDocumentoSuccess(this.mensaje);

  @override
  List<Object?> get props => [mensaje];
}

class DetalleDocumentoError extends DetalleDocumentoState {
  final String error;

  const DetalleDocumentoError(this.error);

  @override
  List<Object?> get props => [error];
}