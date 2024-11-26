import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picking_app/bloc/bloc.dart';
import 'package:picking_app/repository/factura_repository.dart';
import 'package:picking_app/repository/orden_venta_repository.dart';

class OrdenVentaBloc extends Bloc<OrdenVentaEvent, OrdenVentaState>{
  final OrdenVentaRepository repository;
  final FacturaRepository facturaRepository;

  OrdenVentaBloc(this.repository, this.facturaRepository): super(OrdenVentaInicial()){
    on<ObtenerOrdenesVenta>(_onObtenerOrdenesVenta);
    on<ObtenerOrdenesVentaBySearch>(_onObtenerOrdenesVentaBySearch);
  }

  Future<void> _onObtenerOrdenesVenta(ObtenerOrdenesVenta event, Emitter<OrdenVentaState> emit) async {
    emit(OrdenVentaCargando());
    
    try {
      final response = event.tipoDocumento == 'orden_venta' 
        ? await repository.obtenerOrdenesDeVenta()
        : await facturaRepository.obtenerFactura();
      if(response.isSuccessful && response.resultado != null){
        emit(OrdenVentaCargada(response));
      } else {
        emit(OrdenVentaError(response.errorMessages?.join(', ') ?? 'Error desconocido'));
      }      
    } catch (e) {
      emit(OrdenVentaError("${event.tipoDocumento}: Error al cargar los datos: $e"));
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
}