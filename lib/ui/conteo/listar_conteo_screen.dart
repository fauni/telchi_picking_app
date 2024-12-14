import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:picking_app/bloc/conteo_bloc/conteo_bloc.dart';
import 'package:picking_app/ui/widgets/app_bar_widget.dart';
import 'package:picking_app/ui/widgets/not_found_information_widget.dart';

import '../../bloc/bloc.dart';

class ListarConteoScreen extends StatefulWidget {
  const ListarConteoScreen({super.key});

  @override
  State<ListarConteoScreen> createState() => _ListarConteoScreenState();
}

class _ListarConteoScreenState extends State<ListarConteoScreen> {
  @override
  void initState() {
    super.initState();
    cargarConteos();
  }

  void cargarConteos() {
    BlocProvider.of<ConteoBloc>(context).add(const ObtenerConteosPorUsuario());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(titulo: 'Conteo de Inventario'),
      body: BlocConsumer<ConteoBloc, ConteoState>(
        listener: (context, state) {
          
        },
        builder: (context, state) {
          if(state is ConteoCargando){
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if(state is ConteoCargado){
            if(state.response.resultado!.isNotEmpty){
              return ListView.separated(
                itemBuilder: (context, index) {
                  final conteo = state.response.resultado![index];
                  return ListTile(
                    title: Text(conteo.fechaInicio.toString()),
                    subtitle: Text(conteo.codigoAlmacen!),
                    onTap: () {
                      context.push('/detalleconteo', extra: conteo);
                    },
                  );
                }, 
                separatorBuilder: (context, index) => const Divider(), 
                itemCount: state.response.resultado!.length);
            } else {
              return NotFoundInformationWidget(
                mensaje: 'No existen registros de conteo',
                icono: Icons.error_outline,
                onPush: () {
                  // cargarOrdenes();
                },
              );
            }
          } else {
            return NotFoundInformationWidget(
              mensaje: 'No se encontraron registros',
              icono: Icons.error_outline,
              onPush: () {
                cargarConteos();
              },
            );
          }
        },
      ),
    );
  }
}