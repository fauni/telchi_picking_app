import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picking_app/bloc/bloc.dart';
import 'package:picking_app/repository/transferencia_stock_repository.dart';

class DetalleTransferenciaStockBloc extends Bloc<DetalleTransferenciaStockEvent, DetalleTransferenciaStockState>{
  final TransferenciaStockRepository repository;

  DetalleTransferenciaStockBloc(this.repository): super(DetalleTransferenciaStockByIdLoading()){
    on<LoadTransferenciaStockById>(_onLoadTransferenciaStockById);
  }
  // Método para manejar el evento de obtener una orden de venta específica por docNum
  Future<void> _onLoadTransferenciaStockById(LoadTransferenciaStockById event, Emitter<DetalleTransferenciaStockState> emit) async {
     emit(DetalleTransferenciaStockByIdLoading()); // Emitir estado de carga

    try {
      final solicitudTraslado = await repository.obtenerTransferenciaStockPorId(event.id);
      if (!solicitudTraslado.isSuccessful){
        emit(UnauthorizedErrorTransferenciaStock());
      } else {
        emit(DetalleTransferenciaStockByIdLoaded(solicitudTraslado: solicitudTraslado.resultado!));
      }
    } catch (e) {
      emit(DetalleTransferenciaStockByIdError(message: e.toString()));
    }
  }
}