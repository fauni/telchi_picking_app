import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:picking_app/bloc/bloc.dart';
import 'package:picking_app/models/venta/resultado_orden_venta_model.dart';
import 'package:picking_app/ui/widgets/app_bar_widget.dart';
import 'package:picking_app/ui/widgets/buscador_orden_venta.dart';
import 'package:picking_app/ui/widgets/generic_dialog_loading.dart';
import 'package:picking_app/ui/widgets/item_detalle_widget.dart';
import 'package:picking_app/ui/widgets/item_list_detalle_orden_venta.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class DetalleOrdenVentaScreen extends StatefulWidget {
  final ResultadoOrdenVentaModel orden;
  const DetalleOrdenVentaScreen({super.key, required this.orden});

  @override
  State<DetalleOrdenVentaScreen> createState() =>
      _DetalleOrdenVentaScreenState();
}

class _DetalleOrdenVentaScreenState extends State<DetalleOrdenVentaScreen> {
  TextEditingController controllerSearch = TextEditingController();

  List<String> estados = ['Todos','Completados', 'Pendientes', 'Incompletos'];
  String estadoSeleccionado = 'Todos';
  bool conteoIniciado = false;

  @override
  void initState() {
    super.initState();
    validaEstadoConteo();
  }

  @override
  void dispose() {
    controllerSearch.dispose();
    super.dispose();
  }

  void validaEstadoConteo(){
    if(widget.orden.documento == null){
      conteoIniciado = false;
    } else{
      conteoIniciado = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(247, 247, 247, 1), //backgroundColor: Colors.blue[50],
      appBar: AppBarWidget(titulo: '${widget.orden.docNum}'),
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color:
                          Colors.white // Theme.of(context).colorScheme.primary
                      ),
                  child: Column(
                    children: [
                      const ItemDetalleWidget(
                        titulo: 'Tipo de Documento',
                        valor: 'Orden de Venta',
                      ),
                      ItemDetalleWidget(
                        titulo: 'Número de Documento',
                        valor: widget.orden.docNum.toString(),
                      ),
                      ItemDetalleWidget(
                        titulo: 'Proveedor',
                        valor:
                            '${widget.orden.cardCode} - ${widget.orden.cardName}',
                      ),
                      ItemDetalleWidget(
                          titulo: 'Fecha del Documento',
                          valor: formatDate(
                              widget.orden.docDate!, [dd, '-', mm, '-', yyyy])),
                    ],
                  ),
                ),
                BuscadorOrdenVenta(
                    textoHint: 'Escanear o ingresar código',
                    iconoBoton: Icons.qr_code_scanner,
                    controllerSearch: controllerSearch,
                    onSearch: ()async {
                      String? res = await SimpleBarcodeScanner.scanBarcode(
                        context,
                        barcodeAppBar: const BarcodeAppBar(
                          appBarTitle: 'Test',
                          centerTitle: false,
                          enableBackButton: true,
                          backButtonIcon: Icon(Icons.arrow_back_ios)
                        ),
                        isShowFlashIcon: true,
                        delayMillis: 2000,
                        cameraFace: CameraFace.front,
                      );
                      setState(() {
                        // result = res as String;
                      });
                    }),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            const Text('Mostrando: '),
                            const SizedBox(width: 10,),
                            Chip(
                              avatar: const Icon(Icons.close, color: Colors.white,),
                              label: Text(estadoSeleccionado, style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),),
                              backgroundColor: Theme.of(context).colorScheme.secondary,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          _mostrarFiltrosEstado(context);
                        }, 
                        icon: const Icon(Icons.filter_alt_outlined)
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 5,),
                Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: ListaItemsDetalleOrdenVenta(
                                        items: widget.orden.documentLines!,
                                      ),
                    ))
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(5),
            child: BlocListener<DocumentoBloc, DocumentoState>(
              listener: (context, state) {
                if(state is DocumentLoading){
                  // Mostrar el dialogo de carga
                  GenericDialogLoading.show(context: context, message: "Creando documento...");
                } else if (state is DocumentSuccess){
                  // Cerrar el dialogo y mostrar el éxito
                  GenericDialogLoading.close();
                  setState(() {
                    conteoIniciado = true;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Conteo iniciado con éxito,'))
                  );
                } else if(state is DocumentFailure){
                  // Cerrar el dialogo y mostrar el error
                  GenericDialogLoading.close();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${state.error}'))
                  );
                }
              },
              child: conteoIniciado 
              ? ElevatedButton.icon(
                onPressed: () async {
                  context.pop();
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
                  context.read<DocumentoBloc>().add(CreateDocumentFromSAP(docNum: widget.orden.docNum.toString(), tipoDocumento: widget.orden.docType!));
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
              const Text('FILTRAR', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
              const Divider(),
              Expanded(
                child: Wrap(
                  children: estados.map((estado) {
                    return ListTile(
                      title: Text(estado),
                      onTap: (){
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
}



// ignore: must_be_immutable
class ListaItemsDetalleOrdenVenta extends StatelessWidget {
  ListaItemsDetalleOrdenVenta({super.key, required this.items});

  List<DocumentLineOrdenVenta> items;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        shrinkWrap: true,
        itemBuilder: (context, index) {
          DocumentLineOrdenVenta item = items[index];
          return Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3),
              decoration: BoxDecoration(
                  color: Colors.white,// color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(10)),
              child: ItemListDetalleOrdenVenta(detalle: item));
        },
        separatorBuilder: (context, index) {
          return const SizedBox(
            height: 5,
          );
        },
        itemCount: items.length);
  }
}
