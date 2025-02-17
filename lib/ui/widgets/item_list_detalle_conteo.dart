import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picking_app/bloc/almacen_bloc/almacen_bloc.dart';
import 'package:picking_app/bloc/bloc.dart';
import 'package:picking_app/models/conteo/detalle_conteo_model.dart';

class ItemListDetalleConteo extends StatefulWidget {
  const ItemListDetalleConteo({
    super.key,
    required this.detalle,
    required this.onTap
  });

  final DetalleConteo detalle;
  final VoidCallback onTap;
  @override
  State<ItemListDetalleConteo> createState() => _ItemListDetalleConteoState();
}

class _ItemListDetalleConteoState extends State<ItemListDetalleConteo> {
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
            Container(
              width: 5,
              height: 70,
              color: widget.detalle.estado == 'Pendiente' 
                ? Colors.grey
                : widget.detalle.estado == 'En Proceso'  
                  ? Colors.yellow 
                  : Colors.green,
            ),
            const SizedBox(width: 10,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${widget.detalle.codigoItem}', style: Theme.of(context).textTheme.titleMedium,),
                      Text(widget.detalle.codigoBarras ?? '', style: Theme.of(context).textTheme.titleMedium,),
                    ],
                  ),
                  Text('${widget.detalle.descripcionItem}', style: Theme.of(context).textTheme.titleSmall!.copyWith(color: Theme.of(context).colorScheme.primary),),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Cantidad Disponible', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey),),
                      Text('${widget.detalle.cantidadDisponible}', style: const TextStyle(fontWeight: FontWeight.w100),),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Cantidad Contada', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey),),
                      Text('${widget.detalle.cantidadContada}', style: const TextStyle(fontWeight: FontWeight.w100),),
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