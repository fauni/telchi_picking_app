import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picking_app/ui/widgets/app_bar_widget.dart';
import 'package:picking_app/ui/widgets/button_tipo_documento.dart';

class TipoDocumentoScreen extends StatelessWidget {
  const TipoDocumentoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(
        titulo: 'Tipo de Documento',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Elija una opción:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  // Botón ORDEN DE VENTA
                  ButtonTipoDocumento(
                    icon: Icons.description,
                    label: "ORDEN DE \n VENTA",
                    color: Theme.of(context).colorScheme.primary,
                    onPressed: () {
                      context.push('/ordenventa', extra: 'orden_venta');
                    },
                  ),
                  // Botón ORDEN DE VENTA
                  ButtonTipoDocumento(
                    icon: Icons.receipt,
                    label: "FACTURA DE \n VENTAS",
                    color: Theme.of(context).colorScheme.primary,
                    onPressed: () {
                      context.push('/ordenventa', extra: 'factura');
                    },
                  ),
                  // Botón ORDEN DE VENTA
                  ButtonTipoDocumento(
                    icon: Icons.inventory_outlined,
                    label: "FACTURA DE \n COMPRAS",
                    color: Theme.of(context).colorScheme.primary,
                    onPressed: () {
                      context.push('/ordenventa', extra: 'factura_compra');
                    },
                  ),
                  // Botón ORDEN DE VENTA
                  ButtonTipoDocumento(
                    icon: Icons.swap_horiz,
                    label: "SOLICITUD \n DE TRASLADO",
                    color: Theme.of(context).colorScheme.primary,
                    onPressed: () {
                      context.push('/solicitud-traslado');
                    },
                  ),
                  ButtonTipoDocumento(
                    icon: Icons.shopping_cart,
                    label: "ORDEN DE \n COMPRA",
                    color: Theme.of(context).colorScheme.primary,
                    onPressed: () {
                      context.push('/ordenventa', extra: 'orden_compra');
                    },
                  ),
                  ButtonTipoDocumento(
                    icon: Icons.airport_shuttle_outlined,
                    label: "ENTREGAS",
                    color: Theme.of(context).colorScheme.primary,
                    onPressed: () {
                      context.push('/ordenventa', extra: 'entregas');
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
