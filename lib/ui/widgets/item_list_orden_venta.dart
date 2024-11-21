import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picking_app/models/venta/resultado_orden_venta_model.dart';
import 'package:picking_app/ui/widgets/button_generic_widget.dart';

class ItemListOrdenVenta extends StatelessWidget {
  ItemListOrdenVenta({
    super.key,
    required this.orden,
    required this.status,
    required this.onOpen
  });

  final ResultadoOrdenVentaModel orden;
  final String status;
  VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
          children: [
            CircleAvatar(
              backgroundColor: orden.documento == null
                ? Colors.grey[300]
                : orden.documento!.estadoConteo == 'I' 
                  ? Theme.of(context).colorScheme.tertiary
                  : orden.documento!.estadoConteo == 'P' ? Colors.grey[300] : Colors.green,
              child: IconButton(
                onPressed: () {
                  
                }, 
                icon: const Icon(Icons.remove_red_eye_sharp)
              ),
            ),
            const SizedBox(width: 10.0,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Text('Codigo SAP: ', style: Theme.of(context).textTheme.titleSmall,),
                  //     Text('${orden.docEntry}'),
                  //   ],
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Número de Documento: ', style: Theme.of(context).textTheme.titleSmall,),
                      Text('${orden.docNum}'),
                    ],
                  ),
                  Text('${orden.cardCode} ${orden.cardName}', style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.primary),),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Fecha del Documento: ', style: Theme.of(context).textTheme.titleSmall,),
                      Text(formatDate(orden.docDate!, [dd,'-',m,'-',yyyy]))
                    ],
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Text('TOTAL: ', style: Theme.of(context).textTheme.titleSmall,),
                  //     Text('${orden.docTotal} ${orden.docCurrency}')
                  //   ],
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Estado de Conteo: ', style: Theme.of(context).textTheme.titleSmall,),
                      orden.documento == null ? const Text('Sin Iniciar') : Text(getEstado(orden.documento!.estadoConteo!))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Estado del Documento: ', style: Theme.of(context).textTheme.titleSmall,),
                      Text(getEstadoOrden(orden.documentStatus!), style: TextStyle(color: orden.documentStatus == 'bost_Close' ? Colors.red: Colors.green),)
                    ],
                  ),
                  status == 'Autorizado' ? const Divider() : const SizedBox(),
                  status == 'Autorizado'
                  ? ButtonGenericWidget(
                    icon: Icons.check,
                    label: 'Crear Pedido', 
                    height: 40, 
                    width: double.infinity,
                    onPressed: (){
                      // BlocProvider.of<PedidoPendienteBloc>(context).add(CrearDocumentoPedidoAprobado(pedido.id!));
                    }
                  ): const SizedBox()
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
    if(estado == 'bost_Close'){
      estadoGeneral = 'Cerrado';
    } else {
      estadoGeneral = 'Abierto';
    }
    return estadoGeneral;
  }
}
