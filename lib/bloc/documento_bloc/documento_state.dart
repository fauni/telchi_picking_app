import 'package:equatable/equatable.dart';

abstract class DocumentoState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DocumentInitial extends DocumentoState {}

class DocumentLoading extends DocumentoState {}

class SaveDocumentToSapSuccess extends DocumentoState{
  final String message;
  SaveDocumentToSapSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

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