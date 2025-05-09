import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:picking_app/config/constants/environment.dart';
import 'package:picking_app/models/api_response_model.dart';
import 'package:picking_app/models/documento/resultado_actualizar_conteo_sap_model.dart';
import 'package:picking_app/models/documento/resultado_documento_model.dart';
import 'package:picking_app/repository/auth_repository.dart';

class DocumentoRepository {
  final String _baseUrl = Environment.UrlApi;
  final AuthRepository _authRepository = AuthRepository();

  Future<ApiResponse<ResultadoDocumentoModel>> crearDocumentoDesdeSap(String docNum, String tipoDocumento) async {
    final url = Uri.parse('$_baseUrl/documento/crear-desde-sap?docNum=$docNum&tipoDocumento=$tipoDocumento');

    // Recuperamos los tokens de sharedPreferences
    final token = await _authRepository.getToken();
    final tokenSAP = await _authRepository.getTokenSap();

    // Definamos las cabeceras, incluyendo los tokens si están disponibles
    final headers = {
      'Content-Type': 'application/json',
      if(token != null) 'Authorization': 'Bearer $token',
      if(tokenSAP != null) 'SessionID': tokenSAP
    };

    try {
      final response = await http.post(url, headers: headers);
      if(response.statusCode == 201){
        final data = json.decode(response.body);
        final resultado = ResultadoDocumentoModel.fromJson(data['resultado']);
        return ApiResponse<ResultadoDocumentoModel>(
          statusCode: 201, 
          isSuccessful: true,
          errorMessages: null,
          resultado: resultado
        );
      } else {
        // Manejo de errores en caso de que no se tenga éxito
        final data = json.decode(response.body);
        final errorMessages = data['errorMessages'] != null
            ? List<String>.from(data['errorMessages'])
            : ['Ocurrió un error inesperado'];
        return ApiResponse<ResultadoDocumentoModel>(
          isSuccessful: false,
          statusCode: response.statusCode,
          errorMessages: errorMessages,
          resultado: null,
        );
      }
    } catch(e){
      return ApiResponse<ResultadoDocumentoModel>(
        isSuccessful: false,
        statusCode: 500, 
        errorMessages: ['An error ocurred: $e'],
        resultado: null
      );
    }
  }

  Future<ApiResponse<ResultadoDocumentoModel>> crearDocumentoSolicitudDesdeSap(String docEntry) async {
    final url = Uri.parse('$_baseUrl/documento/crear-solicitud-desde-sap?docEntry=$docEntry');

    // Recuperamos los tokens de sharedPreferences
    final token = await _authRepository.getToken();
    final tokenSAP = await _authRepository.getTokenSap();

    // Definamos las cabeceras, incluyendo los tokens si están disponibles
    final headers = {
      'Content-Type': 'application/json',
      if(token != null) 'Authorization': 'Bearer $token',
      if(tokenSAP != null) 'SessionID': tokenSAP
    };

    try {
      final response = await http.post(url, headers: headers);
      if(response.statusCode == 201){
        final data = json.decode(response.body);
        final resultado = ResultadoDocumentoModel.fromJson(data['resultado']);
        return ApiResponse<ResultadoDocumentoModel>(
          statusCode: 201, 
          isSuccessful: true,
          errorMessages: null,
          resultado: resultado
        );
      } else {
        // Manejo de errores en caso de que no se tenga éxito
        final data = json.decode(response.body);
        final errorMessages = data['errorMessages'] != null
            ? List<String>.from(data['errorMessages'])
            : ['Ocurrió un error inesperado'];
        return ApiResponse<ResultadoDocumentoModel>(
          isSuccessful: false,
          statusCode: response.statusCode,
          errorMessages: errorMessages,
          resultado: null,
        );
      }
    } catch(e){
      return ApiResponse<ResultadoDocumentoModel>(
        isSuccessful: false,
        statusCode: 500, 
        errorMessages: ['An error ocurred: $e'],
        resultado: null
      );
    }
  }

  Future<ApiResponse<ResultadoDocumentoModel>> crearDocumentoTransferenciaStockDesdeSap(String docEntry) async {
    final url = Uri.parse('$_baseUrl/documento/crear-transferencia-desde-sap?docEntry=$docEntry');

    // Recuperamos los tokens de sharedPreferences
    final token = await _authRepository.getToken();
    final tokenSAP = await _authRepository.getTokenSap();

    // Definamos las cabeceras, incluyendo los tokens si están disponibles
    final headers = {
      'Content-Type': 'application/json',
      if(token != null) 'Authorization': 'Bearer $token',
      if(tokenSAP != null) 'SessionID': tokenSAP
    };

    try {
      final response = await http.post(url, headers: headers);
      if(response.statusCode == 201){
        final data = json.decode(response.body);
        final resultado = ResultadoDocumentoModel.fromJson(data['resultado']);
        return ApiResponse<ResultadoDocumentoModel>(
          statusCode: 201, 
          isSuccessful: true,
          errorMessages: null,
          resultado: resultado
        );
      } else {
        // Manejo de errores en caso de que no se tenga éxito
        final data = json.decode(response.body);
        final errorMessages = data['errorMessages'] != null
            ? List<String>.from(data['errorMessages'])
            : ['Ocurrió un error inesperado'];
        return ApiResponse<ResultadoDocumentoModel>(
          isSuccessful: false,
          statusCode: response.statusCode,
          errorMessages: errorMessages,
          resultado: null,
        );
      }
    } catch(e){
      return ApiResponse<ResultadoDocumentoModel>(
        isSuccessful: false,
        statusCode: 500, 
        errorMessages: ['An error ocurred: $e'],
        resultado: null
      );
    }
  }

  Future<ApiResponse<ResultadoGenericoMensaje>> actualizarConteoDocumentoSap(String docNum, String tipoDocumento) async {
    final url = Uri.parse('$_baseUrl/document/ActualizarConteoDocumento?docNum=$docNum&tipoDocumento=$tipoDocumento');
    // Recuperamos los tokens de sharedPreferences
    final token = await _authRepository.getToken();
    final tokenSAP = await _authRepository.getTokenSap();

    // Definamos las cabeceras, incluyendo los tokens si están disponibles
    final headers = {
      'Content-Type': 'application/json',
      if(token != null) 'Authorization': 'Bearer $token',
      if(tokenSAP != null) 'SessionID': tokenSAP
    };

    try {
      final response = await http.patch(url, headers: headers);
      if(response.statusCode == 200){
        final data = json.decode(response.body);
        final resultado = ResultadoGenericoMensaje.fromJson(data['resultado']);
        return ApiResponse<ResultadoGenericoMensaje>(
          statusCode: 201, 
          isSuccessful: true,
          errorMessages: null,
          resultado: resultado
        );
      } else {
        // Manejo de errores en caso de que no se tenga éxito
        final data = json.decode(response.body);
        final errorMessages = data['errorMessages'] != null
            ? List<String>.from(data['errorMessages'])
            : ['Ocurrió un error inesperado'];
        return ApiResponse<ResultadoGenericoMensaje>(
          isSuccessful: false,
          statusCode: response.statusCode,
          errorMessages: errorMessages,
          resultado: null,
        );
      }
    } catch(e){
      return ApiResponse<ResultadoGenericoMensaje>(
        isSuccessful: false,
        statusCode: 500, 
        errorMessages: ['An error ocurred: $e'],
        resultado: null
      );
    }
  }

  Future<ApiResponse<ResultadoGenericoMensaje>> actualizarConteoDocumentoTransferenciaStockSap(int docEntry, String tipoDocumento) async {
    String ruta = '$_baseUrl/document/ActualizarConteoDocumentoTransferenciaStock?docEntry=$docEntry&tipoDocumento=$tipoDocumento';
    final url = Uri.parse(ruta);
    // Recuperamos los tokens de sharedPreferences
    final token = await _authRepository.getToken();
    final tokenSAP = await _authRepository.getTokenSap();

    // Definamos las cabeceras, incluyendo los tokens si están disponibles
    final headers = {
      'Content-Type': 'application/json',
      if(token != null) 'Authorization': 'Bearer $token',
      if(tokenSAP != null) 'SessionID': tokenSAP
    };

    try {
      final response = await http.patch(url, headers: headers);
      if(response.statusCode == 200){
        final data = json.decode(response.body);
        final resultado = ResultadoGenericoMensaje.fromJson(data['resultado']);
        return ApiResponse<ResultadoGenericoMensaje>(
          statusCode: 201, 
          isSuccessful: true,
          errorMessages: null,
          resultado: resultado
        );
      } else {
        // Manejo de errores en caso de que no se tenga éxito
        final data = json.decode(response.body);
        final errorMessages = data['errorMessages'] != null
            ? List<String>.from(data['errorMessages'])
            : ['Ocurrió un error inesperado'];
        return ApiResponse<ResultadoGenericoMensaje>(
          isSuccessful: false,
          statusCode: response.statusCode,
          errorMessages: errorMessages,
          resultado: null,
        );
      }
    } catch(e){
      return ApiResponse<ResultadoGenericoMensaje>(
        isSuccessful: false,
        statusCode: 500, 
        errorMessages: ['An error ocurred: $e'],
        resultado: null
      );
    }
  }
}