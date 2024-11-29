import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picking_app/bloc/bloc.dart';
import 'package:picking_app/repository/factura_compra_repository.dart';
import 'package:picking_app/repository/factura_repository.dart';
import 'package:picking_app/repository/orden_venta_repository.dart';

class OrdenVentaBloc extends Bloc<OrdenVentaEvent, OrdenVentaState>{
  final OrdenVentaRepository repository;
  final FacturaRepository facturaRepository;
  final FacturaCompraRepository facturaCompraRepository;

  OrdenVentaBloc(this.repository, this.facturaRepository, this.facturaCompraRepository): super(OrdenVentaInicial()){
    on<ObtenerOrdenesVenta>(_onObtenerOrdenesVenta);
    on<ObtenerOrdenesVentaBySearch>(_onObtenerOrdenesVentaBySearch);
  }

  Future<void> _onObtenerOrdenesVenta(ObtenerOrdenesVenta event, Emitter<OrdenVentaState> emit) async {
    emit(OrdenVentaCargando());
    
    try {
      final response = event.tipoDocumento == 'orden_venta' 
        ? await repository.obtenerOrdenesDeVenta()
        : event.tipoDocumento == 'factura' ? await facturaRepository.obtenerFactura()
        : await  facturaCompraRepository.obtenerFacturaCompra();
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
      final response = event.tipoDocumento == 'orden_venta' ? await repository.obtenerOrdenesDeVentaBySearch(event.search)
        : event.tipoDocumento == 'factura' ? await facturaRepository.obtenerFacturaBySearch(event.search)
        : await facturaCompraRepository.obtenerFacturaBySearch(event.search);
      
      if(response.isSuccessful && response.resultado != null){
        emit(OrdenVentaCargada(response));
      } else {
        emit(OrdenVentaError(response.errorMessages?.join(', ') ?? 'Error desconocido'));
      }
    } catch (e) {
      emit(OrdenVentaError("Error al buscar los  datos: $e"));
    }
  }
}