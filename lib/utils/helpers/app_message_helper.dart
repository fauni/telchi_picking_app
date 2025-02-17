// app_message_helper.dart
import 'package:flutter/material.dart';

// message_type.dart
enum MessageType {
  success,
  error,
  warning,
}


class AppMessageHelper {
  static void showAppMessage(
    BuildContext context,
    String message,
    MessageType type, {
    Duration duration = const Duration(seconds: 3),
  }) {
    Color backgroundColor;
    IconData icon;

    switch (type) {
      case MessageType.success:
        backgroundColor = Colors.green.shade600;
        icon = Icons.check_circle;
        break;
      case MessageType.error:
        backgroundColor = Colors.red.shade600;
        icon = Icons.error_outline;
        break;
      case MessageType.warning:
        backgroundColor = Colors.orange.shade600;
        icon = Icons.warning_amber_outlined;
        break;
    }

    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      duration: duration,
      behavior: SnackBarBehavior.floating, // Opcional: hace que el SnackBar flote sobre el contenido
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0), // Bordes redondeados
      ),
      action: SnackBarAction(
        label: 'Cerrar',
        textColor: Colors.white,
        onPressed: () {
          // Cierra el SnackBar cuando se presiona 'Cerrar'
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );

    // Muestra el SnackBar
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar() // Oculta cualquier SnackBar anterior
      ..showSnackBar(snackBar);
  }
}
