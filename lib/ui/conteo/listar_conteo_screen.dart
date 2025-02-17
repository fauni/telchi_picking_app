import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:picking_app/ui/widgets/app_bar_widget.dart';
import 'package:picking_app/ui/widgets/crear_conteo_dialog.dart';
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

  void _mostrarDialogAgregarConteo(BuildContext context){
    showDialog(
      context: context, 
      builder: (context) {
        return const CrearConteoDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        titulo: 'Mis Conteos',
        icon: Icons.add,
        onPush: () async {
          await context.push('/agregarconteo');
        },
      ),
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
                  return Container(
                    padding: const EdgeInsets.all(5),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: conteo.estado == 'Completado' 
                          ? Colors.green[300]
                          : conteo.estado == 'En Proceso' ? Colors.yellow[600] : Colors.grey[300],
                          child: Text('${index + 1 }'),
                        ),
                        const SizedBox(width: 10,),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                formatDate(conteo.fechaInicio!, [dd,'-', mm,'-',yyyy,' ',HH, ':', nn,':', ss]),
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.primary
                                ),
                              ),
                              Text(
                                conteo.comentarios!,
                                style: Theme.of(context).textTheme.bodySmall
                              ),
                              Text(conteo.codigoAlmacen!)
                            ],
                          )
                        ),
                        const SizedBox(width: 10,),
                        IconButton(
                          onPressed: () {
                            context.push('/detalleconteo', extra: conteo);
                          }, 
                          icon: const Icon(Icons.arrow_forward_ios)
                        )
                      ],
                    ),
                  );
                  // return ListTile(
                  //   title: Text(conteo.fechaInicio.toString()),
                  //   subtitle: Text(conteo.codigoAlmacen!),
                  //   onTap: () {
                  //     context.push('/detalleconteo', extra: conteo);
                  //   },
                  // );
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