import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picking_app/bloc/bloc.dart';
import 'package:picking_app/models/venta/resultado_orden_venta_model.dart';
import 'package:picking_app/ui/widgets/app_bar_widget.dart';
import 'package:picking_app/ui/widgets/buscador_orden_venta.dart';
import 'package:picking_app/ui/widgets/item_list_orden_venta.dart';
import 'package:picking_app/ui/widgets/not_found_information_widget.dart';

class BuscarOrdenVentaScreen extends StatefulWidget {
  const BuscarOrdenVentaScreen({super.key});

  @override
  State<BuscarOrdenVentaScreen> createState() => _BuscarOrdenVentaScreenState();
}

class _BuscarOrdenVentaScreenState extends State<BuscarOrdenVentaScreen> {
  DateTime? selectedDate;
  TextEditingController controllerSearch = TextEditingController();

  @override
  void initState() {
    super.initState();
    cargarOrdenes();
  }

  @override
  void dispose() {
    controllerSearch.dispose();
    super.dispose();
  }

  void cargarOrdenes() {
    BlocProvider.of<OrdenVentaBloc>(context).add(ObtenerOrdenesVenta());
  }

  void cargarOrdenesBySearch() {
    BlocProvider.of<OrdenVentaBloc>(context)
        .add(ObtenerOrdenesVentaBySearch(controllerSearch.text));
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      locale: const Locale("es", "ES"), // Configura el locale en español

    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        controllerSearch.text = "${picked.toLocal()}".split(' ')[0]; // Formato de fecha
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(247, 247, 247, 1), // const Color.fromARGB(255, 204, 216, 226),
      appBar: const AppBarWidget(titulo: 'Orden de Venta'),
      body: Column(
        children: [
          BuscadorOrdenVenta(
              textoHint: 'Buscar documento',
              iconoBoton: Icons.calendar_month_outlined,
              controllerSearch: controllerSearch,
              onSearch: () => _selectDate(context)
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton.icon(
              onPressed: () {controllerSearch.text.isNotEmpty 
                  ? cargarOrdenesBySearch()
                  : cargarOrdenes();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                foregroundColor: Colors.white,
                // padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              label: const Text("BUSCAR"),
              icon: const Icon(
                Icons.search,
                size: 30,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
              child: BlocConsumer<OrdenVentaBloc, OrdenVentaState>(
            listener: (context, state) {
              // if(state is PedidosPendientesUnauthorized){
              //   LoginDialogWidget.mostrarDialogLogin(context);
              // }
              // else if(state is PedidosPendientesNotLoaded){
              //   if(state.error.contains("UnauthorizedException")){
              //     LoginDialogWidget.mostrarDialogLogin(context);
              //   } else {
              //     ScaffoldMessenger.of(context).showSnackBar(
              //       const SnackBar(content: Text('Ocurrio un problema al obtener los Pedidos'), backgroundColor: Colors.red,)
              //     );
              //   }
              // }
            },
            builder: (context, state) {
              if (state is OrdenVentaCargando) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is OrdenVentaCargada) {
                return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ListaDocumentosOrdenVenta(ordenes: state.response.resultado!));
              } else {
                return NotFoundInformationWidget(
                  mensaje: 'No se encontraron registros',
                  onPush: () {
                    cargarOrdenes();
                  },
                );
              }
            },
            // child: ListaDocumentosOrdenVenta(ordenes: const []))
          ))
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class ListaDocumentosOrdenVenta extends StatelessWidget {
  ListaDocumentosOrdenVenta({super.key, required this.ordenes});

  List<ResultadoOrdenVentaModel> ordenes;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        shrinkWrap: true,
        itemBuilder: (context, index) {
          ResultadoOrdenVentaModel orden = ordenes[index];
          return Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3),
              decoration: BoxDecoration(
                  color: Colors.white,// color: Theme.of(context).colorScheme.,
                  borderRadius: BorderRadius.circular(10)),
              child: ItemListOrdenVenta(
                orden: orden,
                status: 'Pendiente',
              ));
        },
        separatorBuilder: (context, index) {
          return const SizedBox(
            height: 5,
          );
        },
        itemCount: ordenes.length);
  }
}
