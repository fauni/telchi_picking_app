import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picking_app/bloc/bloc.dart';
import 'package:picking_app/repository/delivery_repository.dart';
import 'package:picking_app/repository/factura_compra_repository.dart';
import 'package:picking_app/repository/factura_repository.dart';
import 'package:picking_app/repository/orden_compra_repository.dart';
import 'package:picking_app/repository/orden_venta_repository.dart';

class OrdenVentaBloc extends Bloc<OrdenVentaEvent, OrdenVentaState>{
  final OrdenVentaRepository repository;
  final FacturaRepository facturaRepository;
  final FacturaCompraRepository facturaCompraRepository;
  final DeliveryRepository deliveryRepository;
  final OrdenCompraRepository ordenCompraRepository;

  OrdenVentaBloc(this.repository, this.facturaRepository, this.facturaCompraRepository, this.deliveryRepository, this.ordenCompraRepository): super(OrdenVentaInicial()){
    on<ObtenerOrdenesVenta>(_onObtenerOrdenesVenta);
    on<ObtenerOrdenesVentaBySearch>(_onObtenerOrdenesVentaBySearch);
  }

  Future<void> _onObtenerOrdenesVenta(ObtenerOrdenesVenta event, Emitter<OrdenVentaState> emit) async {
    emit(OrdenVentaCargando());
    
    try {
      final response = event.tipoDocumento == 'orden_venta' 
        ? await repository.obtenerOrdenesDeVenta()
        : event.tipoDocumento == 'factura' ? await facturaRepository.obtenerFactura()
        : event.tipoDocumento == 'factura_compra' ? await  facturaCompraRepository.obtenerFacturaCompra()
        : event.tipoDocumento == 'orden_compra' ? await ordenCompraRepository.obtenerOrdenCompra()
        : await deliveryRepository.obtenerEntrega(); // cuando es entrega
      if(response.isSuccessful && response.resultado != null){
        emit(OrdenVentaCargada(response));
      } else {
        emit(OrdenVentaError(response.statusCode, response.errorMessages?.join(', ') ?? 'Error desconocido'));
      }      
    } catch (e) {
      emit(OrdenVentaError(500, "${event.tipoDocumento}: Error al cargar los datos: $e"));
    }
  }

  Future<void> _onObtenerOrdenesVentaBySearch(ObtenerOrdenesVentaBySearch event, Emitter<OrdenVentaState> emit) async {
    emit(OrdenVentaCargando());
    try {
      final response = event.tipoDocumento == 'orden_venta' ? await repository.obtenerOrdenesDeVentaBySearch(event.search)
        : event.tipoDocumento == 'factura' ? await facturaRepository.obtenerFacturaBySearch(event.search)
        : event.tipoDocumento == 'factura_compra' ? await facturaCompraRepository.obtenerFacturaBySearch(event.search)
        : event.tipoDocumento == 'orden_compra' ? await ordenCompraRepository.obtenerOrdenCompraBySearch(event.search)
        : await deliveryRepository.obtenerEntregaBySearch(event.search); // cuando es entrega
      
      if(response.isSuccessful && response.resultado != null){
        emit(OrdenVentaCargada(response));
      } else {
        emit(OrdenVentaError(response.statusCode, response.errorMessages?.join(', ') ?? 'Error desconocido'));
      }
    } catch (e) {
      emit(OrdenVentaError(500, "Error al buscar los  datos: $e"));
    }
  }
}