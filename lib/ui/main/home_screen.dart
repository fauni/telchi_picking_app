import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:picking_app/bloc/auth_bloc/auth_bloc.dart';
import 'package:picking_app/bloc/auth_bloc/auth_event.dart';
import 'package:picking_app/bloc/auth_bloc/auth_state.dart';
import 'package:picking_app/ui/widgets/custom_button_home.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if(state is Unauthenticated){
          context.go('/login');
        }
      },
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(247, 247, 247, 1),
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.tertiary,
          title: const Text(''),
          // backgroundColor: Theme.of(context).colorScheme.tertiary,
          actions: [
            IconButton(onPressed: (){
              context.read<AuthBloc>().add(ChangeTokenSapEvent());
            }, icon: const Icon(Icons.change_circle),),
            IconButton(
                onPressed: () {
                  // Emite el evento de logout
                  context.read<AuthBloc>().add(LogoutEvent());
                },
                icon: Icon(Icons.logout, color: Theme.of(context).colorScheme.secondary,))
          ],
        ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Image.asset(
                  'assets/logos/telchi_logo.jpg',
                  width: 150,
                ),
              ),
              Image.asset('assets/logos/logo_piking_facil.png'),
              const SizedBox(
                height: 20,
              ),
              CustomButtonHome(
                icon: Icons.show_chart,
                title: 'DASHBOARD',
                onPressed: () {
                  
                },
              ),
              const SizedBox(
                height: 10,
              ),
              CustomButtonHome(
                icon: Icons.inventory,
                title: 'PICKING',
                onPressed: () {
                  context.push('/tipodocumento');
                },
              ),
              const SizedBox(
                height: 10,
              ),
              CustomButtonHome(
                icon: Icons.content_paste_outlined,
                title: 'CONTEO',
                onPressed: () {},
              ),
              const SizedBox(
                height: 10,
              ),
              CustomButtonHome(
                icon: Icons.settings,
                title: 'CONFIGURACIONES',
                onPressed: () {},
              )
            ],
          )),
    );
  }
}
