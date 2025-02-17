import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:picking_app/bloc/bloc.dart';
import 'package:picking_app/models/almacen/almacen_model.dart';
import 'package:picking_app/models/conteo/conteo_request_model.dart';
import 'package:picking_app/utils/helpers/app_message_helper.dart';

class AgregarConteoScreen extends StatefulWidget {
  const AgregarConteoScreen({super.key});

  @override
  State<AgregarConteoScreen> createState() => _AgregarConteoScreenState();
}

class _AgregarConteoScreenState extends State<AgregarConteoScreen> {
  Almacen? almacenSeleccionado;
  TextEditingController controllerComentarios = TextEditingController();
  TextEditingController controllerAlmacen = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    cargarAlmacenes();
  }

  void cargarAlmacenes(){
    BlocProvider.of<AlmacenBloc>(context).add(LoadAlmacenesForUser());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuevo Conteo'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop(); // accion al presionar
          }, 
          icon: const Icon(Icons.close)
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controllerAlmacen,
                    minLines: 1,
                    maxLines: 5,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Almacen',
                      hintText: 'Seleccione un almacen',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10,),
                FloatingActionButton.extended(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  onPressed: () async {
                    final result = await context.push<Almacen>('/seleccionaralmacen', extra: almacenSeleccionado ?? Almacen());
                    if(result != null){
                      almacenSeleccionado = result;
                      setState(() {
                        controllerAlmacen.text = almacenSeleccionado!.nombre!;
                      });
                    }
                  }, 
                  label: const Text('Seleccionar'),
                  icon: const Icon(Icons.edit),
                )
              ],
            ),
            const SizedBox(height: 10,),
            TextFormField(
              controller: controllerComentarios,
              maxLength: 100,
              minLines: 1,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Comentarios',
                hintText: 'Escribe un comentario',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.text,
              
            ),
            const SizedBox(height: 10,),
            BlocConsumer<ConteoBloc, ConteoState>(
              listener: (context, state) {
                if(state is ConteoCreadoConExito){
                  AppMessageHelper.showAppMessage(context, 'Se creo correctamente el conteo para el almacen: ${almacenSeleccionado!.nombre}', MessageType.success);
                  context.pop(true);
                } else if(state is ConteoError){
                  AppMessageHelper.showAppMessage(context, 'Ocurrió un error: ${state.mensaje}', MessageType.error);
                }
              },
              builder: (context, state) {
                if(state is ConteoCargando){
                  return const CircularProgressIndicator();
                } 
                return ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.tertiary,
                    foregroundColor: Theme.of(context).colorScheme.primary,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                    )
                  ),
                  onPressed: () {
                    final conteo = ConteoRequest();
                    if(almacenSeleccionado == null){
                      AppMessageHelper.showAppMessage(context, 'Es necesario que seleccione un almacen!', MessageType.error);
                    } else if(controllerComentarios.text.isEmpty){
                      AppMessageHelper.showAppMessage(context, 'El campo comentario es requerido', MessageType.error);
                    } 
                    else {
                      if(almacenSeleccionado != null && controllerComentarios.text.isNotEmpty){
                        conteo.codigoAlmacen = almacenSeleccionado!.codigo;
                        conteo.comentarios = controllerComentarios.text;
                        context.read<ConteoBloc>().add(CrearConteo(conteo));
                      }
                    }
                  }, 
                  icon: const Icon(Icons.save_outlined),
                  label: const Text('CREAR CONTEO'),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}