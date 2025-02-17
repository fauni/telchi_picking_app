import 'package:flutter/material.dart';

class CrearConteoDialog extends StatefulWidget {
  const CrearConteoDialog({super.key});

  @override
  State<CrearConteoDialog> createState() => _CrearConteoDialogState();
}

class _CrearConteoDialogState extends State<CrearConteoDialog> {
  String texto = "";
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Dialogo Personalizado1'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            onChanged: (value) {
              setState(() {
                texto = value;
              });
            },
            decoration: const InputDecoration(
              labelText: 'Escribe algo'
            ),
          ),
          const SizedBox(height: 20,),
          Text('Has escrito: $texto')
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Cierra el dialogo
          }, 
          child: const Text('Cerrar')
        )
      ],
    );
  }
}