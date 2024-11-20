
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picking_app/bloc/bloc.dart';
import 'package:picking_app/repository/auth_repository.dart';
import 'package:picking_app/repository/detalle_documento_repository.dart';
import 'package:picking_app/repository/documento_repository.dart';
import 'package:picking_app/repository/orden_venta_repository.dart';

class CommonBloc {
  // Instancia del AuthBloc
  static final AuthBloc authBloc = AuthBloc(AuthRepository());
  static final OrdenVentaBloc ordenVentaBloc = OrdenVentaBloc(OrdenVentaRepository());
  static final DocumentoBloc documentoBloc = DocumentoBloc(DocumentoRepository());
  static final DetalleDocumentoBloc detalleDocumentoBloc = DetalleDocumentoBloc(detalleDocumentoRepository: DetalleDocumentoRepository());


  // Lista de BlocProviders para proveer a toda la aplicación
  static final List<BlocProvider> blocProviders = [
    BlocProvider<AuthBloc>(create: (context) => authBloc),
    BlocProvider<OrdenVentaBloc>(create: (context) => ordenVentaBloc,),
    BlocProvider<DocumentoBloc>(create: (context) => documentoBloc,),
    BlocProvider<DetalleDocumentoBloc>(create: (context) => detalleDocumentoBloc,)
  ];

  // Método para cerrar el bloc cuando no se necesite más
  static void dispose(){
    authBloc.close();
    ordenVentaBloc.close();
    documentoBloc.close();
    detalleDocumentoBloc.close();
  }
  
  static final CommonBloc _instance = CommonBloc._internal();

  factory CommonBloc(){
    return _instance;
  }

  CommonBloc._internal();
}