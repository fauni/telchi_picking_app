import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:picking_app/models/almacen/almacen_model.dart';
import 'package:picking_app/models/conteo/conteo_model.dart';
import 'package:picking_app/models/traslado/resultado_solicitud_traslado.dart';
import 'package:picking_app/models/venta/resultado_orden_venta_model.dart';
import 'package:picking_app/ui/almacen/seleccionar_almacen_screen.dart';
import 'package:picking_app/ui/auth/login_screen.dart';
import 'package:picking_app/ui/conteo/agregar_conteo_screen.dart';
import 'package:picking_app/ui/conteo/detalle_conteo_screen.dart';
import 'package:picking_app/ui/conteo/listar_conteo_screen.dart';
import 'package:picking_app/ui/main/home_screen.dart';
import 'package:picking_app/ui/main/initial_screen.dart';
import 'package:picking_app/ui/picking/detalle_orden_venta_screen.dart';
import 'package:picking_app/ui/picking/tipo_documento_screen.dart';
import 'package:picking_app/ui/solicitud_traslado/detalle_solicitud_traslado_screen.dart';
import 'package:picking_app/ui/solicitud_traslado/lista_solicitud_traslado_screen.dart';
import 'package:picking_app/ui/tipo_documento/buscar_orden_venta_screen.dart';
import 'package:picking_app/utils/go_router_refresh_notifier.dart';

import '../../bloc/bloc.dart';


GoRouter createAppRouter(BuildContext context){
  return GoRouter(
    initialLocation: '/initial',
    refreshListenable: GoRouterRefreshNotifier(
      context.read<AuthBloc>().stream, // Escucha el stream del AuthBloc
    ),
    routes: [
      GoRoute(
        path: '/initial',
        builder: (context, state) => const InitialScreen(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/Login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/tipodocumento',
        builder: (context, state) => const TipoDocumentoScreen(),
      ),
      GoRoute(
        path: '/ordenventa',
        builder: (context, state) {
          String tipoDocumento = state.extra as String;
          return BuscarOrdenVentaScreen(tipoDocumento: tipoDocumento,);
        } 
      ),
      GoRoute(
        path: '/solicitud-traslado',
        builder: (context, state) {
          return const ListaSolicitudTrasladoScreen();
        }
      ),
      GoRoute(
        path: '/conteo',
        builder: (context, state) {
          return const ListarConteoScreen();
        } 
      ),
      GoRoute(
        path: '/detalleconteo',
        pageBuilder: (context, state) {
          Conteo conteo = state.extra as Conteo;
          return CustomTransitionPage(
            child: DetalleConteoScreen(conteo: conteo), 
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              // Aqui definimos la transición de derecha a izquierda
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: Curves.easeInOut));
              return SlideTransition(position: animation.drive(tween), child: child,);
            }
          );
        },
      ),
      GoRoute(
        path: '/detalleordenventa/:tipoDocumento',
        builder: (context, state) {
          ResultadoOrdenVentaModel data = state.extra as ResultadoOrdenVentaModel;
          final tipoDocumento = state.pathParameters['tipoDocumento'] ?? '';
          return DetalleOrdenVentaScreen(orden: data, tipoDocumento: tipoDocumento,);
        },
      ),
      GoRoute(
        path: '/detallesolicitudtraslado',
        builder: (context, state) {
          SolicitudTraslado data = state.extra as SolicitudTraslado;
          return DetalleSolicitudTrasladoScreen(solicitud: data);
        },
      ),
      GoRoute(
        path: '/agregarconteo',
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            child: const AgregarConteoScreen(), 
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              // Aqui definimos la transición de derecha a izquierda
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: Curves.easeInOut));
              return SlideTransition(position: animation.drive(tween), child: child,);
            },
          );
        },
      ),
      GoRoute(
  path: '/seleccionaralmacen',
  pageBuilder: (context, state) {
    final almacen = state.extra as Almacen;

    return CustomTransitionPage(
      key: state.pageKey,
      child: SeleccionarAlmacenScreen(almacenSeleccionado: almacen,),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Definimos la transición para que la pantalla ascienda desde abajo
        const begin = Offset(0.0, 1.0); 
        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: Curves.easeInOut));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  },
)

    ],
    redirect: (context, state) {
      final authState = context.read<AuthBloc>().state;

      // Ruta inicial
      final loggingIn = state.uri.path == '/Login';
      final onInitial = state.uri.path == '/initial';

      if (authState is Unauthenticated && !loggingIn) {
        // Redirige al login si el usuario no está autenticado
        return '/Login';
      }

      if (authState is Authenticated && (onInitial || loggingIn)) {
        // Redirige al home si el usuario está autenticado y está en login o initial
        return '/';
      }

      // No redirige si ya está en la ruta correcta
      return null;
    }
  );
}


