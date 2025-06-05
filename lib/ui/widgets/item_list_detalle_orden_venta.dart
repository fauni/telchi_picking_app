import 'package:flutter/material.dart';
import 'package:picking_app/models/venta/resultado_orden_venta_model.dart';

// ignore: must_be_immutable
class ItemListDetalleOrdenVenta extends StatefulWidget {
  ItemListDetalleOrdenVenta({
    super.key,
    required this.detalle,
    required this.onTap
  });

  final DocumentLineOrdenVenta detalle;
  final VoidCallback onTap; 
  @override
  State<ItemListDetalleOrdenVenta> createState() => _ItemListDetalleOrdenVentaState();
}

class _ItemListDetalleOrdenVentaState extends State<ItemListDetalleOrdenVenta> {
 // Parametro para manejar Touch en el item
  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            buildEstadoContainer(widget.detalle),
            const SizedBox(width: 10,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${widget.detalle.itemCode}', style: Theme.of(context).textTheme.titleMedium,),
                      Text(widget.detalle.barCode ?? '', style: Theme.of(context).textTheme.titleMedium,),
                    ],
                  ),
                  Text('${widget.detalle.itemDescription}', style: Theme.of(context).textTheme.titleSmall!.copyWith(color: Theme.of(context).colorScheme.primary),),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Cantidad Esperada', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey),),
                      Text('${widget.detalle.quantity}', style: const TextStyle(fontWeight: FontWeight.w100),),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Cantidad Contada', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey),),
                      widget.detalle.detalleDocumento == null 
                      ? const Text('0', style: TextStyle(fontWeight: FontWeight.w100),)
                      : Text('${widget.detalle.detalleDocumento!.cantidadContada!.toInt()}', style: const TextStyle(fontWeight: FontWeight.w100),),
                    ],
                  )
                ],
              ),
            ),
          ],
        )
      ),
    );
  }

  Widget buildEstadoContainer(DocumentLineOrdenVenta detalle) {
    Color containerColor = Colors.grey; // Valor predeterminado

    if (detalle.detalleDocumento != null) {
      String estado = detalle.detalleDocumento!.estado!;
      double cantidadEsperada = detalle.detalleDocumento!.cantidadEsperada!;
      double cantidadContada = detalle.detalleDocumento!.cantidadContada!;

      if (estado == 'Completado') {
        if (cantidadEsperada != null && cantidadContada != null && cantidadEsperada > cantidadContada) {
          containerColor = Colors.red;
        } else {
          containerColor = Colors.green;
        }
      } else if (estado == 'Pendiente') {
        containerColor = Colors.grey;
      } else if (estado == 'En Progreso') {
        containerColor = Colors.yellow;
      }
    }
    return Container(
      width: 5,
      height: 70,
      color: containerColor,
    );
  }
}
