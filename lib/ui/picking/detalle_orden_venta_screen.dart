import 'dart:io';

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

// ignore: must_be_immutable
class DetalleOrdenVentaScreen extends StatefulWidget {
  DetalleOrdenVentaScreen({super.key, required this.orden, required this.tipoDocumento});
  ResultadoOrdenVentaModel orden;
  String tipoDocumento;

  @override
  State<DetalleOrdenVentaScreen> createState() =>
      _DetalleOrdenVentaScreenState();
}

class _DetalleOrdenVentaScreenState extends State<DetalleOrdenVentaScreen> {
  TextEditingController controllerSearch = TextEditingController();

  List<String> estados = ['Todos', 'Pendiente', 'En Progreso', 'Completado'];
  String estadoSeleccionado = 'Todos';
  bool conteoIniciado = false;
  bool conteoFinalizado = false;

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
      conteoFinalizado = false;
    } else {
      if (widget.orden.documento!.estadoConteo == 'F') {
        conteoIniciado = false;
        conteoFinalizado = true;
      } else {
        conteoIniciado = true;
        conteoFinalizado = false;
      }
    }
  }

  void refrescarOrden() {
    context
        .read<DetalleOrdenVentaBloc>()
        .add(ObtenerOrdenVentaByDocNum(widget.orden.docNum.toString(), widget.tipoDocumento));
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
                Navigator.pop(context);
                Navigator.pop(context, false);
              },
            ),
          ],
        );
      },
    );
  }

  void verificaSiTodosCompletados() {
    // ignore: unused_local_variable
    bool esCompletado = true;
    int totalCompletados = 0;
    widget.orden.documento?.detalles?.forEach((item) {
      if (item.estado == 'Completado') {
        totalCompletados++;
      }
    });
    if (widget.orden.documento!.detalles!.length == totalCompletados) {
      conteoFinalizado = true;
    } else {
      esCompletado = false;
    }
  }

  List<DocumentLineOrdenVenta> filtrarItemsPorEstado() {
    if (widget.orden.documentLines == null) {
      return [];
    }

    List<DocumentLineOrdenVenta> itemsFiltrados = widget.orden.documentLines!;

    if(controllerSearch.text.isEmpty){
      // Filtrar por estado
      if (estadoSeleccionado != 'Todos') {
        itemsFiltrados = itemsFiltrados.where((item) {
          return item.detalleDocumento!.estado!.toLowerCase() == estadoSeleccionado.toLowerCase();
        }).toList();
      } 
      return itemsFiltrados;
    } else{
      // Filtrar por texto ingresado en el buscador
      final textoBusqueda = controllerSearch.text.toLowerCase();

      itemsFiltrados = itemsFiltrados.where((item) {
        return item.itemCode!.toLowerCase().contains(textoBusqueda) ||
            item.itemDescription!.toLowerCase().contains(textoBusqueda);
      }).toList();
      return itemsFiltrados;
    }
  }

  List<DocumentLineOrdenVenta> obtenerDetalleOrdenPorDetalle() {
    List<DocumentLineOrdenVenta> detalleOrden = [];
    List<DetalleDocumento> detalles = filtrarItemsDetallesPorEstado();
    for (var d in detalles) {
      final elemento = widget.orden.documentLines!.firstWhere(
          (e) => e.itemCode == d.codigoItem,
          orElse: () => DocumentLineOrdenVenta());
      if (elemento.itemCode != null) {
        detalleOrden.add(elemento);
      }
    }
    return detalleOrden;
  }

  List<DetalleDocumento> filtrarItemsDetallesPorEstado() {
    if (widget.orden.documento == null ||
        widget.orden.documento!.detalles == null) {
      return [];
    }
    // Mostrar todos los ítems si el filtro está en "Todos".
    if (estadoSeleccionado == 'Todos') {
      return widget.orden.documento!.detalles ?? [];
    }

    if (estadoSeleccionado == 'Pendientes') {
      return obtenerDetalleDocumentoPorEstado('Pendiente');
    }
    if (estadoSeleccionado == 'En Progreso') {
      return obtenerDetalleDocumentoPorEstado('En Progreso');
    }
    if (estadoSeleccionado == 'Completadas') {
      return obtenerDetalleDocumentoPorEstado('Completado');
    }
    return [];
  }

  List<DetalleDocumento> obtenerDetalleDocumentoPorEstado(String estado) {
    final detalles = widget.orden.documento?.detalles ?? [];
    List<DetalleDocumento> detallesFiltrados = [];

    for (var detalle in detalles) {
      // Depuración: puedes poner un punto de interrupción aquí
      if (detalle.estado == estado) {
        detallesFiltrados.add(detalle);
      }
    }

    return detallesFiltrados;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        _showBackDialog();
        // Aqui puedes mostrar un mensaje
      },
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(
            247, 247, 247, 1), //backgroundColor: Colors.blue[50],
        appBar: AppBarWidget(
          titulo: '${widget.orden.docNum}',
          icon: Icons.refresh,
          onPush: () {
            refrescarOrden();
          },
        ),
        body: BlocConsumer<DetalleOrdenVentaBloc, DetalleOrdenVentaState>(
          listener: (context, state) {
            if (state is OrdenVentaPorDocNumCargada) {
              setState(() {
                widget.orden = state.orden;
                validaEstadoConteo();
              });
            }
          },
          builder: (context, state) {
            if (state is DetalleOrdenVentaCargando) {
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
                              ItemDetalleWidget(
                                titulo: 'Tipo de Documento',
                                valor:  widget.tipoDocumento == 'orden_venta' ? 'Orden de Venta'
                                  : widget.tipoDocumento == 'factura' ? 'Factura de Venta'
                                  : 'Factura de Compra'
                              ),
                              ItemDetalleWidget(
                                titulo: 'Número de Documento',
                                valor: widget.orden.docNum.toString(),
                              ),
                              ItemDetalleColumnWidget(
                                titulo: 'Proveedor ',
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
                        Container(
                          padding: const EdgeInsets.only(left: 10),
                          child: Row(
                            children: [
                              FloatingActionButton.small(
                                backgroundColor: Theme.of(context).colorScheme.primary,
                                foregroundColor: Colors.white,
                                onPressed: () async {
                                  final detalleEncontrado = widget
                                      .orden.documentLines!
                                      .firstWhere((item) => item.itemCode == controllerSearch.text,
                                          orElse: () => DocumentLineOrdenVenta());
                                  DetalleDocumento detalleConteoEncontrado =
                                      DetalleDocumento();
                                  if (widget.orden.documento != null) {
                                    detalleConteoEncontrado = widget
                                        .orden.documento!.detalles!
                                        .firstWhere(
                                            (item) => item.codigoItem == controllerSearch.text,
                                            orElse: () => DetalleDocumento());
                                  }
                            
                                  if (detalleEncontrado.itemCode != null) {
                                    // Mostrar el diálogo si se encuentra el detalle
                                    if (conteoIniciado != true) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Es necesario que presiones INICIAR CONTEO',
                                            style: TextStyle(fontSize: 15),
                                          ),
                                          backgroundColor: Colors.blue,
                                        ),
                                      );
                                    } else {
                                      // ignore: unused_local_variable
                                      final result = await _mostrarDialogoCantidad(
                                          context,
                                          detalleEncontrado,
                                          detalleConteoEncontrado);
                                      setState(() {
                                        
                                        // print(result);
                                        // estadoSeleccionado = 'En Progreso';
                                      });
                                    }
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'El código ${controllerSearch.text} no se encuentra en la lista.',
                                          style: const TextStyle(fontSize: 15),
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                }, 
                                child: const Icon(Icons.input),
                              ),
                              Expanded(
                                child: BuscadorOrdenVenta(
                                    textoHint: 'Escanear o ingresar código',
                                    iconoBoton: Icons.qr_code_scanner,
                                    controllerSearch: controllerSearch,
                                    onChanged: (p0) {
                                      setState(() {
                                        
                                      });
                                    },
                                    onSubmitted: (value) async {
                                      final detalleEncontrado = widget
                                          .orden.documentLines!
                                          .firstWhere((item) => item.itemCode == value,
                                              orElse: () => DocumentLineOrdenVenta());
                                      DetalleDocumento detalleConteoEncontrado =
                                          DetalleDocumento();
                                      if (widget.orden.documento != null) {
                                        detalleConteoEncontrado = widget
                                            .orden.documento!.detalles!
                                            .firstWhere(
                                                (item) => item.codigoItem == value,
                                                orElse: () => DetalleDocumento());
                                      }
                                
                                      if (detalleEncontrado.itemCode != null) {
                                        // Mostrar el diálogo si se encuentra el detalle
                                        if (conteoIniciado != true) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Es necesario que presiones INICIAR CONTEO',
                                                style: TextStyle(fontSize: 15),
                                              ),
                                              backgroundColor: Colors.blue,
                                            ),
                                          );
                                        } else {
                                          // ignore: unused_local_variable
                                          final result = await _mostrarDialogoCantidad(
                                              context,
                                              detalleEncontrado,
                                              detalleConteoEncontrado);
                                          setState(() {
                                            // print(result);
                                            // estadoSeleccionado = 'En Progreso';
                                          });
                                        }
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'El código $value no se encuentra en la lista.',
                                              style: const TextStyle(fontSize: 15),
                                            ),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    },
                                    onSearch: () async {
                                      if (Platform.isWindows) {
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
                                        if (conteoIniciado) {
                                          String? res =
                                              await SimpleBarcodeScanner.scanBarcode(
                                            context,
                                            barcodeAppBar: const BarcodeAppBar(
                                                appBarTitle: 'Escanear codigo del Item',
                                                centerTitle: false,
                                                enableBackButton: true,
                                                backButtonIcon:
                                                    Icon(Icons.arrow_back_ios)),
                                            isShowFlashIcon: true,
                                            delayMillis: 2000,
                                            cameraFace: CameraFace.back,
                                          );
                                          // Si el resultado del escaneo no es nulo
                                          if (res != null && res.isNotEmpty) {
                                            final detalleEncontrado =
                                                widget.orden.documentLines!.firstWhere(
                                              (item) => item.barCode == res,
                                              orElse: () => DocumentLineOrdenVenta(),
                                            );
                                
                                            final detalleConteoEncontrado = widget
                                                .orden.documento?.detalles
                                                ?.firstWhere(
                                              (item) => item.codigoBarras == res,
                                              orElse: () => DetalleDocumento(),
                                            );
                                
                                            // Verifica si el detalle fue encontrado
                                            if (detalleEncontrado.itemCode != null) {
                                              // Abre el diálogo para agregar cantidad
                                              _mostrarDialogoCantidad(
                                                  // ignore: use_build_context_synchronously
                                                  context,
                                                  detalleEncontrado,
                                                  detalleConteoEncontrado ??
                                                      DetalleDocumento());
                                            } else {
                                              // Muestra un mensaje si el ítem no fue encontrado
                                              // ignore: use_build_context_synchronously
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      'El código $res no se encuentra en la lista.'),
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                            }
                                          } else {
                                            // Muestra un mensaje si el escaneo no produjo un resultado válido
                                            // ignore: use_build_context_synchronously
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    'No se pudo leer el código de barras. Inténtelo nuevamente.'),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          }
                                        } else {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Es necesario que presiones INICIAR CONTEO',
                                                style: TextStyle(fontSize: 15),
                                              ),
                                              backgroundColor: Colors.blue,
                                            ),
                                          );
                                        }
                                      }
                                
                                      setState(() {});
                                    }),
                              ),
                            ],
                          ),
                        ),
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
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .secondary,
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
                            items: filtrarItemsPorEstado(),
                            onItemTap: (p0) async {
                              final detalleEncontrado = widget
                                  .orden.documentLines!
                                  .firstWhere((item) => item.itemCode == p0,
                                      orElse: () => DocumentLineOrdenVenta());
                              DetalleDocumento detalleConteoEncontrado =
                                  DetalleDocumento();
                              if (widget.orden.documento != null) {
                                detalleConteoEncontrado = widget
                                    .orden.documento!.detalles!
                                    .firstWhere(
                                        (item) => item.codigoItem == p0,
                                        orElse: () => DetalleDocumento());
                              }
                        
                              if (detalleEncontrado.itemCode != null) {
                                // Mostrar el diálogo si se encuentra el detalle
                                if (conteoIniciado != true) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Es necesario que presiones INICIAR CONTEO',
                                        style: TextStyle(fontSize: 15),
                                      ),
                                      backgroundColor: Colors.blue,
                                    ),
                                  );
                                } else {
                                  // ignore: unused_local_variable
                                  final result = await _mostrarDialogoCantidad(
                                      context,
                                      detalleEncontrado,
                                      detalleConteoEncontrado);
                                  setState(() {
                                    // print(result);
                                    // estadoSeleccionado = 'En Progreso';
                                  });
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'El código $p0 no se encuentra en la lista.',
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
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
                              context: context, message: "Procesando...");
                        } else if (state is DocumentSuccess) {
                          // Cerrar el dialogo y mostrar el éxito
                          GenericDialogLoading.close();
                          setState(() {
                            conteoIniciado = true;
                            refrescarOrden();
                          });
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('Conteo iniciado con éxito,'),
                            backgroundColor: Colors.green,
                          ));
                        } else if (state is SaveDocumentToSapSuccess) {
                          GenericDialogLoading.close();
                          setState(() {
                            context.pop(true);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(state.message),
                            backgroundColor: Colors.green,
                          ));
                        } else if (state is DocumentFailure) {
                          // Cerrar el dialogo y mostrar el error
                          GenericDialogLoading.close();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Error: ${state.error}'),
                            backgroundColor: Colors.red,
                          ));
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
                          : conteoFinalizado
                              ? ElevatedButton.icon(
                                  onPressed: () async {
                                    context.read<DocumentoBloc>().add(
                                      SaveConteoForDocNumToSap(
                                        docNum: widget.orden.docNum.toString(),
                                        tipoDocumento: widget.tipoDocumento
                                      ),
                                    );
                                  },
                                  label: const Text('ENVIAR CONTEO A SAP'),
                                  icon: const Icon(
                                    Icons.send,
                                    size: 30,
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).colorScheme.primary,
                                    foregroundColor: Colors.white,
                                    // padding: const EdgeInsets.symmetric(vertical: 16),
                                    minimumSize:
                                        const Size(double.infinity, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                )
                              : ElevatedButton.icon(
                                  onPressed: () async {
                                    context.read<DocumentoBloc>().add(
                                        CreateDocumentFromSAP(
                                            docNum:
                                                widget.orden.docNum.toString(),
                                            tipoDocumento:
                                                widget.tipoDocumento));
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
                                    minimumSize:
                                        const Size(double.infinity, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                    ),
                  )
                ],
              );
            } else if (state is DetalleOrdenVentaError) {
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'FILTRAR POR ESTADO',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const Divider(),
              Expanded(
                child: ListView.separated(
                    separatorBuilder: (context, index) {
                      return const Divider();
                    },
                    itemCount: estados.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(estados[index]),
                        onTap: () {
                          setState(() {
                            estadoSeleccionado = estados[index];
                          });
                          Navigator.pop(context);
                        },
                      );
                    }),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _mostrarDialogoCantidad(BuildContext context,
      DocumentLineOrdenVenta detalle, DetalleDocumento detalleConteo) async {
    final TextEditingController cantidadController = TextEditingController();
    cantidadController.text = '1';
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Column(
            children: [
              Text(detalle.itemCode.toString()),
              const Divider()
            ],
          ),

          content: SizedBox(
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
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
                detalle.quantity! > detalleConteo.cantidadContada!
                  ? const SizedBox()
                  : const Text('El conteo de este item ya fue completado.', style: TextStyle(color: Colors.green),)
              ],
            ),
          ),
          actions: [
            TextButton.icon(
              onPressed: () {
                Navigator.of(context).pop(false); // Cerrar el diálogo
              },
              icon: const Icon(Icons.close),
              label: const Text('Volver'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.tertiary,
                foregroundColor: Colors.white,
                // padding: const EdgeInsets.symmetric(vertical: 16),
                // minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            BlocConsumer<DetalleDocumentoBloc, DetalleDocumentoState>(
                listener: (context, state) {
              if (state is DetalleDocumentoLoading) {
                // GenericDialogLoading.show(context: context, message: 'Actualizando Cantidad');
              } else if (state is DetalleDocumentoSuccess) {
                Navigator.of(context).pop(); // Cerrar el diálogo
                refrescarOrden();
              } else if (state is DetalleDocumentoError) {
                // Muestra un mensaje de error
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }, builder: (context, state) {
              if (state is DetalleDocumentoLoading) {
                return const CircularProgressIndicator();
              }
              return detalle.quantity! == detalleConteo.cantidadContada!
            ? const SizedBox():  ElevatedButton.icon(
                icon: const Icon(Icons.check),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  // padding: const EdgeInsets.symmetric(vertical: 16),
                  // minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  final cantidad = double.tryParse(cantidadController.text);
                  if (cantidad == null || cantidad <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Ingrese una cantidad válida.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  } else if (cantidad + detalleConteo.cantidadContada! > detalle.quantity!){
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('La cantidad ingresada mas la cantidad contada exceden a la cantidad esperada, no es permitida esta operación.'),
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 5),
                      ),
                    );
                    return;
                  }
                  // Aquí puedes realizar la lógica para agregar la cantidad
                  context.read<DetalleDocumentoBloc>().add(ActualizarCantidadPorDetalle(
                    idDetalle: detalleConteo.idDetalle!,
                    cantidadAgregada: cantidad),
                  );
                },
                label: const Text('Confirmar'),
              );
            }),
          ],
        );
      },
    );
  }
}


// ignore: must_be_immutable
class ListaItemsDetalleOrdenVenta extends StatefulWidget {
  ListaItemsDetalleOrdenVenta(
    {
      super.key, 
      required this.items, 
      required this.onItemTap,
    }
  );

  List<DocumentLineOrdenVenta> items;
  final Function(String) onItemTap;


  @override
  State<ListaItemsDetalleOrdenVenta> createState() => _ListaItemsDetalleOrdenVentaState();
}

class _ListaItemsDetalleOrdenVentaState extends State<ListaItemsDetalleOrdenVenta> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        shrinkWrap: true,
        itemBuilder: (context, index) {
          DocumentLineOrdenVenta item = widget.items[index];
          return Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3),
              decoration: BoxDecoration(
                  color: Colors
                      .white, // color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(10)),
              child: ItemListDetalleOrdenVenta(
                detalle: item,
                onTap: () => widget.onItemTap(item.itemCode!),
              ));
        },
        separatorBuilder: (context, index) {
          return const SizedBox(
            height: 5,
          );
        },
        itemCount: widget.items.length);
  }
}
