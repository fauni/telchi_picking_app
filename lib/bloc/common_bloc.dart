
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picking_app/bloc/bloc.dart';
import 'package:picking_app/repository/auth_repository.dart';

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

  // Métdo de inicialilzación para pasar el AuthRepository, para mayor flexibilidad
  void init(AuthRepository authRepository){
    authBloc = AuthBloc(authRepository);
  }

  // Lista de BlocProviders para proveer a toda la aplicación
  List<BlocProvider> get blocProviders => [
    BlocProvider<AuthBloc>(
      create: (context) => authBloc
    )
  ];

  // Método para cerrar el bloc cuando no se necesite más
  void dispose(){
    authBloc.close();
  }
  
}