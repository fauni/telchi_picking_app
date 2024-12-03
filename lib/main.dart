import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:picking_app/bloc/common_bloc.dart';
import 'package:picking_app/config/app_colors.dart';
import 'package:picking_app/config/router/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: CommonBloc.blocProviders,
      child: Builder(
        builder: (context) {
          final router = createAppRouter(context);
          return MaterialApp.router(
            title: 'Picking Facil',
            debugShowCheckedModeBanner: false,
            routerConfig: router,
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
          );
        }
      ),
    );
  }
}