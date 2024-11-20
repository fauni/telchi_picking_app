import 'package:equatable/equatable.dart';

abstract class DocumentoEvent extends Equatable{
   @override
  List<Object?> get props => [];
}

class CreateDocumentFromSAP extends DocumentoEvent {
  final String docNum;
  final String tipoDocumento;

  CreateDocumentFromSAP({required this.docNum, required this.tipoDocumento});

  @override
  List<Object?> get props => [docNum, tipoDocumento];
}

class SaveConteoForDocNumToSap extends DocumentoEvent {
  final String docNum;
  SaveConteoForDocNumToSap({required this.docNum});

  @override
  List<Object?> get props => [docNum];
}