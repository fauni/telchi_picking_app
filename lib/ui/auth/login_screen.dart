import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:picking_app/bloc/bloc.dart';
import 'package:picking_app/models/auth/login_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    usernameController.text = 'faruni';
    passwordController.text = 'Inbolsa1';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(247, 247, 247, 1),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sección superior con logo y título
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                // color: Theme.of(context).colorScheme.onPrimary,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/logos/telchi_logo_horizontal.jpg',
                        height: 150,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Bienvenido a:',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      child: Image.asset(
                        'assets/logos/logo_piking_facil.png',
                        height: 100,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Sección de campos de texto para nombre de usuario y contraseña
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        hintText: 'Ingrese su Nombre de Usuario',
                        hintStyle: TextStyle(color: Theme.of(context).colorScheme.tertiary),
                        filled: false,
                        fillColor: Theme.of(context).colorScheme.tertiary.withOpacity(0.1),
                        labelText: "Nombre de Usuario",
                        labelStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary)
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary)
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary)
                        )
                      ),
                      style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        hintText: 'Ingrese su Contraseña',
                        hintStyle: TextStyle(color: Theme.of(context).colorScheme.tertiary),
                        filled: false,
                        fillColor: Theme.of(context).colorScheme.tertiary.withOpacity(0.1),
                        labelText: "Contraseña",
                        labelStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary)
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary)
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary)
                        )
                      ),
                      style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),

              // Botón de inicio de sesión y BlocConsumer
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthSuccess) {
                      context.go('/');
                    } else if (state is AuthFailure) {
                      ScaffoldMessenger.of(context)
                        ..removeCurrentSnackBar()
                        ..showSnackBar(
                          SnackBar(content: Text(state.message)),
                        );
                    }
                  },
                  builder: (context, state) {
                    if (state is AuthLoading) {
                      return Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Theme.of(context).colorScheme.tertiary,
                        ),
                      );
                    }
                    return ElevatedButton.icon(                     
                      onPressed: () {
                        // Envía el evento de login con el modelo de datos
                        context.read<AuthBloc>().add(
                              LoginRequested(
                                data: Login(
                                  username: usernameController.text,
                                  password: passwordController.text,
                                ),
                              ),
                            );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        // padding: const EdgeInsets.symmetric(vertical: 16),
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      label: const Text("INICIAR SESIÓN"),
                      icon: const Icon(Icons.login),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
