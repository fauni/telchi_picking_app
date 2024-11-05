import 'package:go_router/go_router.dart';
import 'package:picking_app/ui/auth/login_screen.dart';
import 'package:picking_app/ui/main/home_screen.dart';

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
    )
  ]
);