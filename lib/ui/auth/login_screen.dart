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
      appBar: AppBar(
        title: const Text('Login Screen'),
      ),
      body: Column(
        children: [
          TextField(
            controller: usernameController,
            decoration: const InputDecoration(labelText: "Username"),
          ),
          TextField(
            controller: passwordController,
            decoration: const InputDecoration(labelText: "Password"),
            obscureText: true,
          ),
          const SizedBox(height: 16,),
          BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if(state is AuthSuccess){
                context.go('/');
              } else if(state is AuthFailure){
                ScaffoldMessenger.of(context)
                  ..removeCurrentSnackBar()
                  ..showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
            builder: (context, state) {
              if(state is AuthLoading){
                return const Center(child: CircularProgressIndicator(),);
              }
              return ElevatedButton(
                onPressed: () {
                  // Dispara el evento de LoginRequested con los valores del formulario
                  context.read<AuthBloc>().add(LoginRequested(data: Login(username: usernameController.text, password: passwordController.text)));
                }, 
                child: const Text("Login")
              );
            }, 
          )
        ],
      )
    );
  }
}