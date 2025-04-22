
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picking_app/bloc/bloc.dart';
import 'package:picking_app/repository/auth_repository.dart';
import 'package:picking_app/repository/conteo_repository.dart';
import 'package:picking_app/repository/delivery_repository.dart';
import 'package:picking_app/repository/detalle_conteo_repository.dart';
import 'package:picking_app/repository/detalle_documento_repository.dart';
import 'package:picking_app/repository/documento_repository.dart';
import 'package:picking_app/repository/factura_compra_repository.dart';
import 'package:picking_app/repository/factura_repository.dart';
import 'package:picking_app/repository/orden_compra_repository.dart';
import 'package:picking_app/repository/orden_venta_repository.dart';
import 'package:picking_app/repository/reporte_repository.dart';
import 'package:picking_app/repository/reporte_transferecia_stock_repository.dart';
import 'package:picking_app/repository/solicitud_traslado_repository.dart';
import 'package:picking_app/repository/transferencia_stock_repository.dart';

class CommonBloc {
  // Instancia del AuthBloc
  static final AuthBloc authBloc = AuthBloc(AuthRepository())..add(CheckAuthEvent());
  static final OrdenVentaBloc ordenVentaBloc = OrdenVentaBloc(OrdenVentaRepository(), FacturaRepository(), FacturaCompraRepository(), DeliveryRepository(), OrdenCompraRepository());
  static final DetalleOrdenVentaBloc detalleOrdenVentaBloc = DetalleOrdenVentaBloc(OrdenVentaRepository(), FacturaRepository(), FacturaCompraRepository());
  static final DocumentoBloc documentoBloc = DocumentoBloc(DocumentoRepository());
  static final DetalleDocumentoBloc detalleDocumentoBloc = DetalleDocumentoBloc(detalleDocumentoRepository: DetalleDocumentoRepository());
  static final ReiniciaDetalleDocumentoBloc reiniciarDetalleDocumentoBloc = ReiniciaDetalleDocumentoBloc(detalleDocumentoRepository: DetalleDocumentoRepository());
  static final ConteoBloc conteoBloc = ConteoBloc(ConteoRepository());
  static final DetalleConteoBloc detalleConteoBloc = DetalleConteoBloc(DetalleConteoRepository());
  static final ReiniciarDetalleConteoBloc reiniciarDetalleConteoBloc = ReiniciarDetalleConteoBloc(DetalleConteoRepository());
  static final AlmacenBloc almacenBloc = AlmacenBloc(AuthRepository());
  static final SolicitudTrasladoBloc solicitudTrasladoBloc = SolicitudTrasladoBloc(SolicitudTrasladoRepository());
  static final DetalleSolicitudTrasladoBloc detalleSolicitudTrasladoBloc = DetalleSolicitudTrasladoBloc(SolicitudTrasladoRepository());
  static final TransferenciaStockBloc transferenciaStockBloc = TransferenciaStockBloc(TransferenciaStockRepository());
  static final DetalleTransferenciaStockBloc detalleTransferenciaStockBloc = DetalleTransferenciaStockBloc(TransferenciaStockRepository());
  static final ReporteBloc reporteBloc = ReporteBloc(reporteRepository: ReporteRepository());
  static final ReporteTransferenciaStockBloc reporteTransferenciaStockBloc = ReporteTransferenciaStockBloc(reporteRepository: ReporteTransfereciaStockRepository());


  // Lista de BlocProviders para proveer a toda la aplicación
  static final List<BlocProvider> blocProviders = [
    BlocProvider<AuthBloc>(create: (context) => authBloc),
    BlocProvider<OrdenVentaBloc>(create: (context) => ordenVentaBloc,),
    BlocProvider<DetalleOrdenVentaBloc>(create: (context) => detalleOrdenVentaBloc,),
    BlocProvider<DocumentoBloc>(create: (context) => documentoBloc,),
    BlocProvider<DetalleDocumentoBloc>(create: (context) => detalleDocumentoBloc,),
    BlocProvider<ReiniciaDetalleDocumentoBloc>(create: (context) => reiniciarDetalleDocumentoBloc,),
    BlocProvider<ConteoBloc>(create: (context)=>conteoBloc),
    BlocProvider<DetalleConteoBloc>(create: (context) => detalleConteoBloc,),
    BlocProvider<ReiniciarDetalleConteoBloc>(create: (context) => reiniciarDetalleConteoBloc),
    BlocProvider<AlmacenBloc>(create: (context) => almacenBloc),
    BlocProvider<SolicitudTrasladoBloc>(create: (context) => solicitudTrasladoBloc),
    BlocProvider<DetalleSolicitudTrasladoBloc>(create: (context) => detalleSolicitudTrasladoBloc),
    BlocProvider<TransferenciaStockBloc>(create: (context) => transferenciaStockBloc),
    BlocProvider<DetalleTransferenciaStockBloc>(create: (context) => detalleTransferenciaStockBloc),
    BlocProvider<ReporteBloc>(create: (context) => reporteBloc),
    BlocProvider<ReporteTransferenciaStockBloc>(create: (context) => reporteTransferenciaStockBloc),
  ];

  // Método para cerrar el bloc cuando no se necesite más
  static void dispose(){
    authBloc.close();
    ordenVentaBloc.close();
    detalleDocumentoBloc.close();
    documentoBloc.close();
    detalleDocumentoBloc.close();
    reiniciarDetalleDocumentoBloc.close();
    conteoBloc.close();
    detalleConteoBloc.close();
    reiniciarDetalleConteoBloc.close();
    almacenBloc.close();
    solicitudTrasladoBloc.close();
    detalleSolicitudTrasladoBloc.close();
    transferenciaStockBloc.close();
    detalleTransferenciaStockBloc.close();
    reporteBloc.close();
    reporteTransferenciaStockBloc.close();
  }
  
  static final CommonBloc _instance = CommonBloc._internal();

  factory CommonBloc(){
    return _instance;
  }

  CommonBloc._internal();
}