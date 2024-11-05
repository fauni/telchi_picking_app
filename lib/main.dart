import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:picking_app/bloc/common_bloc.dart';
import 'package:picking_app/config/router/app_router.dart';
import 'package:picking_app/repository/auth_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  final authRepository = AuthRepository();
  final commonBloc = CommonBloc();
  commonBloc.init(authRepository);

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
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        )
      ),
    );
  }
}