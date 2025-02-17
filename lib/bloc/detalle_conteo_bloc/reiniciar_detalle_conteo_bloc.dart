import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picking_app/bloc/bloc.dart';
import 'package:picking_app/repository/detalle_conteo_repository.dart';

class ReiniciarDetalleConteoBloc extends Bloc<DetalleConteoEvent, DetalleConteoState>{
  final DetalleConteoRepository detalleConteoRepository;

  ReiniciarDetalleConteoBloc(this.detalleConteoRepository) : super(DetalleConteoInitial()){
    on<ReiniciarCantidadDetalleConteo>(_onReiniciarCantidad);
  }

  Future<void> _onReiniciarCantidad(ReiniciarCantidadDetalleConteo event, Emitter<DetalleConteoState> emit) async {
    emit(DetalleContetoReiniciado());
    try {
      final response = await detalleConteoRepository.reiniciarCantidad(
        idDetalle: event.idDetalle, 
        cantidadAgregada: event.cantidadAgregada);
      if(response.isSuccessful){
        emit(DetalleReiniciarCantidadSuccess(
          response.resultado ?? 'Cantidad reiniciada exitosamente')
        );
        // Emitir un estado inicial después de un breve retraso
        await Future.delayed(const Duration(milliseconds: 100));
        emit(DetalleConteoInitial());
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