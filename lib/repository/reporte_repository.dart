import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:picking_app/config/constants/environment.dart';
import 'package:picking_app/repository/auth_repository.dart';

class ReporteRepository {
  final String _baseUrl = Environment.UrlApi;
  final AuthRepository _authRepository = AuthRepository();

   Future<String> downloadReport({
    required String tipoDocumento,
    required String docNum,
  }) async {
    try {
      // Obtener tokens de manera segura
      final token = await _authRepository.getToken();
      final tokenSAP = await _authRepository.getTokenSap();

      if (token == null || tokenSAP == null) {
        throw Exception('No se pudo obtener los tokens de autenticación');
      }

      // Construir URL de manera más segura
      final uri = Uri.parse('$_baseUrl/order/GenerarReporte')
          .replace(queryParameters: {
        'tipoDocumento': tipoDocumento,
        'docNum': docNum,
      });

      // Realizar la petición HTTP
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
          'SessionID': tokenSAP,
        },
      ).timeout(const Duration(seconds: 30));

      // Manejar diferentes códigos de estado
      switch (response.statusCode) {
        case 200:
          final directory = await getApplicationDocumentsDirectory();
          final filePath = '${directory.path}/$tipoDocumento-$docNum.pdf';
          final file = File(filePath);
          
          await file.writeAsBytes(response.bodyBytes);
          return filePath;
          
        case 401:
          throw Exception('No autorizado - Token inválido o expirado');
        case 404:
          throw Exception('Recurso no encontrado');
        case 500:
          throw Exception('Error interno del servidor');
        default:
          throw Exception('Error desconocido: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('Error de conexión - Verifique su conexión a internet');
    } on http.ClientException {
      throw Exception('Error en la solicitud HTTP');
    } on TimeoutException {
      throw Exception('Tiempo de espera agotado');
    } catch (e) {
      throw Exception('Error al descargar el reporte: ${e.toString()}');
    }
  }
  
}