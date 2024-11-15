import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picking_app/bloc/detalle_documento_bloc/detalle_documento_event.dart';
import 'package:picking_app/bloc/detalle_documento_bloc/detalle_documento_state.dart';
import 'package:picking_app/repository/detalle_documento_repository.dart';

class DetalleDocumentoBloc extends Bloc<DetalleDocumentoEvent, DetalleDocumentoState>{

  final DetalleDocumentoRepository detalleDocumentoRepository;

  DetalleDocumentoBloc({ required this.detalleDocumentoRepository })
    : super(DetalleDocumentoInitial()){
      on<ActualizarCantidadPorDetalle>(_onActualizarCantidad);
    }

    Future<void> _onActualizarCantidad(ActualizarCantidadPorDetalle event, Emitter<DetalleDocumentoState> emit) async {
      emit(DetalleDocumentoLoading());

      try {
        final response = await detalleDocumentoRepository.actualizarCantidad(
          idDetalle: event.idDetalle, 
          cantidadAgregada: event.cantidadAgregada
        );
        if(response.isSuccessful){
          emit(DetalleDocumentoSuccess(
            response.resultado ?? 'Cantidad actualizada exitosamente'
          ));
        } else {
          emit(DetalleDocumentoError(
            response.errorMessages?.join(', ') ?? 'Error desconocido'
          ));
        }
      } catch (e) {
        emit(DetalleDocumentoError('Error al actualizar: $e'));
      }
    }
}