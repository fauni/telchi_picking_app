import 'package:flutter/material.dart';

class NotFoundInformationWidget extends StatelessWidget {
  const NotFoundInformationWidget({
    super.key,
    required this.icono,
    required this.mensaje,
    required this.onPush
  });

  final String mensaje;
  final IconData icono;
  final Function() onPush;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).colorScheme.tertiary,
            child: Icon(icono, size: 40,),
          ),
          Text(mensaje, style: Theme.of(context).textTheme.bodyMedium, maxLines: 2),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              minimumSize: const Size(300, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
              )
            ),
            onPressed: onPush, 
            icon: const Icon(Icons.refresh), 
            label: const Text('Volver a cargar')
          )
        ],
      ),
    );
  }
}