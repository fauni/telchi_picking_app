
import 'package:date_format/date_format.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picking_app/bloc/bloc.dart';
import 'package:picking_app/repository/auth_repository.dart';
import 'package:picking_app/repository/detalle_documento_repository.dart';
import 'package:picking_app/repository/documento_repository.dart';
import 'package:picking_app/repository/orden_venta_repository.dart';

class CommonBloc {
  // Instancia singleton de CommonBloc
  static final CommonBloc _instance = CommonBloc._internal();

  // Constructor de fábrica para devolver la instancia singleton
  factory CommonBloc(){
    return _instance;
  }

  // Constructor privado
  CommonBloc._internal();

  // Instancia del AuthBloc
  late final AuthBloc authBloc;
  late final OrdenVentaBloc ordenVentaBloc;
  late final DocumentoBloc documentoBloc;
  late final DetalleDocumentoBloc detalleDocumentoBloc;

  // Métdo de inicialilzación para pasar el AuthRepository, para mayor flexibilidad
  void init(
    AuthRepository authRepository,
    OrdenVentaRepository ordenVentaRepository,
    DocumentoRepository documentoRepository,
    DetalleDocumentoRepository detalleDocumentoRepository
  ){
    authBloc = AuthBloc(authRepository);
    ordenVentaBloc = OrdenVentaBloc(ordenVentaRepository);
    documentoBloc = DocumentoBloc(documentoRepository);
    detalleDocumentoBloc = DetalleDocumentoBloc(detalleDocumentoRepository: detalleDocumentoRepository);
  }

  // Lista de BlocProviders para proveer a toda la aplicación
  List<BlocProvider> get blocProviders => [
    BlocProvider<AuthBloc>(create: (context) => authBloc),
    // Agrega otros BlocProviders aqui según lo necesites, sin duplicar AuthBloc
    BlocProvider<OrdenVentaBloc>(create: (context) => ordenVentaBloc,),
    BlocProvider<DocumentoBloc>(create: (context) => documentoBloc,),
    BlocProvider<DetalleDocumentoBloc>(create: (context) => detalleDocumentoBloc,)
  ];

  // Método para cerrar el bloc cuando no se necesite más
  void dispose(){
    authBloc.close();
    // Cerrar otros blocs aqui si es necesario
    ordenVentaBloc.close();
    documentoBloc.close();
    detalleDocumentoBloc.close();
  }
  
}