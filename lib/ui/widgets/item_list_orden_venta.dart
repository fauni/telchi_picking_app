import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picking_app/models/venta/resultado_orden_venta_model.dart';
import 'package:picking_app/ui/widgets/button_generic_widget.dart';

class ItemListOrdenVenta extends StatelessWidget {
  const ItemListOrdenVenta({
    super.key,
    required this.orden,
    required this.status
  });

  final ResultadoOrdenVentaModel orden;
  final String status;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
          children: [
            CircleAvatar(
              backgroundColor: getEstado() == 'Abierto' 
                ? Colors.grey[300]
                : Theme.of(context).colorScheme.onTertiary,
              child: IconButton(
                onPressed: (){
                  context.push('/detalleordenventa', extra: orden);
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (context) {
                  //       return DetallePedidoPage(pedido: pedido);
                  //     },
                  //     fullscreenDialog: true
                  //   )
                  // );
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
                      const Text('Sin iniciar')
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Estado del Documento: ', style: Theme.of(context).textTheme.titleSmall,),
                      Text(getEstado())
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
            status == 'Creado'
            ? IconButton(
              color: Theme.of(context).colorScheme.onError,
              onPressed: (){
                // context.push('/NuevoPedido', extra: MapGeneric.pedidoListToPedido(pedido));
              }, 
              icon: const Icon(Icons.arrow_forward_ios)
            )
            : const SizedBox()
          ],
        ),
    );
  }

  String getEstado(){
    String estadoGeneral = 'Abierto';
    // if(pedido.estado == 'bost_Close' && pedido.estadoCancelado == 'csYes'){
    //   estadoGeneral = 'Cancelado';
    // } else if (pedido.estadoCancelado == 'csNo' && pedido.estado == 'bost_Close'){
    //   estadoGeneral = 'Cerrado';
    // } else {
    //   estadoGeneral = 'Abierto';
    // }
    return estadoGeneral;
  }
}
