import 'package:flutter/material.dart';

class GenericDialogLoading {
  static BuildContext? _dialogContext;

  /// Muestra un diálogo de carga con un mensaje opcional.
  static Future<void> show({
    required BuildContext context,
    String message = "Cargando...",
  }) async {
    // Evitar abrir múltiples diálogos
    if (_dialogContext != null) return;

    _dialogContext = context;

    showDialog(
      context: context,
      barrierDismissible: false, // Bloquea la pantalla hasta que se cierre
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        );
      },
    ).then((_) {
      // Resetear el contexto cuando se cierre el diálogo
      _dialogContext = null;
    });
  }

  /// Cierra el diálogo si está abierto.
  static void close() {
    if (_dialogContext != null) {
      Navigator.of(_dialogContext!, rootNavigator: true).pop();
      _dialogContext = null;
    }
  }
}
