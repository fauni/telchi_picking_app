import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picking_app/bloc/detalle_documento_bloc/detalle_documento_event.dart';
import 'package:picking_app/bloc/detalle_documento_bloc/detalle_documento_state.dart';
import 'package:picking_app/repository/detalle_documento_repository.dart';

class ReiniciaDetalleDocumentoBloc extends Bloc<DetalleDocumentoEvent, DetalleDocumentoState>{

  final DetalleDocumentoRepository detalleDocumentoRepository;

  ReiniciaDetalleDocumentoBloc({ required this.detalleDocumentoRepository })
    : super(DetalleDocumentoInitial()){
      on<ReiniciarCantidadPorDetalle>(_onReiniciarCantidad);
    }

    Future<void> _onReiniciarCantidad(ReiniciarCantidadPorDetalle event, Emitter<DetalleDocumentoState> emit) async {
      emit(DetalleDocumentoReiniciado());

      try {
        final response = await detalleDocumentoRepository.reiniciarCantidad(
          idDetalle: event.idDetalle, 
          cantidadAgregada: event.cantidadAgregada
        );
        if(response.isSuccessful){
          emit(DetalleDocumentoReiniciarCantidadSuccess(
            response.resultado ?? 'Cantidad reiniciada exitosamente'
          ));

          // Emitir un estado inicial después de un breve retraso
          await Future.delayed(const Duration(milliseconds: 100));
          emit(DetalleDocumentoInitial());
        } else {
          emit(DetalleDocumentoError(
            response.errorMessages?.join(', ') ?? 'Error desconocido'
          ));
        }
      } catch (e) {
        emit(DetalleDocumentoError('Error al reiniciar: $e'));
      }
    }
}