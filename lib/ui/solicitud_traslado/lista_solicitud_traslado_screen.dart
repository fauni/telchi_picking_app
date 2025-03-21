import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:picking_app/bloc/bloc.dart';
import 'package:picking_app/models/traslado/resultado_solicitud_traslado.dart';
import 'package:picking_app/ui/widgets/app_bar_widget.dart';
import 'package:picking_app/ui/widgets/buscador_orden_venta.dart';
import 'package:picking_app/ui/widgets/item_list_solicitud_traslado.dart';
import 'package:picking_app/ui/widgets/not_found_information_widget.dart';

class ListaSolicitudTrasladoScreen extends StatefulWidget {
  const ListaSolicitudTrasladoScreen({super.key});

  @override
  State<ListaSolicitudTrasladoScreen> createState() => _ListaSolicitudTrasladoScreenState();
}

class _ListaSolicitudTrasladoScreenState extends State<ListaSolicitudTrasladoScreen> with SingleTickerProviderStateMixin {
  DateTime? selectedDate;
  late TabController tabController;
  String filtroEstado = 'Todos';

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
    cargarSolicitudes();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    controllerSearch.dispose();
    super.dispose();
  }

  void cargarSolicitudes(){
    // TODO: Revisar los datos PageNumber y Size
    BlocProvider.of<SolicitudTrasladoBloc>(context).add(LoadSolicitudesTraslado(pageNumber: 1, pageSize: 30));
  }

  void cargarSolicitudesBySearch(){
    BlocProvider.of<SolicitudTrasladoBloc>(context).add(LoadSolicitudesTraslado(pageNumber: 1, pageSize: 30, search: controllerSearch.text));
  }

  void cargarSolicitudesByDocDate(docDate){
    BlocProvider.of<SolicitudTrasladoBloc>(context).add(LoadSolicitudesTraslado(pageNumber: 1, pageSize: 30, docDate: docDate));
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
        cargarSolicitudesByDocDate(selectedDate);
        // controllerSearch.text =
        //     "${picked.toLocal()}".split(' ')[0]; // Formato de fecha
      });
    }
  }
  
  List<SolicitudTraslado> filtrarPorEstado(
    List<SolicitudTraslado> solicitudes){

      if(filtroEstado == 'Todos') return solicitudes;
      return solicitudes
        .where((solicitud) => 
          solicitud.documento?.estadoConteo == filtroEstado || 
          (filtroEstado == 'P' && solicitud.documento == null))
        .toList(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(247, 247, 247, 1),
      appBar: AppBarWidget(
        titulo: 'Solicitud de Traslado',
        icon: Icons.refresh,
        onPush: () => cargarSolicitudes(),
      ),
      body: Column(
        children: [
          BuscadorOrdenVenta(
            textoHint: 'Buscar documento', 
            iconoBoton: Icons.calendar_month_outlined, 
            controllerSearch: controllerSearch, 
            onSearch: () => _selectDate(context), 
            onClearSearch: (){ controllerSearch.clear();},
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: BorderSide.strokeAlignCenter),
            child: ElevatedButton.icon(
              onPressed: () {
                controllerSearch.text.isNotEmpty
                  ? cargarSolicitudesBySearch()
                  : cargarSolicitudes();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              icon: const Icon(Icons.search, size: 30, color: Colors.white,),
              label: const Text('BUSCAR'),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          TabBar(controller: tabController, tabs: const [
            Tab(text: 'Todos',),
            Tab(text: 'Pendientes',),
            Tab(text: 'En Proceso',),
            Tab(text: 'Completados',),
          ]),
          Expanded(
            child: BlocConsumer<SolicitudTrasladoBloc, SolicitudTrasladoState>(
              listener: (context, state) {
                // if(state is SolicitudTrasladoLoadError){
                //   if(state.codigoEstado == 401) {
                //     BlocProvider.of<AuthBloc>(context).add(LogoutEvent());
                //   }
                // }
              },
              builder: (context, state) {
                if (state is SolicitudTrasladoLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is SolicitudesTrasladoLoaded) {
                  if(state.solicitudesTraslado.isNotEmpty){
                    final solicitudesFiltradas = filtrarPorEstado(state.solicitudesTraslado);
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: ListViewSolicitudTraslado(
                        solicitudes: solicitudesFiltradas
                      )
                    );

                  } else {
                    return NotFoundInformationWidget(
                      icono: Icons.error_outline, 
                      mensaje: 'No se pudo obtener solicitudes', 
                      onPush: () => cargarSolicitudes(),
                    );
                  }
                } else if (state is SolicitudTrasladoLoadError) {
                  return Center(
                    child: Text(state.message),
                  );
                } else {
                  return NotFoundInformationWidget(
                    icono: Icons.error_outline, 
                    mensaje: 'No se encontraron registros', 
                    onPush: () {
                      cargarSolicitudes();
                    },
                  );
                }
              },
            )
          )
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class ListViewSolicitudTraslado extends StatelessWidget {
  ListViewSolicitudTraslado({super.key, required this.solicitudes});

  List<SolicitudTraslado> solicitudes;

  @override
  Widget build(BuildContext context){
    return ListView.separated(
      shrinkWrap: true,
      itemBuilder: (context, index) {
        SolicitudTraslado solicitud = solicitudes[index];
        final estadoSap = solicitud.documento == null ? 'N' : solicitud.documento!.actualizadoSap;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: BoxDecoration(
            color: estadoSap == 'Y' ? Colors.blue[50] : Colors.white,
            borderRadius: BorderRadius.circular(10)
          ),
          child: ItemListSolicitudTraslado(
            solicitud: solicitud, 
            status: 'Pendiente', 
            onOpen: () async {
              // final result = await context.push('/detallesolicitudtraslado', extra: solicitud);
              // if (result == true) {
              //   // ignore: use_build_context_synchronously
              //   BlocProvider.of<SolicitudTrasladoBloc>(context)
              //     .add(LoadSolicitudesTraslado(pageNumber: 1, size: 10));
              // }

              final navigatorContext = context; // Guardamos una referencia válida al contexto
              final result = await navigatorContext.push('/detallesolicitudtraslado', extra: solicitud);
              
              if (result == true) {
                if (navigatorContext.mounted) { // Verificamos si el widget aún está montado
                  BlocProvider.of<SolicitudTrasladoBloc>(navigatorContext)
                      .add(LoadSolicitudesTraslado(pageNumber: 1, pageSize: 30));
                }
              }
            }
          )
        );
      }, 
      separatorBuilder: (context, index) {
        return const SizedBox(height: 5,);
      }, 
      itemCount: solicitudes.length
    );
  }
}