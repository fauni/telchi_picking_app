import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picking_app/bloc/bloc.dart';
import 'package:picking_app/models/conteo/conteo_model.dart';
import 'package:picking_app/models/conteo/detalle_conteo_model.dart';
import 'package:picking_app/ui/widgets/app_bar_widget.dart';
import 'package:picking_app/ui/widgets/buscador_orden_venta.dart';
import 'package:picking_app/ui/widgets/item_list_detalle_conteo.dart';
import 'package:picking_app/ui/widgets/not_found_information_widget.dart';

class DetalleConteoScreen extends StatefulWidget {
  const DetalleConteoScreen({super.key, required this.conteo});

  final Conteo conteo;

  @override
  State<DetalleConteoScreen> createState() => _DetalleConteoScreenState();
}

class _DetalleConteoScreenState extends State<DetalleConteoScreen> {
  TextEditingController controllerSearch = TextEditingController();

  @override
  void initState() {
    super.initState();
    cargarDetallesConteo();
  }

  void cargarDetallesConteo(){
    BlocProvider.of<DetalleConteoBloc>(context).add(ObtenerDetalleConteoPorId(widget.conteo.id!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(titulo: 'Almacen ${widget.conteo.codigoAlmacen}'),
      body: Column(
        children: [
          BuscadorOrdenVenta(
            textoHint: 'Escanear o ingresar codigo', 
            iconoBoton: Icons.qr_code_scanner, 
            controllerSearch: controllerSearch, 
            onSearch: () async {
              // TODO: Aqui esta el método para el qr falta completar
              if(Platform.isWindows){
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Esta funcionalidad solo esta disponible en dispositivos móviles',
                      style: TextStyle(fontSize: 15),
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
              } else {
                // TODO: Aqui completar el metodo para escanear el codigo de barras
              }
            }, 
            onChanged: (p0) {setState(() {});},
            onSubmitted: (value) async {
              // TODO: Aqui esta el metodo para el boton que abre el dialog para agregar cantidad completar
            },
            onClearSearch: () {
              setState(() {
                controllerSearch.text = '';
              });
            },
          ),
          Expanded(
            child: BlocConsumer<DetalleConteoBloc, DetalleConteoState>(
              listener: (context, state) {
                
              },
              builder: (context, state) {
                if(state is DetalleConteoCargando){
                  return const Center(child: CircularProgressIndicator(),);
                } else if (state is DetalleConteoCargado){
                  return ListaDetalleConteo(
                    listaDetalleConteo: state.response.resultado!,
                    onItemTap: (p0) {
                      // TODO: Completar el método
                    },
                  );
                } else {
                  return NotFoundInformationWidget(
                    icono: Icons.error_outline, 
                    mensaje: 'No se encontraron registros', 
                    onPush: () {
                      cargarDetallesConteo();
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ListaDetalleConteo extends StatefulWidget {
  const ListaDetalleConteo({
    super.key, 
    required this.listaDetalleConteo,
    required this.onItemTap
  });
  final List<DetalleConteo> listaDetalleConteo;
  final Function(String) onItemTap;

  @override
  State<ListaDetalleConteo> createState() => _ListaDetalleConteoState();
}

class _ListaDetalleConteoState extends State<ListaDetalleConteo> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) {
        DetalleConteo detalleConteo = widget.listaDetalleConteo.elementAt(index);
        // TODO: Revisar el metodo onTap como funcionara
        return ItemListDetalleConteo(
          detalle: detalleConteo, 
          onTap: () => widget.onItemTap(detalleConteo.codigoItem!),
        );
      }, 
      separatorBuilder: (context, index) {
        return const Divider();
      }, 
      itemCount: widget.listaDetalleConteo.length
    );
  }
}