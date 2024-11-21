import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picking_app/bloc/bloc.dart';
import 'package:picking_app/repository/orden_venta_repository.dart';

class OrdenVentaBloc extends Bloc<OrdenVentaEvent, OrdenVentaState>{
  final OrdenVentaRepository repository;

  OrdenVentaBloc(this.repository): super(OrdenVentaInicial()){
    print('Iniciando Orden Venta Bloc');
    on<ObtenerOrdenesVenta>(_onObtenerOrdenesVenta);
    on<ObtenerOrdenesVentaBySearch>(_onObtenerOrdenesVentaBySearch);
  }

  Future<void> _onObtenerOrdenesVenta(ObtenerOrdenesVenta event, Emitter<OrdenVentaState> emit) async {
    emit(OrdenVentaCargando());
    
    try {
      final response = await repository.obtenerOrdenesDeVenta();
      if(response.isSuccessful && response.resultado != null){
        emit(OrdenVentaCargada(response));
      } else {
        emit(OrdenVentaError(response.errorMessages?.join(', ') ?? 'Error desconocido'));
      }      
    } catch (e) {
      emit(OrdenVentaError("Error al cargar las órdenes de venta: $e"));
    }
  }

  Future<void> _onObtenerOrdenesVentaBySearch(ObtenerOrdenesVentaBySearch event, Emitter<OrdenVentaState> emit) async {
    emit(OrdenVentaCargando());
    try {
      final response = await repository.obtenerOrdenesDeVentaBySearch(event.search);
      
      if(response.isSuccessful && response.resultado != null){
        emit(OrdenVentaCargada(response));
      } else {
        emit(OrdenVentaError(response.errorMessages?.join(', ') ?? 'Error desconocido'));
      }
    } catch (e) {
      emit(OrdenVentaError("Error al buscar las órdenes de venta: $e"));
    }
  }

  // Método para manejar el evento de obtener una orden de venta específica por docNum
  Future<void> _onObtenerOrdenVentaPorDocNum(
      ObtenerOrdenVentaByDocNum event, Emitter<OrdenVentaState> emit) async {
    emit(OrdenVentaCargando()); // Emitir estado de carga

    try {
      final response = await repository.obtenerOrdenVentaPorDocNum(event.docNum);

      if (response.isSuccessful && response.resultado != null) {
        emit(OrdenVentaPorDocNumCargada(response.resultado!)); // Emitir estado con la orden cargada
      } else {
        emit(OrdenVentaError(response.errorMessages?.first ?? 'Error al obtener la orden de venta'));
      }
    } catch (e) {
      emit(OrdenVentaError('Error al obtener la orden de venta: $e')); // Emitir estado de error en caso de excepción
    }
  }
}