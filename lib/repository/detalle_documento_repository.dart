import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:picking_app/config/constants/environment.dart';
import 'package:picking_app/models/api_response_model.dart';
import 'package:picking_app/repository/auth_repository.dart';

class DetalleDocumentoRepository {
  final String _baseUrl = Environment.UrlApi;
  final AuthRepository _authRepository = AuthRepository();

  Future<ApiResponse> actualizarCantidad(
      {required int idDetalle, required double cantidadAgregada}) async {
    final url = Uri.parse(
        '$_baseUrl/DetalleDocumento/detalle/$idDetalle/actualizar-cantidad');

    // Recuperamos los tokens de sharedPreferences
    final token = await _authRepository.getToken();
    final tokenSAP = await _authRepository.getTokenSap();
    final usuario = await _authRepository.getUserData();

    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
      if (tokenSAP != null) 'SessionID': tokenSAP
    };

    final body = jsonEncode({
      'cantidadAgregada': cantidadAgregada,
      'usuario': usuario!.usuarioNombre,
    });

    try {
      final response = await http.put(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return ApiResponse<String>.fromJson(
            data,
            (resultadoJson) =>
                resultadoJson['message'] // Mapea el mensaje del resultado
            );
      } else {
        final data = json.decode(response.body);
        return ApiResponse<String>(
          isSuccessful: false,
          statusCode: response.statusCode,
          errorMessages: data['errorMessages'] != null
              ? List<String>.from(data['errorMessages'])
              : ['Error inesperado al actualizar la cantidad.'],
          resultado: null,
        );
      }
    } catch (e) {
      return ApiResponse<String>(
        isSuccessful: false,
        statusCode: 500,
        errorMessages: ['Error al conectar con el servidor: $e'],
        resultado: null,
      );
    }
  }
}
