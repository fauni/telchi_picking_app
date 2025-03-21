import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:picking_app/bloc/bloc.dart';
import 'package:picking_app/models/venta/resultado_orden_venta_model.dart';
import 'package:picking_app/ui/widgets/app_bar_widget.dart';
import 'package:picking_app/ui/widgets/buscador_orden_venta.dart';
import 'package:picking_app/ui/widgets/item_list_orden_venta.dart';
import 'package:picking_app/ui/widgets/not_found_information_widget.dart';

class BuscarOrdenVentaScreen extends StatefulWidget {
  const BuscarOrdenVentaScreen({super.key, required this.tipoDocumento});

  final String tipoDocumento;
  @override
  State<BuscarOrdenVentaScreen> createState() => _BuscarOrdenVentaScreenState();
}

class _BuscarOrdenVentaScreenState extends State<BuscarOrdenVentaScreen>
    with SingleTickerProviderStateMixin {
  DateTime? selectedDate;
  late TabController tabController;
  String filtroEstado = 'Todos';
  // late OrdenVentaBloc ordenVentaBloc; // Guardar la referencia al Bloc

  TextEditingController controllerSearch = TextEditingController();

  @override
  void initState() {
    super.initState();

    tabController = TabController(length: 4, vsync: this);
    tabController.addListener(() {
      setState(() {
        filtroEstado = tabController.index == 0
            ? 'Todos'
            : tabController.index == 1
                ? 'P'
                : tabController.index == 2
                    ? 'I'
                    : 'F';
      });
    });

    cargarOrdenes();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Obtener la referencia al Bloc y guardarla
    // ordenVentaBloc = BlocProvider.of<OrdenVentaBloc>(context);
  }

  @override
  void dispose() {
    controllerSearch.dispose();
    super.dispose();
  }

  void cargarOrdenes() {
    BlocProvider.of<OrdenVentaBloc>(context).add(ObtenerOrdenesVenta(widget.tipoDocumento));
  }

  void cargarOrdenesBySearch() {
    BlocProvider.of<OrdenVentaBloc>(context)
        .add(ObtenerOrdenesVentaBySearch(controllerSearch.text, widget.tipoDocumento));
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
        controllerSearch.text =
            "${picked.toLocal()}".split(' ')[0]; // Formato de fecha
      });
    }
  }

  List<ResultadoOrdenVentaModel> filtrarPorEstado(
      List<ResultadoOrdenVentaModel> ordenes) {
    if (filtroEstado == 'Todos') return ordenes;
    return ordenes
        .where((orden) =>
            orden.documento?.estadoConteo == filtroEstado ||
            (filtroEstado == 'P' && orden.documento == null))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(
          247, 247, 247, 1), // const Color.fromARGB(255, 204, 216, 226),
      appBar: AppBarWidget(
        titulo: widget.tipoDocumento == 'orden_venta' 
          ? 'Orden de Venta'
          : widget.tipoDocumento == 'factura' 
            ? 'Factura de Venta'
            : widget.tipoDocumento == 'factura_compra' 
              ? 'Factura de Compra'
              : 'No se reconoce',
        icon: Icons.refresh,
        onPush: () => cargarOrdenesBySearch(),
      ),
      body: Column(
        children: [
          BuscadorOrdenVenta(
              textoHint: 'Buscar documento',
              iconoBoton: Icons.calendar_month_outlined,
              controllerSearch: controllerSearch,
              onSearch: () => _selectDate(context),
              onClearSearch: () {
                controllerSearch.text = '';
              },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: BorderSide.strokeAlignCenter),
            child: ElevatedButton.icon(
              onPressed: () {
                controllerSearch.text.isNotEmpty
                    ? cargarOrdenesBySearch()
                    : cargarOrdenes();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
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
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          TabBar(controller: tabController, tabs: const [
            Tab(
              text: 'Todos',
            ),
            Tab(
              text: 'Pendientes',
            ),
            Tab(
              text: 'En Proceso',
            ),
            Tab(
              text: 'Completados',
            ),
          ]),
          Expanded(
            child: BlocConsumer<OrdenVentaBloc, OrdenVentaState>(
              listener: (context, state) {
                if(state is OrdenVentaError){
                  if(state.codigoEstado == 401) {
                    BlocProvider.of<AuthBloc>(context).add(LogoutEvent());
                  }
                }
              },
              builder: (context, state) {
                if (state is OrdenVentaCargando) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is OrdenVentaCargada) {
                  if (state.response.resultado!.isNotEmpty) {
                    final ordenesFiltradas =
                        filtrarPorEstado(state.response.resultado!);
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: ListaDocumentosOrdenVenta(
                        ordenes: ordenesFiltradas,
                        tipoDocumento: widget.tipoDocumento,
                      ),
                    );
                  } else {
                    return NotFoundInformationWidget(
                      mensaje: 'No se pudo obtener registros desde los datos ingresados',
                      icono: Icons.error_outline,
                      onPush: () {
                        cargarOrdenes();
                      },
                    );
                  }
                } else {
                  return NotFoundInformationWidget(
                    mensaje: 'No se encontraron registros',
                    icono: Icons.error_outline,
                    onPush: () {
                      cargarOrdenes();
                    },
                  );
                }
              },
              // child: ListaDocumentosOrdenVenta(ordenes: const []))
            ),
          )
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class ListaDocumentosOrdenVenta extends StatelessWidget {
  ListaDocumentosOrdenVenta({super.key, required this.ordenes, required this.tipoDocumento });

  List<ResultadoOrdenVentaModel> ordenes;
  String tipoDocumento;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemBuilder: (context, index) {
        ResultadoOrdenVentaModel orden = ordenes[index];
        final estadoSap = orden.documento == null ? 'N' : orden.documento!.actualizadoSap;
        return Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3),
            decoration: BoxDecoration(
                color: estadoSap == 'Y'
                    ? Colors.blue[50]
                    : Colors.white, // color: Theme.of(context).colorScheme.,
                borderRadius: BorderRadius.circular(10),
            ),
            child: ItemListOrdenVenta(
              orden: orden,
              status: 'Pendiente',
              onOpen: () async {
                final result = await context.push('/detalleordenventa/$tipoDocumento', extra: orden);
                if (result == true) {
                  // ignore: use_build_context_synchronously
                  BlocProvider.of<OrdenVentaBloc>(context)
                      .add(ObtenerOrdenesVenta(tipoDocumento));
                  // tabController.index = 4;
                }
              },
            ),
          );
        },
        separatorBuilder: (context, index) {
          return const SizedBox(
            height: 5,
          );
        },
        itemCount: ordenes.length);
  }
}
