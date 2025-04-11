import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:picking_app/bloc/auth_bloc/auth_bloc.dart';
import 'package:picking_app/bloc/auth_bloc/auth_event.dart';
import 'package:picking_app/bloc/auth_bloc/auth_state.dart';
import 'package:picking_app/ui/conteo/agregar_conteo_screen.dart';
import 'package:picking_app/ui/widgets/custom_button_home.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();    
  }

  void _abrirAgregarConteo() async {
    final resultado = await Navigator.of(context).push(
      PageRouteBuilder(
        opaque: true,
        barrierDismissible: true,
        pageBuilder: (context, animation, secondaryAnimation) {
          return AgregarConteoScreen();
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.ease;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(position: animation.drive(tween), child: child,);
          // return FadeTransition(opacity: animation, child: child,);
        },

      )
    );

    if(resultado != null){
      setState(() {
        print(resultado);
      });
    }
  }

  Future<void> playSound(int id) async {
    // await _audioCache.play('audio/scan.mp3');
    try {
      if (id == 0) {
        await _audioPlayer.play(AssetSource('sounds/incorrecto.mp3'));
      } else if(id == 1){
        await _audioPlayer.play(AssetSource('sounds/correcto.mp3'));
      } else {
        await _audioPlayer.play(AssetSource('sounds/complete.mp3'));
      }
    } catch (e) {
      print('Error al reproducir el sonido: $e');
    }
  }

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
            // IconButton(onPressed: ()async{
            //   await playSound(2);
            // }, icon: const Icon(Icons.error),),
            // IconButton(onPressed: ()async{
            //   await playSound(1);
            // }, icon: const Icon(Icons.one_k),),
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
              // CustomButtonHome(
              //   icon: Icons.show_chart,
              //   title: 'DASHBOARD',
              //   onPressed: () {
                  
              //   },
              // ),
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
                onPressed: () {
                  context.push('/conteo');
                },
              ),
              // const SizedBox(
              //   height: 10,
              // ),
              // CustomButtonHome(
              //   icon: Icons.settings,
              //   title: 'CONFIGURACIONES',
              //   onPressed: () async {
              //     // _abrirAgregarConteo();
                  
              //   },
              // )
            ],
          )),
    );
  }
}
