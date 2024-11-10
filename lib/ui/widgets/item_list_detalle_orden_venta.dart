import 'package:flutter/material.dart';
import 'package:picking_app/models/venta/resultado_orden_venta_model.dart';

class ItemListDetalleOrdenVenta extends StatelessWidget {
  const ItemListDetalleOrdenVenta({
    super.key,
    required this.detalle
  });

  final DocumentLineOrdenVenta detalle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${detalle.itemCode}', style: Theme.of(context).textTheme.titleMedium,),
              Text('${detalle.currency}', style: TextStyle(fontWeight: FontWeight.w100),),
            ],
          ),
          Text('${detalle.itemDescription}', style: Theme.of(context).textTheme.titleSmall!.copyWith(color: Theme.of(context).colorScheme.primary),),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Cantidad Esperada', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey),),
              Text('${detalle.quantity}', style: TextStyle(fontWeight: FontWeight.w100),),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Cantidad Contada', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey),),
              Text('${detalle.quantity}', style: TextStyle(fontWeight: FontWeight.w100),),
            ],
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Text('Fecha del Documento: ', style: Theme.of(context).textTheme.titleSmall,),
          //     Text(formatDate(orden.docDate!, [dd,'-',m,'-',yyyy]))
          //   ],
          // ),
        ],
      )
    );
  }
}
