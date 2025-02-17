import 'dart:convert';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picking_app/bloc/bloc.dart';
import 'package:picking_app/models/conteo/conteo_model.dart';
import 'package:picking_app/models/conteo/detalle_conteo_model.dart';
import 'package:picking_app/ui/widgets/app_bar_widget.dart';
import 'package:picking_app/ui/widgets/buscador_orden_venta.dart';
import 'package:picking_app/ui/widgets/item_list_detalle_conteo.dart';
import 'package:picking_app/ui/widgets/not_found_information_widget.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class DetalleConteoScreen extends StatefulWidget {
  const DetalleConteoScreen({super.key, required this.conteo});

  final Conteo conteo;

  @override
  State<DetalleConteoScreen> createState() => _DetalleConteoScreenState();
}

class _DetalleConteoScreenState extends State<DetalleConteoScreen> {
  TextEditingController controllerSearch = TextEditingController();
  
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    cargarDetallesConteo();
  }

  void cargarDetallesConteo(){
    BlocProvider.of<DetalleConteoBloc>(context).add(ObtenerDetalleConteoPorId(widget.conteo.id!));
  }

  Future<void> playSound(int id) async {
    // await _audioCache.play('audio/scan.mp3');
    try {
      if(id == 0){
        await _audioPlayer.play(AssetSource('sounds/error.mp3'));
      } else {
        await _audioPlayer.play(AssetSource('sounds/success.mp3'));
      }
    } catch (e) {
      print('Error al reproducir el sonido: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        titulo: 'Almacen ${widget.conteo.codigoAlmacen}',
      ),
      body: Column(
        children: [
          BuscadorOrdenVenta(
            textoHint: 'Escanear o ingresar codigo', 
            iconoBoton: Icons.qr_code_scanner, 
            controllerSearch: controllerSearch, 
            onSearch: () async {
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
                String? res = await SimpleBarcodeScanner.scanBarcode(
                  context,
                  barcodeAppBar: const BarcodeAppBar(
                    appBarTitle: 'Escanear código de barras',
                    centerTitle: false,
                    enableBackButton: true,
                    backButtonIcon: Icon(Icons.arrow_back_ios)
                  ),
                  isShowFlashIcon: true,
                  delayMillis: 500,
                  cameraFace: CameraFace.back,
                  scanType: ScanType.barcode
                );
                setState(() {
                  controllerSearch.text = res ?? '';
                });
              }
            }, 
            onChanged: (p0) {setState(() {
              
            });},
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
                  // Obtener el texto de busqueda
                  String query = controllerSearch.text.toLowerCase();

                  // Filtrar la lista
                  List<DetalleConteo> listaFiltrada = state.response.resultado!.where((detalle) {
                    // Ajusta esta condición según tus necesidades de filtrado
                    return detalle.codigoItem!.toLowerCase().contains(query) ||
                          detalle.descripcionItem!.toLowerCase().contains(query) || detalle.codigoBarras!.toLowerCase().contains(query);
                  }).toList();

                  if(listaFiltrada.isEmpty) {
                    playSound(0);
                  }

                  return ListaDetalleConteo(
                    listaDetalleConteo: listaFiltrada,
                    onItemTap: (p0) async {
                      if(listaFiltrada.isEmpty){
                        await playSound(0);
                      }
                      await playSound(1);
                      final result = await _mostrarDialogoCantidad(context, p0);
                      if(result) cargarDetallesConteo();
                    },
                  );
                } else  {
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

Future<bool> _mostrarDialogoCantidad(BuildContext context, DetalleConteo detalle) async {
  final TextEditingController cantidadController = TextEditingController();
  cantidadController.text = '1';

  bool? result = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Column(
          children: [
            Text(detalle.codigoItem.toString()),
            const Divider()
          ],
        ),
        content: SizedBox(
          height: 250,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text(detalle.itemCode.toString()),
              Text(
                detalle.descripcionItem!,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Cantidad Esperada: ',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(detalle.cantidadDisponible.toString()),
                ],
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   children: [
              //     Text(
              //       'Cantidad Contada: ',
              //       style: Theme.of(context).textTheme.titleMedium,
              //     ),
              //     Text((detalle.cantidadContada!.toInt()).toString()),
              //   ],
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Cantidad Contada: ',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  // En algún lugar de tu widget, usa BlocBuilder para actualizar la UI
                  BlocBuilder<ReiniciarDetalleConteoBloc, DetalleConteoState>(
                    builder: (context, state) {
                      if (state is DetalleReiniciarCantidadSuccess) {
                        detalle.cantidadContada = 0;
                      }
                      return Text('${detalle.cantidadContada}');
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: cantidadController,
                      keyboardType: TextInputType.number, // solo números
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+(\.\d{0,2})?$')),
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Ingresar cantidad:',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10,),
                  FloatingActionButton.small(
                    backgroundColor: Colors.green,
                    onPressed: () {
                      final valor = cantidadController.text;
                      cantidadController.text = (int.parse(valor) + 1).toString();
                    },
                    child: const Icon(Icons.add),
                  ),
                  const SizedBox(width: 10,),
                  FloatingActionButton.small(
                    backgroundColor: Colors.red,
                    onPressed: () {
                      final valor = cantidadController.text;
                      if(int.parse(valor) > 0){
                        cantidadController.text = (int.parse(valor) - 1).toString();
                      }
                    },
                    child: const Icon(Icons.remove),
                  ),
                ],
              ),
              detalle.cantidadDisponible! > detalle.cantidadContada!
                ? const SizedBox()
                : const Text('El conteo de este item ya fue completado.', style: TextStyle(color: Colors.green),
              ),

              
            ],
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BlocConsumer<ReiniciarDetalleConteoBloc, DetalleConteoState>(
                listener: (context, state) {
                  // if(state is DetalleReiniciarCantidadSuccess){
                  //   detalle.cantidadContada = 0;
                  // }
                },
                builder: (context, state) {
                  if(state is DetalleContetoReiniciado){
                    return const Center(child: CircularProgressIndicator(),);
                  }
                  return Container(
                    width: 30,
                    child: FloatingActionButton.small(
                      onPressed: () {
                        context.read<ReiniciarDetalleConteoBloc>().add(ReiniciarCantidadDetalleConteo(
                          idDetalle: detalle.id!, 
                          cantidadAgregada: 0)
                        );
                      },
                      child: const Icon(Icons.restart_alt),
                    ),
                  );
                },
              ),
              Expanded(child: Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(true); // No se realizo la actualización
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.tertiary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ), 
                      child: const Text('Volver'),
                    ),
                    const SizedBox(width: 5,),
                    BlocConsumer<DetalleConteoBloc, DetalleConteoState>(
                      listener: (context, state) {
                        if(state is DetalleConteoCargando){
                
                        } else if(state is DetalleActualizaCantidadSuccess){
                          Navigator.of(context).pop(true); // Cerrar el diálogo                
                        } else if(state is DetalleConteoError){
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.mensaje),
                              backgroundColor: Colors.red,
                            )
                          );
                        }
                      },
                      builder: (context, state) {
                        if(state is DetalleConteoCargando){
                          return const CircularProgressIndicator();
                        }
                        // TODO: Despues de las pruebas habilidar esta opcion
                        // return detalle.cantidadDisponible == detalle.cantidadContada
                        // ? const SizedBox() 
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: (){
                            final cantidad = double.tryParse(cantidadController.text);
                            if(cantidad == null || cantidad <= 0){
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Ingrese una cantidad válida.'),
                                  backgroundColor: Colors.red,
                                )
                              );
                              return;
                            } else if (cantidad + detalle.cantidadContada! > detalle.cantidadDisponible!){
                              // TODO: Verificar esta validación si procede
                              // ScaffoldMessenger.of(context).showSnackBar(
                              //   const SnackBar(
                              //     content: Text('La cantidad ingresada mas la cantidad contada exceden a la cantidad esperada, no es permitida esta operación.'),
                              //     backgroundColor: Colors.red,
                              //     duration: Duration(seconds: 5),
                              //   ),
                              // );
                              // return;
                            }
                            context.read<DetalleConteoBloc>().add(ActualizarCantidadDetalleConteo(
                              idDetalle: detalle.id!, 
                              cantidadAgregada: cantidad)
                            );
                          }, 
                          child: const Text('Confirmar'),
                        );
                      }, 
                    ),
                  ],
                ),
              ))
            ],
          ),
        ],
      );
    },
  );
  return result ?? false;
}

class ListaDetalleConteo extends StatefulWidget {
  const ListaDetalleConteo({
    super.key, 
    required this.listaDetalleConteo,
    required this.onItemTap
  });
  final List<DetalleConteo> listaDetalleConteo;
  final Function(DetalleConteo) onItemTap;

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
          onTap: () => widget.onItemTap(detalleConteo),
        );
      }, 
      separatorBuilder: (context, index) {
        return const Divider();
      }, 
      itemCount: widget.listaDetalleConteo.length
    );
  }
}