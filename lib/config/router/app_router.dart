import 'package:go_router/go_router.dart';
import 'package:picking_app/models/venta/resultado_orden_venta_model.dart';
import 'package:picking_app/ui/auth/login_screen.dart';
import 'package:picking_app/ui/main/home_screen.dart';
import 'package:picking_app/ui/picking/detalle_orden_venta_screen.dart';
import 'package:picking_app/ui/picking/tipo_documento_screen.dart';
import 'package:picking_app/ui/tipo_documento/buscar_orden_venta_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/Login',
  routes: [
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
  ]
);

