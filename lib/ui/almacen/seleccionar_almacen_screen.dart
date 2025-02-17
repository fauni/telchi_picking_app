import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:picking_app/models/almacen/almacen_model.dart';

import '../../bloc/bloc.dart';

class SeleccionarAlmacenScreen extends StatefulWidget {
  final Almacen almacenSeleccionado;
  const SeleccionarAlmacenScreen({super.key, required this.almacenSeleccionado});

  @override
  State<SeleccionarAlmacenScreen> createState() =>
      _SeleccionarAlmacenScreenState();
}

class _SeleccionarAlmacenScreenState extends State<SeleccionarAlmacenScreen> {
  Almacen? almacenSeleccionado;

  @override
  void initState() {
    super.initState();
    cargarAlmacenes();
  }

  void cargarAlmacenes() {
    BlocProvider.of<AlmacenBloc>(context).add(LoadAlmacenesForUser());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Almacenes'),
        actions: [
          TextButton(
            onPressed: () {
              context.pop(almacenSeleccionado);
            },
            child: const Text('Listo'),
          )
        ],
      ),
      body: Column(
        children: [
          widget.almacenSeleccionado == null
            ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              child: Text(
                'Ningún almacen esta seleccionado, seleccione uno por favor:',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.secondary)
              ),
            )
            : const SizedBox(),
          Expanded(
            child: BlocBuilder<AlmacenBloc, AlmacenState>(
              builder: (context, state) {
                if (state is AlmacenInitial || state is AlmacenLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is AlmacenesLoaded) {
                  final almacenes = state.almacenes;
                  if (almacenes.isEmpty) {
                    return const Text('No se encontraron almacenes');
                  }
                  return ListView.separated(
                    separatorBuilder: (context, index) {
                      return const Divider();
                    },
                    itemCount: almacenes.length,
                    itemBuilder: (context, index) {
                      Almacen almacen = almacenes.elementAt(index);
                      return ListTile(
                        tileColor: almacen.codigo == widget.almacenSeleccionado.codigo ? Colors.green[50]: Colors.transparent,
                        title: Text(almacen.nombre!),
                        subtitle: Text(almacen.codigo!),
                        onTap: () {
                          context.pop(almacen);
                        },
                      );
                    },
                  );
                } else if (state is AlmacenError) {
                  return Center(
                    child: Text('Error: ${state.message}'),
                  );
                } else {
                  return const Text('Estado desconocido');
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
