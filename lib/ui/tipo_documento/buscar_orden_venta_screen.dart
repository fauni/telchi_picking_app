import 'package:flutter/material.dart';
import 'package:picking_app/ui/widgets/app_bar_widget.dart';
import 'package:picking_app/ui/widgets/buscador_orden_venta.dart';

class BuscarOrdenVentaScreen extends StatefulWidget {
  const BuscarOrdenVentaScreen({super.key});

  @override
  State<BuscarOrdenVentaScreen> createState() => _BuscarOrdenVentaScreenState();
}

class _BuscarOrdenVentaScreenState extends State<BuscarOrdenVentaScreen> {
  TextEditingController controllerSearch = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controllerSearch.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: const AppBarWidget(titulo: 'Orden de Venta'),
      body: Column(
        children: [
          BuscadorOrdenVenta( 
            controllerSearch: controllerSearch,
            onSearch: controllerSearch.text.isNotEmpty 
              ?(){}
              : (){}
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton.icon(                     
              onPressed: () {
            
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
              label: const Text("BUSCAR DOCUMENTO"),
              icon: const Icon(Icons.search, size: 30,),
            ),
          ), 
          const Expanded(
            child: Text('nO SE ENCONTRARON DOCUMENTOS')
          )
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class ListaDocumentosOrdenVenta extends StatelessWidget {
  ListaDocumentosOrdenVenta({
    super.key,
    required this.data
  });

  List<String> data;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemBuilder: (context, index) {
        String orden = data[index];
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(10)
          ),
          child: ItemListPedidoWidget(pedido: pedido, status: 'Pendiente',)
        );
      }, 
      separatorBuilder: (context, index) {
        return const SizedBox(height: 3,);
      }, 
      itemCount: pedidos.length
    );
  }
}

