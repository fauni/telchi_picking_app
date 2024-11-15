import 'package:flutter/material.dart';
import 'package:picking_app/models/picking/documento_model.dart';
import 'package:picking_app/models/venta/resultado_orden_venta_model.dart';

// ignore: must_be_immutable
class ItemListDetalleOrdenVenta extends StatelessWidget {
  ItemListDetalleOrdenVenta({
    super.key,
    required this.detalle,
    this.detalleConteo
  });

  final DocumentLineOrdenVenta detalle;
  DetalleDocumento? detalleConteo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Container(
            width: 5,
            height: 70,
            color: detalleConteo!.estado == 'Completado' 
              ? Colors.green
              : detalleConteo!.estado == 'Pendiente'  
                ? Colors.grey 
                : detalleConteo!.estado == 'En Progreso' ? Colors.yellow : Colors.grey,
          ),
          const SizedBox(width: 10,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${detalle.itemCode}', style: Theme.of(context).textTheme.titleMedium,),
                    Text('${detalle.currency}', style: const TextStyle(fontWeight: FontWeight.w100),),
                  ],
                ),
                Text('${detalle.itemDescription}', style: Theme.of(context).textTheme.titleSmall!.copyWith(color: Theme.of(context).colorScheme.primary),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Cantidad Esperada', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey),),
                    Text('${detalle.quantity}', style: const TextStyle(fontWeight: FontWeight.w100),),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Cantidad Contada', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey),),
                    detalleConteo!.idDetalle == null 
                    ? Text('0', style: const TextStyle(fontWeight: FontWeight.w100),)
                    : Text('${detalleConteo!.cantidadContada!.toInt()}', style: const TextStyle(fontWeight: FontWeight.w100),),
                  ],
                )
              ],
            ),
          ),
        ],
      )
    );
  }
}
