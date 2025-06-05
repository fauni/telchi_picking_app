import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picking_app/bloc/bloc.dart';
import 'package:picking_app/repository/solicitud_traslado_repository.dart';

class DetalleSolicitudTrasladoBloc extends Bloc<DetalleSolicitudTrasladoEvent, DetalleSolicitudTrasladoState>{
  final SolicitudTrasladoRepository repository;

  DetalleSolicitudTrasladoBloc(this.repository): super(DetalleSolicitudTrasladoByIdInitial()){
    on<LoadSolicitudTrasladoById>(_onLoadSolicitudById);
  }
  // Método para manejar el evento de obtener una orden de venta específica por docNum
  Future<void> _onLoadSolicitudById(LoadSolicitudTrasladoById event, Emitter<DetalleSolicitudTrasladoState> emit) async {
     emit(DetalleSolicitudTrasladoByIdLoading()); // Emitir estado de carga

    try {
      final solicitudTraslado = await repository.obtenerSolicitudTrasladoPorId(event.id);
      if (!solicitudTraslado.isSuccessful){
        emit(UnauthorizedErrorSolicitudTraslado());
      } else {
        emit(DetalleSolicitudTrasladoByIdLoaded(solicitudTraslado: solicitudTraslado.resultado!));
      }
    } catch (e) {
      emit(DetalleSolicitudTrasladoByIdError(message: e.toString()));
    }
  }
}