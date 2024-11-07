import 'package:flutter/material.dart';
import 'package:picking_app/ui/widgets/button_generic_alone_icon.dart';

class BuscadorOrdenVenta extends StatelessWidget {
  final TextEditingController controllerSearch;
  final Function onSearch;

  const BuscadorOrdenVenta({
    super.key,
    required this.controllerSearch,
    required this.onSearch,
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
                hintText: 'Buscar Documento',
                prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.tertiary),
                border: const UnderlineInputBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.onTertiary.withOpacity(0.3),
              ),
              onSubmitted: (value) => onSearch(),
            ),
          ),
          ButtonGenericAloneIcon(
            icon: Icons.calendar_month,
            height: 48,
            onPressed: () => onSearch(),
          ),
          // ButtonGenericAloneIcon(
          //   icon: Icons.search,
          //   height: 48,
          //   onPressed: () => onSearch(),
          // ),
        ],
      ),
    );
  }
}
