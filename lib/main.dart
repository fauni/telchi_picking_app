import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:picking_app/bloc/common_bloc.dart';
import 'package:picking_app/config/app_colors.dart';
import 'package:picking_app/config/router/app_router.dart';
import 'package:picking_app/repository/auth_repository.dart';
import 'package:picking_app/repository/documento_repository.dart';
import 'package:picking_app/repository/orden_venta_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  final authRepository = AuthRepository();
  final ordenVentaRepository = OrdenVentaRepository();
  final documentoRepository = DocumentoRepository();
  final commonBloc = CommonBloc();
  commonBloc.init(authRepository, ordenVentaRepository, documentoRepository);

  runApp(MyApp(commonBloc: commonBloc));
}

class MyApp extends StatelessWidget {
  final CommonBloc commonBloc;

  const MyApp({super.key, required this.commonBloc});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: commonBloc.blocProviders,
      child: MaterialApp.router(
        title: 'Picking Facil',
        debugShowCheckedModeBanner: false,
        routerConfig: appRouter,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            primary: AppColors.primaryBlue,
            secondary: AppColors.secondaryBlue,
            tertiary: AppColors.primaryYellow
          ),
          useMaterial3: true,
        ),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('es'), // Español
          Locale('en'), // Inglés
        ],
        locale: const Locale('es'), // Fija el idioma en español
      ),
    );
  }
}