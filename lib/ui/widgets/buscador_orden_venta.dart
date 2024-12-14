import 'package:flutter/material.dart';
import 'package:picking_app/ui/widgets/button_generic_alone_icon.dart';

class BuscadorOrdenVenta extends StatefulWidget {
  final String textoHint;
  final IconData iconoBoton;
  final TextEditingController controllerSearch;
  final Function onSearch;
  final Function(String)? onSubmitted; // Nuevo parametro agregado
  final Function(String)? onChanged;
  final VoidCallback onClearSearch;


  const BuscadorOrdenVenta(
    {
      super.key,
      required this.textoHint,
      required this.iconoBoton,
      required this.controllerSearch,
      required this.onSearch,
      this.onSubmitted,
      this.onChanged,
      required this.onClearSearch
    }
  );

  @override
  State<BuscadorOrdenVenta> createState() => _BuscadorOrdenVentaState();
}

class _BuscadorOrdenVentaState extends State<BuscadorOrdenVenta> {
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    widget.controllerSearch.addListener(_updateHasText);
  }

  @override
  void dispose() {
    widget.controllerSearch.removeListener(_updateHasText);
    super.dispose();
  }

  void _updateHasText() {
    setState(() {
      _hasText = widget.controllerSearch.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: widget.controllerSearch,
              decoration: InputDecoration(
                hintText: widget.textoHint,
                prefixIcon: Icon(Icons.search,
                    color: Theme.of(context).colorScheme.primary),
                suffixIcon: _hasText 
                ? IconButton(
                  onPressed: widget.onClearSearch,
                  icon: const Icon(
                    Icons.clear,
                  ),
                ) : null,
                border: const UnderlineInputBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                ),
                filled: true,
                fillColor:
                    Theme.of(context).colorScheme.tertiary.withOpacity(0.3),
              ),
              onSubmitted: widget.onSubmitted,
              onChanged: widget.onChanged,
            ),
          ),
          ButtonGenericAloneIcon(
            icon: widget.iconoBoton,
            height: 48,
            onPressed: () => widget.onSearch(),
          ),
        ],
      ),
    );
  }
}
