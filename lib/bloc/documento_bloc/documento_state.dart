import 'package:equatable/equatable.dart';

abstract class DocumentoState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DocumentInitial extends DocumentoState {}

class DocumentLoading extends DocumentoState {}

class DocumentSuccess extends DocumentoState {
  final int documentId;

  DocumentSuccess(this.documentId);

  @override
  List<Object?> get props => [documentId];
}

class DocumentFailure extends DocumentoState {
  final String error;

  DocumentFailure(this.error);

  @override
  List<Object?> get props => [error];
}