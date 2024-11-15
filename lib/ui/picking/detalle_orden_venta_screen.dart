import 'dart:convert';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:picking_app/bloc/bloc.dart';
import 'package:picking_app/models/picking/documento_model.dart';
import 'package:picking_app/models/venta/resultado_orden_venta_model.dart';
import 'package:picking_app/ui/widgets/app_bar_widget.dart';
import 'package:picking_app/ui/widgets/buscador_orden_venta.dart';
import 'package:picking_app/ui/widgets/generic_dialog_loading.dart';
import 'package:picking_app/ui/widgets/item_detalle_widget.dart';
import 'package:picking_app/ui/widgets/item_list_detalle_orden_venta.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class DetalleOrdenVentaScreen extends StatefulWidget {
  ResultadoOrdenVentaModel orden;
  DetalleOrdenVentaScreen({super.key, required this.orden});

  @override
  State<DetalleOrdenVentaScreen> createState() =>
      _DetalleOrdenVentaScreenState();
}

class _DetalleOrdenVentaScreenState extends State<DetalleOrdenVentaScreen> {
  TextEditingController controllerSearch = TextEditingController();

  List<String> estados = ['Todos', 'Completados', 'Pendientes', 'Incompletos'];
  String estadoSeleccionado = 'Todos';
  bool conteoIniciado = false;

  @override
  void initState() {
    super.initState();
    validaEstadoConteo();
    refrescarOrden();
  }

  @override
  void dispose() {
    controllerSearch.dispose();
    super.dispose();
  }

  void validaEstadoConteo() {
    if (widget.orden.documento == null) {
      conteoIniciado = false;
    } else {
      conteoIniciado = true;
    }
  }

  void refrescarOrden() {
    context
        .read<OrdenVentaBloc>()
        .add(ObtenerOrdenVentaByDocNum(widget.orden.docNum.toString()));
  }

  void _showBackDialog() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('¿Estas seguro?'),
          content: const Text(
            '¿Estas seguro que quieres salir de esta pagina',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Volver'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Salir'),
              onPressed: () {
                Navigator.pop(context, true);
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if(didPop){
          return;
        }
        _showBackDialog();
        // Aqui puedes mostrar un mensaje
      },
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(
            247, 247, 247, 1), //backgroundColor: Colors.blue[50],
        appBar: AppBarWidget(titulo: '${widget.orden.docNum}'),
        body: BlocConsumer<OrdenVentaBloc, OrdenVentaState>(
          listener: (context, state) {
            if (state is OrdenVentaPorDocNumCargada) {
              setState(() {
                widget.orden = state.orden;
              });
            }
          },
          builder: (context, state) {
            if (state is OrdenVentaCargando) {
              // Mostrar un indicador de carga mientras se carga la orden
              return const Center(child: CircularProgressIndicator());
            } else if (state is OrdenVentaPorDocNumCargada) {
              return Column(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 5),
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors
                                  .white // Theme.of(context).colorScheme.primary
                              ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const ItemDetalleWidget(
                                titulo: 'Tipo de Documento',
                                valor: 'Orden de Venta',
                              ),
                              ItemDetalleWidget(
                                titulo: 'Número de Documento',
                                valor: widget.orden.docNum.toString(),
                              ),
                              ItemDetalleColumnWidget(
                                titulo: 'Proveedor',
                                valor:
                                    '${widget.orden.cardCode} - ${widget.orden.cardName}',
                              ),
                              ItemDetalleWidget(
                                  titulo: 'Fecha del Documento',
                                  valor: formatDate(widget.orden.docDate!,
                                      [dd, '-', mm, '-', yyyy])),
                            ],
                          ),
                        ),
                        BuscadorOrdenVenta(
                            textoHint: 'Escanear o ingresar código',
                            iconoBoton: Icons.qr_code_scanner,
                            controllerSearch: controllerSearch,
                            onSubmitted: (value) {
                              final detalleEncontrado = widget
                                  .orden.documentLines!
                                  .firstWhere((item) => item.itemCode == value,
                                      orElse: () => DocumentLineOrdenVenta());
                              final detalleConteoEncontrado = widget
                                  .orden.documento!.detalles!
                                  .firstWhere((item) => item.codigoItem == value,
                                      orElse: () => DetalleDocumento());
      
                              if (detalleEncontrado.itemCode != null) {
                                // Mostrar el diálogo si se encuentra el detalle
                                _mostrarDialogoCantidad(context,
                                    detalleEncontrado, detalleConteoEncontrado);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'El código $value no se encuentra en la lista.')),
                                );
                              }
                            },
                            onSearch: () async {
                              String? res =
                                  await SimpleBarcodeScanner.scanBarcode(
                                context,
                                barcodeAppBar: const BarcodeAppBar(
                                    appBarTitle: 'Test',
                                    centerTitle: false,
                                    enableBackButton: true,
                                    backButtonIcon: Icon(Icons.arrow_back_ios)),
                                isShowFlashIcon: true,
                                delayMillis: 2000,
                                cameraFace: CameraFace.back,
                              );
      
                              // Si el resultado del escaneo no es nulo
                              if (res != null && res.isNotEmpty) {
                                final detalleEncontrado =
                                    widget.orden.documentLines!.firstWhere(
                                  (item) => item.itemCode == res,
                                  orElse: () => DocumentLineOrdenVenta(),
                                );
      
                                final detalleConteoEncontrado =
                                    widget.orden.documento?.detalles?.firstWhere(
                                  (item) => item.codigoItem == res,
                                  orElse: () => DetalleDocumento(),
                                );
      
                                // Verifica si el detalle fue encontrado
                                if (detalleEncontrado.itemCode != null) {
                                  // Abre el diálogo para agregar cantidad
                                  _mostrarDialogoCantidad(
                                      context,
                                      detalleEncontrado,
                                      detalleConteoEncontrado ??
                                          DetalleDocumento());
                                } else {
                                  // Muestra un mensaje si el ítem no fue encontrado
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'El código $res no se encuentra en la lista.'),
                                    ),
                                  );
                                }
                              } else {
                                // Muestra un mensaje si el escaneo no produjo un resultado válido
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'No se pudo leer el código de barras. Inténtelo nuevamente.'),
                                  ),
                                );
                              }
      
                              setState(() {});
                            }),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    const Text('Mostrando: '),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Chip(
                                      avatar: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                      ),
                                      label: Text(
                                        estadoSeleccionado,
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary),
                                      ),
                                      backgroundColor:
                                          Theme.of(context).colorScheme.secondary,
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    _mostrarFiltrosEstado(context);
                                  },
                                  icon: const Icon(Icons.filter_alt_outlined))
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Expanded(
                            child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: ListaItemsDetalleOrdenVenta(
                            items: widget.orden.documentLines!,
                            itemsConteo: widget.orden.documento == null
                                ? []
                                : widget.orden.documento!.detalles!,
                          ),
                        ))
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(5),
                    child: BlocListener<DocumentoBloc, DocumentoState>(
                      listener: (context, state) {
                        if (state is DocumentLoading) {
                          // Mostrar el dialogo de carga
                          GenericDialogLoading.show(
                              context: context, message: "Creando documento...");
                        } else if (state is DocumentSuccess) {
                          // Cerrar el dialogo y mostrar el éxito
                          GenericDialogLoading.close();
                          setState(() {
                            conteoIniciado = true;
                            refrescarOrden();
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Conteo iniciado con éxito,')));
                        } else if (state is DocumentFailure) {
                          // Cerrar el dialogo y mostrar el error
                          GenericDialogLoading.close();
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: ${state.error}')));
                        }
                      },
                      child: conteoIniciado
                          ? ElevatedButton.icon(
                              onPressed: () async {
                                context.pop(true);
                              },
                              label: const Text('GUARDAR Y SALIR'),
                              icon: const Icon(
                                Icons.pause,
                                size: 40,
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                // padding: const EdgeInsets.symmetric(vertical: 16),
                                minimumSize: const Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            )
                          : ElevatedButton.icon(
                              onPressed: () async {
                                context.read<DocumentoBloc>().add(
                                    CreateDocumentFromSAP(
                                        docNum: widget.orden.docNum.toString(),
                                        tipoDocumento: widget.orden.docType!));
                              },
                              label: const Text('INICIAR CONTEO'),
                              icon: const Icon(
                                Icons.play_arrow_outlined,
                                size: 40,
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                // padding: const EdgeInsets.symmetric(vertical: 16),
                                minimumSize: const Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                    ),
                  )
                ],
              );
            } else if (state is OrdenVentaError) {
              // Mostrar un mensaje de error si ocurre un problema
              return Center(child: Text('Error: ${state.mensaje}'));
            } else {
              // Estado inicial o cualquier otro estado
              return const Center(child: Text('Cargando...'));
            }
          },
        ),
      ),
    );
  }

  void _mostrarFiltrosEstado(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
              // color: Colors.red
              ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'FILTRAR',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const Divider(),
              Expanded(
                child: Wrap(
                  children: estados.map((estado) {
                    return ListTile(
                      title: Text(estado),
                      onTap: () {
                        setState(() {
                          estadoSeleccionado = estado;
                        });
                        Navigator.pop(context);
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _mostrarDialogoCantidad(BuildContext context,
      DocumentLineOrdenVenta detalle, DetalleDocumento detalleConteo) {
    final TextEditingController cantidadController = TextEditingController();
    cantidadController.text = '1';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(detalle.itemCode.toString()),
          content: SizedBox(
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Text(detalle.itemCode.toString()),
                Text(
                  detalle.itemDescription!,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Cantidad Esperada: ',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(detalle.quantity.toString()),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Cantidad Contada: ',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text((detalleConteo.cantidadContada!.toInt()).toString()),
                  ],
                ),
                TextField(
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
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: const Text('Cancelar'),
            ),
            BlocConsumer<DetalleDocumentoBloc, DetalleDocumentoState>(
                listener: (context, state) {
              if (state is DetalleDocumentoLoading) {
                // GenericDialogLoading.show(context: context, message: 'Actualizando Cantidad');
              } else if (state is DetalleDocumentoSuccess) {
                // Muestra un mejsaje de exito y cierra el dialog
                // ScaffoldMessenger.of(context).showSnackBar(
                //   SnackBar(content: Text(state.mensaje)),
                // );
                Navigator.of(context).pop(); // Cerrar el diálogo
                refrescarOrden();
              } else if (state is DetalleDocumentoError) {
                // Muestra un mensaje de error
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.error)),
                );
              }
            }, builder: (context, state) {
              if (state is DetalleDocumentoLoading) {
                return const CircularProgressIndicator();
              }
              return ElevatedButton(
                onPressed: () {
                  final cantidad = double.tryParse(cantidadController.text);
                  if (cantidad == null || cantidad <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Ingrese una cantidad válida.')),
                    );
                    return;
                  }

                  // Aquí puedes realizar la lógica para agregar la cantidad
                  context.read<DetalleDocumentoBloc>().add(
                      ActualizarCantidadPorDetalle(
                          idDetalle: detalleConteo.idDetalle!,
                          cantidadAgregada: cantidad));
                },
                child: const Text('Confirmar'),
              );
            }),
          ],
        );
      },
    );
  }
}

// ignore: must_be_immutable
class ListaItemsDetalleOrdenVenta extends StatelessWidget {
  ListaItemsDetalleOrdenVenta(
      {super.key, required this.items, required this.itemsConteo});

  List<DocumentLineOrdenVenta> items;
  List<DetalleDocumento> itemsConteo;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        shrinkWrap: true,
        itemBuilder: (context, index) {
          DocumentLineOrdenVenta item = items[index];
          DetalleDocumento itemConteo = DetalleDocumento();
          if (itemsConteo.isNotEmpty) {
            itemConteo = itemsConteo[index];
          }
          return Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3),
              decoration: BoxDecoration(
                  color: Colors
                      .white, // color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(10)),
              child: ItemListDetalleOrdenVenta(
                detalle: item,
                detalleConteo: itemsConteo.isNotEmpty ? itemConteo : DetalleDocumento(),
              ));
        },
        separatorBuilder: (context, index) {
          return const SizedBox(
            height: 5,
          );
        },
        itemCount: items.length);
  }
}
