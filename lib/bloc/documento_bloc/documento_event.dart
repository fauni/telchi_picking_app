import 'package:equatable/equatable.dart';

abstract class DocumentoEvent extends Equatable {
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

class CreateDocumentoSolicitudFromSAP extends DocumentoEvent {
  final String docEntry;

  CreateDocumentoSolicitudFromSAP({required this.docEntry});

  @override
  List<Object?> get props => [docEntry];
}

class CreateDocumentoTransferenciaStockFromSAP extends DocumentoEvent {
  final String docEntry;

  CreateDocumentoTransferenciaStockFromSAP({required this.docEntry});

  @override
  List<Object?> get props => [docEntry];
}

class SaveConteoForDocNumToSap extends DocumentoEvent {
  final String docNum;
  final String tipoDocumento;
  SaveConteoForDocNumToSap({required this.docNum, required this.tipoDocumento});

  @override
  List<Object?> get props => [docNum, tipoDocumento];
}

class SaveConteoTransferenciaStockForDocEntryToSap extends DocumentoEvent {
  final int docEntry;
  final String tipoDocumento;
  SaveConteoTransferenciaStockForDocEntryToSap({required this.docEntry, required this.tipoDocumento});

  @override
  List<Object?> get props => [docEntry, tipoDocumento];
}
