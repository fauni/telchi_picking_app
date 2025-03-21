import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:picking_app/models/traslado/resultado_solicitud_traslado.dart';

// ignore: must_be_immutable
class ItemListSolicitudTraslado extends StatelessWidget {
  ItemListSolicitudTraslado({
    super.key,
    required this.solicitud,
    required this.status,
    required this.onOpen
  });

  final SolicitudTraslado solicitud;
  final String status;
  VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: solicitud.documento == null
                ? Colors.grey[300]
                : solicitud.documento!.estadoConteo == 'I' 
                  ? Theme.of(context).colorScheme.tertiary
                  : solicitud.documento!.estadoConteo == 'P' ? Colors.grey[300] : Colors.green,
              child: IconButton(
                onPressed: () {
                  
                }, 
                icon: const Icon(Icons.remove_red_eye_sharp, size: 20,)
              ),
            ),
            const SizedBox(width: 10.0,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Número de Documento: ', style: Theme.of(context).textTheme.titleSmall,),
                      Text('${solicitud.docNum}'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Fecha del Documento: ', style: Theme.of(context).textTheme.titleSmall,),
                      Text(formatDate(solicitud.docDate!, [dd,'-',m,'-',yyyy]))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('De Almacen: ', style: Theme.of(context).textTheme.titleSmall,),
                      Text('${solicitud.filler}'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('A Almacen: ', style: Theme.of(context).textTheme.titleSmall,),
                      Text('${solicitud.toWhsCode}'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Estado de Conteo: ', style: Theme.of(context).textTheme.titleSmall,),
                      solicitud.documento == null ? const Text('Sin Iniciar') : Text(getEstado(solicitud.documento!.estadoConteo!))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Estado del Documento: ', style: Theme.of(context).textTheme.titleSmall,),
                      Text(getEstadoOrden(solicitud.docStatus!), style: TextStyle(color: solicitud.docStatus == 'C' ? Colors.red: Colors.green),)
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10,),
            IconButton(
              color: Theme.of(context).colorScheme.primary,
              onPressed: onOpen, 
              icon: const Icon(Icons.arrow_forward_ios)
            )
          ],
        ),
    );
  }

  String getEstado(String estado){
    String estadoGeneral = 'Abierto';
    if(estado == 'P'){
      estadoGeneral = 'Pendiente';
    } else if (estado == 'I'){
      estadoGeneral = 'En Proceso';
    } else {
      estadoGeneral = 'Completado';
    }
    return estadoGeneral;
  }

  String getEstadoOrden(String estado){
    String estadoGeneral = '';
    if(estado == 'C'){
      estadoGeneral = 'Cerrado';
    } else {
      estadoGeneral = 'Abierto';
    }
    return estadoGeneral;
  }
}
