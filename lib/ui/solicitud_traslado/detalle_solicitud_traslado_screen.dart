import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:picking_app/bloc/bloc.dart';
import 'package:picking_app/models/picking/documento_model.dart';
import 'package:picking_app/models/traslado/resultado_solicitud_traslado.dart';
import 'package:picking_app/ui/widgets/app_bar_widget.dart';
import 'package:picking_app/ui/widgets/buscador_orden_venta.dart';
import 'package:picking_app/ui/widgets/generic_dialog_loading.dart';
import 'package:picking_app/ui/widgets/item_detalle_widget.dart';
import 'package:picking_app/ui/widgets/item_list_detalle_solicitud_traslado.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

// ignore: must_be_immutable
class DetalleSolicitudTrasladoScreen extends StatefulWidget {
  DetalleSolicitudTrasladoScreen({
    super.key, required this.solicitud});
  SolicitudTraslado solicitud;

  @override
  State<DetalleSolicitudTrasladoScreen> createState() => _DetalleSolicitudTrasladoScreenState();
}

class _DetalleSolicitudTrasladoScreenState extends State<DetalleSolicitudTrasladoScreen> {
  TextEditingController controllerSearch = TextEditingController();

  final AudioPlayer _audioPlayer = AudioPlayer();
  List<String> estados = ['Todos', 'Pendiente', 'En Progreso', 'Completado'];
  String estadoSeleccionado = 'Todos';
  bool conteoIniciado = false;
  bool conteoFinalizado = false;

  @override
  void initState() {
    super.initState();
    validaEstadoConteo();
    refrescarSolicitud();
  }

  @override
  void dispose() {
    controllerSearch.dispose();
    super.dispose();
  }

  Future<void> playSound(int id) async {
    // await _audioCache.play('audio/scan.mp3');
    try {
      if (id == 0) {
        await _audioPlayer.play(AssetSource('sounds/incorrecto.mp3'));
      } else if(id == 1){
        await _audioPlayer.play(AssetSource('sounds/correcto.mp3'));
      } else {
        await _audioPlayer.play(AssetSource('sounds/complete.mp3'));
      }
    } catch (e) {
      print('Error al reproducir el sonido: $e');
    }
  }


  void validaEstadoConteo() {
    if (widget.solicitud.documento == null) {
      conteoIniciado = false;
      conteoFinalizado = false;
    } else {
      if (widget.solicitud.documento!.estadoConteo == 'F') {
        conteoIniciado = false;
        conteoFinalizado = true;
      } else {
        conteoIniciado = true;
        conteoFinalizado = false;
      }
    }
  }

  refrescarSolicitud(){
    context.read<DetalleSolicitudTrasladoBloc>().add(LoadSolicitudTrasladoById(
      id: widget.solicitud.docEntry!));
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
    widget.solicitud.documento?.detalles?.forEach((item) {
      if (item.estado == 'Completado') {
        totalCompletados++;
      }
    });
    if (widget.solicitud.documento!.detalles!.length == totalCompletados) {
      conteoFinalizado = true;
    } else {
      esCompletado = false;
    }
  }

  List<LineSolicitudTraslado> filtrarItemsPorEstado() {
    if(widget.solicitud.lines == null) return [];

    List<LineSolicitudTraslado> itemsFiltrados = widget.solicitud.lines!;
    if(controllerSearch.text.isEmpty){
      // Filtrar por estado
      if(estadoSeleccionado != 'Todos'){
        itemsFiltrados = itemsFiltrados.where((item) {
          return item.detalleDocumento!.estado!.toLowerCase() == estadoSeleccionado.toLowerCase();
        }).toList();
      }
      return itemsFiltrados;
    } else {
      // Filtrar por texto ingresado en el buscador
      final textoBusqueda = controllerSearch.text.toLowerCase();
      itemsFiltrados = itemsFiltrados.where((item) {
        return item.dscription!.toLowerCase().contains(textoBusqueda) || item.itemCode!.toLowerCase().contains(textoBusqueda);
      }).toList();
      return itemsFiltrados;
    }
  }

  List<LineSolicitudTraslado> obtenerDetalleOrdenPorDetalle(){
    List<LineSolicitudTraslado> detalleOrden = [];
    List<DetalleDocumento> detalles = filtrarItemsDetallesPorEstado();

    for(var d in detalles){
      final elemento = widget.solicitud.lines!.firstWhere(
          (e) => e.itemCode == d.codigoItem,
          orElse: () => LineSolicitudTraslado());
      if (elemento.itemCode != null) {
        detalleOrden.add(elemento);
      }
    }
    return detalleOrden;
  }

  List<DetalleDocumento> filtrarItemsDetallesPorEstado() {
    if (widget.solicitud.documento == null ||
        widget.solicitud.documento!.detalles == null) {
      return [];
    }
    // Mostrar todos los ítems si el filtro está en "Todos".
    if (estadoSeleccionado == 'Todos') {
      return widget.solicitud.documento!.detalles ?? [];
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
    final detalles = widget.solicitud.documento?.detalles ?? [];
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
          titulo: '${widget.solicitud.docNum}',
          icon: Icons.refresh,
          onPush: () {
            refrescarSolicitud();
          },
        ),
        body: BlocConsumer<DetalleSolicitudTrasladoBloc, DetalleSolicitudTrasladoState>(
          listener: (context, state) {
            if(state is DetalleSolicitudTrasladoByIdLoaded){
              widget.solicitud = state.solicitudTraslado;
              validaEstadoConteo();
            }
          },
          builder: (context, state) {
            if(state is DetalleSolicitudTrasladoByIdLoading){
              return const Center(child: CircularProgressIndicator(),);
            } else if (state is DetalleSolicitudTrasladoByIdLoaded){
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
                                  valor: 'Solicitud de Traslado'),
                              ItemDetalleWidget(
                                titulo: 'Número de Documento',
                                valor: widget.solicitud.docNum.toString(),
                              ),
                              ItemDetalleWidget(
                                titulo: 'De Almacén ',
                                valor: widget.solicitud.filler!,
                              ),
                              ItemDetalleWidget(
                                titulo: 'A Almacén ',
                                valor: widget.solicitud.toWhsCode!,
                              ),
                              ItemDetalleWidget(
                                  titulo: 'Fecha del Documento',
                                  valor: formatDate(widget.solicitud.docDate!,
                                    [dd, '-', mm, '-', yyyy]
                                  )
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 10),
                          child: Row(
                            children: [
                              FloatingActionButton.small(
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                foregroundColor: Colors.white,
                                onPressed: () async {
                                  final detalleEncontrado =
                                      widget.solicitud.lines!.firstWhere(
                                          (item) =>
                                              item.itemCode ==
                                              controllerSearch.text,
                                          orElse: () =>
                                              LineSolicitudTraslado());
                                  DetalleDocumento detalleConteoEncontrado =
                                      DetalleDocumento();
                                  if (widget.solicitud.documento != null) {
                                    detalleConteoEncontrado = widget
                                        .solicitud.documento!.detalles!
                                        .firstWhere(
                                            (item) =>
                                                item.codigoItem ==
                                                controllerSearch.text,
                                            orElse: () => DetalleDocumento());
                                  }

                                  if (detalleEncontrado.itemCode != null) {
                                    // Mostrar el diálogo si se encuentra el detalle
                                    if (conteoIniciado != true) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Es necesario que presiones INICIAR CONTEO',
                                            style: TextStyle(fontSize: 15),
                                          ),
                                          backgroundColor: Colors.blue,
                                        ),
                                      );
                                    } else {
                                      await playSound(1);
                                      // ignore: unused_local_variable
                                      final result =
                                          await _mostrarDialogoCantidad(
                                              context,
                                              detalleEncontrado,
                                              detalleConteoEncontrado);
                                      setState(() {
                                        // print(result);
                                        // estadoSeleccionado = 'En Progreso';
                                      });
                                    }
                                  } else {
                                    await playSound(0);
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
                                    onClearSearch: () {
                                      controllerSearch.text = '';
                                      setState(() {});
                                    },
                                    onChanged: (p0) {
                                      setState(() {});
                                    },
                                    onSubmitted: (value) async {
                                      final detalleEncontrado = widget
                                          .solicitud.lines!
                                          .firstWhere(
                                              (item) => item.itemCode == value,
                                              orElse: () =>
                                                  LineSolicitudTraslado());
                                      DetalleDocumento detalleConteoEncontrado =
                                          DetalleDocumento();
                                      if (widget.solicitud.documento != null) {
                                        detalleConteoEncontrado = widget
                                            .solicitud.documento!.detalles!
                                            .firstWhere(
                                                (item) =>
                                                    item.codigoItem == value,
                                                orElse: () =>
                                                    DetalleDocumento());
                                      }

                                      if (detalleEncontrado.itemCode != null) {
                                        // Mostrar el diálogo si se encuentra el detalle
                                        if (conteoIniciado != true) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
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
                                          await playSound(1);
                                          final result =
                                              await _mostrarDialogoCantidad(
                                                  context,
                                                  detalleEncontrado,
                                                  detalleConteoEncontrado);
                                          setState(() {
                                            // print(result);
                                            // estadoSeleccionado = 'En Progreso';
                                          });
                                        }
                                      } else {
                                        await playSound(0);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'El código $value no se encuentra en la lista.',
                                              style:
                                                  const TextStyle(fontSize: 15),
                                            ),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    },
                                    onSearch: () async {
                                      if (Platform.isWindows) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
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
                                              await SimpleBarcodeScanner
                                                  .scanBarcode(
                                            context,
                                            barcodeAppBar: const BarcodeAppBar(
                                                appBarTitle:
                                                    'Escanear codigo del Item',
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
                                            final detalleEncontrado = widget
                                                .solicitud.lines!
                                                .firstWhere(
                                              (item) => item.codeBars == res,
                                              orElse: () =>
                                                  LineSolicitudTraslado(),
                                            );

                                            final detalleConteoEncontrado =
                                                widget.solicitud.documento?.detalles
                                                    ?.firstWhere(
                                              (item) =>
                                                  item.codigoBarras == res,
                                              orElse: () => DetalleDocumento(),
                                            );

                                            // Verifica si el detalle fue encontrado
                                            if (detalleEncontrado.itemCode !=
                                                null) {
                                              await playSound(1);
                                              // Abre el diálogo para agregar cantidad
                                              _mostrarDialogoCantidad(
                                                  // ignore: use_build_context_synchronously
                                                  context,
                                                  detalleEncontrado,
                                                  detalleConteoEncontrado ??
                                                      DetalleDocumento());
                                            } else {
                                              await playSound(0);
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
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    'No se pudo leer el código de barras. Inténtelo nuevamente.'),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          }
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
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
                          child: ListaItemsDetalleSolicitudTraslado(
                            items: filtrarItemsPorEstado(),
                            onItemTap: (p0) async {
                              final detalleEncontrado = widget
                                  .solicitud.lines!
                                  .firstWhere((item) => item.itemCode == p0,
                                      orElse: () => LineSolicitudTraslado());
                              DetalleDocumento detalleConteoEncontrado =
                                  DetalleDocumento();
                              if (widget.solicitud.documento != null) {
                                detalleConteoEncontrado = widget
                                    .solicitud.documento!.detalles!
                                    .firstWhere((item) => item.codigoItem == p0,
                                        orElse: () => DetalleDocumento());
                              }

                              if (detalleEncontrado.itemCode != null) {
                                if (conteoIniciado == true || detalleEncontrado.detalleDocumento?.estado == 'Completado') {
                                  final result = await _mostrarDialogoCantidad(context, detalleEncontrado, detalleConteoEncontrado);
                                  setState(() {});
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
                            refrescarSolicitud();
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
                          if(state.error.contains("Invalid session")){
                            context.go('/login');
                          }
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
                                    // TODO: Aqui se guarda el conteo en SAP revisar
                                    context.read<DocumentoBloc>().add(
                                          SaveConteoForDocNumToSap(
                                              docNum: widget.solicitud.docNum
                                                  .toString(),
                                              tipoDocumento: 'solicitud_traslado'),
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
                                    // TODO: Aqui creamos el documento al iniciar conteo
                                    context.read<DocumentoBloc>().add(
                                        CreateDocumentoSolicitudFromSAP(
                                          docEntry: widget.solicitud.docEntry.toString()
                                        ));
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
            } else if(state is DetalleSolicitudTrasladoByIdError){
              return Center(
                child: Text(state.message),
              );
            } else {
              return const Center(child: CircularProgressIndicator(),);

            }
          },
        ),
      ),
    );
  }

  void _mostrarFiltrosEstado(BuildContext context){
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

  Future<void> _mostrarDialogoCantidad(BuildContext context, LineSolicitudTraslado detalle, DetalleDocumento detalleConteo) async {
    final TextEditingController cantidadController = TextEditingController();
    final TextEditingController fechaVencimientoController = TextEditingController();
    cantidadController.text = '1';
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Column(
            children: [Text(detalle.itemCode.toString()), const Divider()],
          ),
          content: SizedBox(
            height: 250,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text(detalle.itemCode.toString()),
                Text(
                  detalle.dscription!,
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
                    BlocBuilder<ReiniciaDetalleDocumentoBloc,
                        DetalleDocumentoState>(
                      builder: (context, state) {
                        if (state is DetalleDocumentoReiniciarCantidadSuccess) {
                          detalleConteo.cantidadContada = 0;
                        }
                        return Text(detalleConteo.cantidadContada.toString());
                      },
                    )
                    // Text((detalleConteo.cantidadContada!.toInt()).toString()),
                  ],
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: cantidadController,
                            keyboardType: TextInputType.number, // solo números
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d+(\.\d{0,4})?$')),
                            ],
                            decoration: const InputDecoration(
                              labelText: 'Ingresar cantidad:',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        FloatingActionButton.small(
                          backgroundColor: Colors.green,
                          onPressed: () {
                            final valor = cantidadController.text;
                            cantidadController.text =
                                (int.parse(valor) + 1).toString();
                          },
                          child: const Icon(Icons.add),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        FloatingActionButton.small(
                          backgroundColor: Colors.red,
                          onPressed: () {
                            final valor = cantidadController.text;
                            if (int.parse(valor) > 0) {
                              cantidadController.text =
                                  (int.parse(valor) - 1).toString();
                            }
                          },
                          child: const Icon(Icons.remove),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    // Agregarmos un input para seleccionar fecha
                    TextFormField(
                      controller: fechaVencimientoController,
                      decoration: const InputDecoration(
                        labelText: 'Fecha de vencimiento',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.calendar_today)
                      ),
                      readOnly: true,
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2030, 12, 31),
                          locale: const Locale("es", "ES"),
                        );
                        if (picked != null) {
                          setState(() {
                            fechaVencimientoController.text = "${picked.toLocal()}".split(' ')[0];
                          });
                          // fechaVencimientoController.text = DateFormat('yyyy-MM-dd').format(picked); // Formatea la fecha
                        }
                      },
                    )
                  ],
                ),
                detalle.quantity! > detalleConteo.cantidadContada!
                    ? const SizedBox()
                    : const Text(
                        'El conteo de este item ya fue completado.',
                        style: TextStyle(color: Colors.green),
                      )
              ],
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BlocConsumer<ReiniciaDetalleDocumentoBloc, DetalleDocumentoState>(
                  listener: (context, state) {
                    if(state is DetalleDocumentoReiniciado){
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Cantidad reiniciada exitosamente'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      refrescarSolicitud();
                    }
                  },
                  builder: (context, state) {
                    if (state is DetalleDocumentoReiniciado) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return SizedBox(
                      width: 30,
                      child: FloatingActionButton.small(
                        onPressed: () {
                          context.read<ReiniciaDetalleDocumentoBloc>().add(
                              ReiniciarCantidadPorDetalle(
                                  idDetalle: detalleConteo.idDetalle!,
                                  cantidadAgregada: 0));
                        },
                        child: const Icon(Icons.restart_alt),
                      ),
                    );
                  },
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton.icon(
                          onPressed: () {
                            Navigator.of(context)
                                .pop(true); // Cerrar el diálogo
                          },
                          icon: const Icon(Icons.close),
                          label: const Text('Volver'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.tertiary,
                            foregroundColor: Colors.white,
                            // padding: const EdgeInsets.symmetric(vertical: 16),
                            // minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5,),
                        BlocConsumer<DetalleDocumentoBloc,
                            DetalleDocumentoState>(listener: (context, state) {
                          if (state is DetalleDocumentoLoading) {
                            // GenericDialogLoading.show(context: context, message: 'Actualizando Cantidad');
                          } else if (state is DetalleDocumentoSuccess) {
                            if(detalle.quantity == (double.tryParse(cantidadController.text)! + detalleConteo.cantidadContada!)) {
                              playSound(2);
                            }
                            Navigator.of(context).pop(); // Cerrar el diálogo
                            refrescarSolicitud();
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
                          return ElevatedButton.icon(
                                  icon: const Icon(Icons.check),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).colorScheme.primary,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () {
                                    final cantidad = double.tryParse(
                                        cantidadController.text);
                                    if (cantidad == null || cantidad <= 0) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Ingrese una cantidad válida.'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                      return;
                                    } else if (cantidad +
                                            detalleConteo.cantidadContada! >
                                        detalle.quantity!) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'La cantidad ingresada mas la cantidad contada exceden a la cantidad esperada, no es permitida esta operación.'),
                                          backgroundColor: Colors.red,
                                          duration: Duration(seconds: 5),
                                        ),
                                      );
                                      return;
                                    }

                                    if(fechaVencimientoController.text.isEmpty){
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Por favor seleccione una fecha de vencimiento'), backgroundColor: Colors.red,));
                                      return;
                                    }

                                    // Aquí puedes realizar la lógica para agregar la cantidad
                                    context.read<DetalleDocumentoBloc>().add(
                                      ActualizarCantidadPorDetalle(
                                        idDetalle: detalleConteo.idDetalle!,
                                        cantidadAgregada: cantidad,
                                        fechaVencimiento: fechaVencimientoController.text
                                      ),
                                    );
                                  },
                                  label: const Text('Confirmar'),
                                );
                        }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

// ignore: must_be_immutable
class ListaItemsDetalleSolicitudTraslado extends StatefulWidget {
  ListaItemsDetalleSolicitudTraslado({
    super.key,
    required this.items,
    required this.onItemTap,
  });

  List<LineSolicitudTraslado> items;
  final Function(String) onItemTap;

  @override
  State<ListaItemsDetalleSolicitudTraslado> createState() =>
      _ListaItemsDetalleSolicitudTrasladoState();
}

class _ListaItemsDetalleSolicitudTrasladoState
    extends State<ListaItemsDetalleSolicitudTraslado> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        shrinkWrap: true,
        itemBuilder: (context, index) {
          LineSolicitudTraslado item = widget.items[index];
          return Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3),
              decoration: BoxDecoration(
                  color: Colors
                      .white, // color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(10)),
              child: ItemListDetalleSolicitudTraslado(
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