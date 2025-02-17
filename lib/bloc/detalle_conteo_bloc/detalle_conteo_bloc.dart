import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picking_app/bloc/bloc.dart';
import 'package:picking_app/repository/detalle_conteo_repository.dart';

class DetalleConteoBloc extends Bloc<DetalleConteoEvent, DetalleConteoState>{
  final DetalleConteoRepository detalleConteoRepository;

  DetalleConteoBloc(this.detalleConteoRepository) : super(DetalleConteoInitial()){
    on<ObtenerDetalleConteoPorId>(_onObtenerDetalleConteoPorId);
    on<ActualizarCantidadDetalleConteo>(_onActualizarCantidad);
  }

  Future<void> _onObtenerDetalleConteoPorId(ObtenerDetalleConteoPorId event, Emitter<DetalleConteoState> emit) async {
    emit(DetalleConteoCargando());
    try {
      final response = await detalleConteoRepository.obtenerDetalleConteoPorId(event.id);
      if(response.isSuccessful && response.resultado != null){
        emit(DetalleConteoCargado(response));
      } else {
        emit(DetalleConteoError(
          response.statusCode, 
          response.errorMessages?.join(', ') ?? 'Error desconocido')
        );
      }
    } catch (e) {
      emit(const DetalleConteoError(500, 'Error al cargar el detalle del conteo'));
    }
  }

  Future<void> _onActualizarCantidad(ActualizarCantidadDetalleConteo event, Emitter<DetalleConteoState> emit) async {
    emit(DetalleConteoCargando());
    try {
      final response = await detalleConteoRepository.actualizarCantidad(
        idDetalle: event.idDetalle, 
        cantidadAgregada: event.cantidadAgregada);
      if(response.isSuccessful){
        emit(DetalleActualizaCantidadSuccess(
          response.resultado ?? 'Cantidad actualizada exitosamente')
        );
      } else {
        emit(DetalleConteoError(
          response.statusCode, 
          response.errorMessages?.join(', ') ?? 'Error desconocido')
        );
      }
    } catch (e) {
      emit(DetalleConteoError(500, 'Error al actualizar: $e'));
    }
  }
}