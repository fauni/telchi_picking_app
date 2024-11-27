import 'package:flutter/material.dart';
import 'package:picking_app/models/picking/documento_model.dart';
import 'package:picking_app/models/venta/resultado_orden_venta_model.dart';

// ignore: must_be_immutable
class ItemListDetalleOrdenVenta extends StatefulWidget {
  ItemListDetalleOrdenVenta({
    super.key,
    required this.detalle,
    this.detalleConteo,
    required this.onTap
  });

  final DocumentLineOrdenVenta detalle;
  DetalleDocumento? detalleConteo;
  final VoidCallback onTap; 
  @override
  State<ItemListDetalleOrdenVenta> createState() => _ItemListDetalleOrdenVentaState();
}

class _ItemListDetalleOrdenVentaState extends State<ItemListDetalleOrdenVenta> {
 // Parametro para manejar Touch en el item
  @override
  void initState() {
    super.initState();
    print(widget.detalle.barCode);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Container(
              width: 5,
              height: 70,
              color: widget.detalleConteo!.estado == 'Completado' 
                ? Colors.green
                : widget.detalleConteo!.estado == 'Pendiente'  
                  ? Colors.grey 
                  : widget.detalleConteo!.estado == 'En Progreso' ? Colors.yellow : Colors.grey,
            ),
            const SizedBox(width: 10,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${widget.detalle.itemCode}', style: Theme.of(context).textTheme.titleMedium,),
                      // detalle!.barCode == null ? Text(detalle.barCode!) : const Text('') 
                      // Text('${detalle.currency}', style: const TextStyle(fontWeight: FontWeight.w100),),
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
                      widget.detalleConteo!.idDetalle == null 
                      ? const Text('0', style: TextStyle(fontWeight: FontWeight.w100),)
                      : Text('${widget.detalleConteo!.cantidadContada!.toInt()}', style: const TextStyle(fontWeight: FontWeight.w100),),
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
}
