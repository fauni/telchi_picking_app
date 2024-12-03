import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:picking_app/bloc/auth_bloc/auth_bloc.dart';
import 'package:picking_app/bloc/auth_bloc/auth_state.dart';
import 'package:picking_app/models/venta/resultado_orden_venta_model.dart';
import 'package:picking_app/ui/auth/login_screen.dart';
import 'package:picking_app/ui/main/home_screen.dart';
import 'package:picking_app/ui/main/initial_screen.dart';
import 'package:picking_app/ui/picking/detalle_orden_venta_screen.dart';
import 'package:picking_app/ui/picking/tipo_documento_screen.dart';
import 'package:picking_app/ui/tipo_documento/buscar_orden_venta_screen.dart';
import 'package:picking_app/utils/go_router_refresh_notifier.dart';


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
        path: '/detalleordenventa/:tipoDocumento',
        builder: (context, state) {
          ResultadoOrdenVentaModel data = state.extra as ResultadoOrdenVentaModel;
          final tipoDocumento = state.pathParameters['tipoDocumento'] ?? '';
          return DetalleOrdenVentaScreen(orden: data, tipoDocumento: tipoDocumento,);
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


