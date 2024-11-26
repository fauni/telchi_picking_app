import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picking_app/bloc/bloc.dart';
import 'package:picking_app/repository/factura_repository.dart';
import 'package:picking_app/repository/orden_venta_repository.dart';

class DetalleOrdenVentaBloc extends Bloc<DetalleOrdenVentaEvent, DetalleOrdenVentaState>{
  final OrdenVentaRepository repository;
  final FacturaRepository facturaRepository;

  DetalleOrdenVentaBloc(this.repository, this.facturaRepository): super(DetalleOrdenVentaInicial()){
    on<ObtenerOrdenVentaByDocNum>(_onObtenerOrdenVentaPorDocNum);
  }

  // Método para manejar el evento de obtener una orden de venta específica por docNum
  Future<void> _onObtenerOrdenVentaPorDocNum(
      ObtenerOrdenVentaByDocNum event, Emitter<DetalleOrdenVentaState> emit) async {
    emit(DetalleOrdenVentaCargando()); // Emitir estado de carga

    try {
      final response = event.tipoDocumento == 'orden_venta' 
        ? await repository.obtenerOrdenVentaPorDocNum(event.docNum)
        : await facturaRepository.obtenerFacturaPorDocNum(event.docNum);

      if (response.isSuccessful && response.resultado != null) {
        emit(OrdenVentaPorDocNumCargada(response.resultado!)); // Emitir estado con la orden cargada
      } else {
        emit(DetalleOrdenVentaError(response.errorMessages?.first ?? 'Error al obtener la orden de venta'));
      }
    } catch (e) {
      emit(DetalleOrdenVentaError('Error al obtener la orden de venta: $e')); // Emitir estado de error en caso de excepción
    }
  }
}