import 'package:flutter/material.dart';
import 'package:picking_app/ui/widgets/button_generic_alone_icon.dart';

class BuscadorOrdenVenta extends StatelessWidget {
  final String textoHint;
  final IconData iconoBoton;
  final TextEditingController controllerSearch;
  final Function onSearch;
  final Function(String)? onSubmitted; // Nuevo parametro agregado

  const BuscadorOrdenVenta({
    super.key,
    required this.textoHint,
    required this.iconoBoton,
    required this.controllerSearch,
    required this.onSearch,
    this.onSubmitted
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controllerSearch,
              decoration: InputDecoration(
                hintText: textoHint,
                prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.primary),
                border: const UnderlineInputBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.tertiary.withOpacity(0.3),
              ),
              onSubmitted: onSubmitted,
            ),
          ),
          ButtonGenericAloneIcon(
            icon: iconoBoton,
            height: 48,
            onPressed: () => onSearch(),
          ),
        ],
      ),
    );
  }
}
