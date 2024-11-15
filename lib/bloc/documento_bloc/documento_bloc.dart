import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picking_app/bloc/bloc.dart';
import 'package:picking_app/repository/documento_repository.dart';

class DocumentoBloc extends Bloc<DocumentoEvent, DocumentoState> {
  final DocumentoRepository repository;
  
  DocumentoBloc(this.repository): super(DocumentInitial()){
    on<CreateDocumentFromSAP>(_onCrearDocumentoFromSAP);
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
}