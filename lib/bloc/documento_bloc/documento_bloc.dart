import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picking_app/bloc/bloc.dart';
import 'package:picking_app/repository/documento_repository.dart';

class DocumentoBloc extends Bloc<DocumentoEvent, DocumentoState> {
  final DocumentoRepository repository;
  
  DocumentoBloc(this.repository): super(DocumentInitial()){
    on<CreateDocumentFromSAP>(_onCrearDocumentoFromSAP);
    on<CreateDocumentoSolicitudFromSAP>(_onCrearDocumentoSolicitudFromSAP);
    on<CreateDocumentoTransferenciaStockFromSAP>(_onCrearDocumentoTransferenciaStockFromSAP);
    on<SaveConteoForDocNumToSap>(_onGuardaConteoEnSapPorDocNum);
    on<SaveConteoTransferenciaStockForDocEntryToSap>(_onGuardaConteoTransferenciaStockEnSapPorDocNum);
  }

  Future<void> _onCrearDocumentoFromSAP(CreateDocumentFromSAP event, Emitter<DocumentoState> emit) async {
    // Emitir el estado de carga
    emit(DocumentLoading());

    try {
      // Llamar al repositorio para crear el documento desde SAP
      final response = await repository.crearDocumentoDesdeSap(event.docNum, event.tipoDocumento);

      // Manejar la respuesta exitosa
      if(response.isSuccessful && response.resultado != null) {
        emit(DocumentSuccess(response.resultado!.documentId));
      } else {
        // Manejo de errores basado en los mensajes de error devueltos
        final errorMessage = response.errorMessages?.join(', ') ?? 'Error desconocido';
        emit(DocumentFailure(errorMessage));
      }
    } catch(e) {
      emit(DocumentFailure("Error al crear el documento: $e"));
    }
  }

  Future<void> _onCrearDocumentoSolicitudFromSAP(CreateDocumentoSolicitudFromSAP event, Emitter<DocumentoState> emit) async {
    emit(DocumentLoading());
    try {
      final response = await repository.crearDocumentoSolicitudDesdeSap(event.docEntry);
      if(response.isSuccessful && response.resultado != null) {
        emit(DocumentSuccess(response.resultado!.documentId));
      } else {
        final errorMessage = response.errorMessages?.join(', ') ?? 'Error desconocido';
        emit(DocumentFailure(errorMessage));
      }
    } catch(e) {
      emit(DocumentFailure("Error al crear el documento de solicitud: $e"));
    }

  }

  Future<void> _onCrearDocumentoTransferenciaStockFromSAP(CreateDocumentoTransferenciaStockFromSAP event, Emitter<DocumentoState> emit) async {
    emit(DocumentLoading());
    try {
      final response = await repository.crearDocumentoTransferenciaStockDesdeSap(event.docEntry);
      if(response.isSuccessful && response.resultado != null) {
        emit(DocumentSuccess(response.resultado!.documentId));
      } else {
        final errorMessage = response.errorMessages?.join(', ') ?? 'Error desconocido';
        emit(DocumentFailure(errorMessage));
      }
    } catch(e) {
      emit(DocumentFailure("Error al crear el documento de transferencia de stock: $e"));
    }

  }
  
  Future<void> _onGuardaConteoEnSapPorDocNum(SaveConteoForDocNumToSap event, Emitter<DocumentoState> emit) async {
    emit(DocumentLoading());
    try {
      final response = await repository.actualizarConteoDocumentoSap(event.docNum, event.tipoDocumento);
      if(response.isSuccessful){
        emit(SaveDocumentToSapSuccess(response.resultado!.message));
      } else {
        final errorMessage = response.errorMessages?.join(', ') ?? 'Error desconocido';
        emit(DocumentFailure(errorMessage));
      }
    } catch (e) {
      emit(DocumentFailure("Error al actualizar coteo en sap: $e"));
    }
  }

  Future<void> _onGuardaConteoTransferenciaStockEnSapPorDocNum(SaveConteoTransferenciaStockForDocEntryToSap event, Emitter<DocumentoState> emit) async {
    emit(DocumentLoading());
    try {
      final response = await repository.actualizarConteoDocumentoTransferenciaStockSap(event.docEntry, event.tipoDocumento);
      if(response.isSuccessful){
        emit(SaveDocumentToSapSuccess(response.resultado!.message));
      } else {
        final errorMessage = response.errorMessages?.join(', ') ?? 'Error desconocido';
        emit(DocumentFailure(errorMessage));
      }
    } catch (e) {
      emit(DocumentFailure("Error al actualizar coteo en sap: $e"));
    }
  }
}