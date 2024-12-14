
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picking_app/bloc/bloc.dart';
import 'package:picking_app/repository/auth_repository.dart';
import 'package:picking_app/repository/conteo_repository.dart';
import 'package:picking_app/repository/detalle_conteo_repository.dart';
import 'package:picking_app/repository/detalle_documento_repository.dart';
import 'package:picking_app/repository/documento_repository.dart';
import 'package:picking_app/repository/factura_compra_repository.dart';
import 'package:picking_app/repository/factura_repository.dart';
import 'package:picking_app/repository/orden_venta_repository.dart';

class CommonBloc {
  // Instancia del AuthBloc
  static final AuthBloc authBloc = AuthBloc(AuthRepository())..add(CheckAuthEvent());
  static final OrdenVentaBloc ordenVentaBloc = OrdenVentaBloc(OrdenVentaRepository(), FacturaRepository(), FacturaCompraRepository());
  static final DetalleOrdenVentaBloc detalleOrdenVentaBloc = DetalleOrdenVentaBloc(OrdenVentaRepository(), FacturaRepository(), FacturaCompraRepository());
  static final DocumentoBloc documentoBloc = DocumentoBloc(DocumentoRepository());
  static final DetalleDocumentoBloc detalleDocumentoBloc = DetalleDocumentoBloc(detalleDocumentoRepository: DetalleDocumentoRepository());
  static final ConteoBloc conteoBloc = ConteoBloc(ConteoRepository());
  static final DetalleConteoBloc detalleConteoBloc = DetalleConteoBloc(DetalleConteoRepository());


  // Lista de BlocProviders para proveer a toda la aplicación
  static final List<BlocProvider> blocProviders = [
    BlocProvider<AuthBloc>(create: (context) => authBloc),
    BlocProvider<OrdenVentaBloc>(create: (context) => ordenVentaBloc,),
    BlocProvider<DetalleOrdenVentaBloc>(create: (context) => detalleOrdenVentaBloc,),
    BlocProvider<DocumentoBloc>(create: (context) => documentoBloc,),
    BlocProvider<DetalleDocumentoBloc>(create: (context) => detalleDocumentoBloc,),
    BlocProvider<ConteoBloc>(create: (context)=>conteoBloc),
    BlocProvider<DetalleConteoBloc>(create: (context) => detalleConteoBloc,)
  ];

  // Método para cerrar el bloc cuando no se necesite más
  static void dispose(){
    authBloc.close();
    ordenVentaBloc.close();
    detalleDocumentoBloc.close();
    documentoBloc.close();
    detalleDocumentoBloc.close();
    conteoBloc.close();
    detalleConteoBloc.close();
  }
  
  static final CommonBloc _instance = CommonBloc._internal();

  factory CommonBloc(){
    return _instance;
  }

  CommonBloc._internal();
}