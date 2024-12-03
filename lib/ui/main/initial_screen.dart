import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:picking_app/bloc/auth_bloc/auth_bloc.dart';
import 'package:picking_app/bloc/auth_bloc/auth_state.dart';

class InitialScreen extends StatelessWidget {
  const InitialScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          context.go('/Login');
        } else if (state is Authenticated) {
          context.go('/');
        }
      },
      child: Scaffold(
        body: Center(
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthChecking) {
                return const CircularProgressIndicator();
              }
              return const Text('Verificando autenticación...');
            },
          ),
        ),
      ),
    );
  }
}
