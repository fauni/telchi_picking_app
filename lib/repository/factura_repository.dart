import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:picking_app/config/constants/environment.dart';
import 'package:picking_app/models/api_reponse_list_model.dart';
import 'package:picking_app/models/api_response_model.dart';
import 'package:picking_app/models/venta/resultado_orden_venta_model.dart';
import 'package:picking_app/repository/auth_repository.dart';
class FacturaRepository {
  final String _baseUrl = Environment.UrlApi;
  final AuthRepository _authRepository = AuthRepository();

  
  

  Future<ApiResponseList<ResultadoOrdenVentaModel>> obtenerFactura() async {
    final url = Uri.parse('$_baseUrl/invoice');

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
      final response = await http.get(url, headers: headers);

      if(response.statusCode == 200){
        
        final data = json.decode(response.body);
        
        // Verifica si la respuestsa contiene el campo resultado
        return ApiResponseList<ResultadoOrdenVentaModel>.fromJson(
          data,
          (item) => ResultadoOrdenVentaModel.fromJson(item),
        );
      } else {
        // Manejo de errores en caso de que no se tenga exito
        final data = json.decode(response.body);
        final errorMessage = data['errorMessages'] ?? 'An error ocurred';
        return ApiResponseList<ResultadoOrdenVentaModel> (
          isSuccessful: false,
          statusCode: response.statusCode,
          errorMessages: [errorMessage],
          resultado: null
        );
      }  
    } catch (e) {
      return ApiResponseList<ResultadoOrdenVentaModel>(
        isSuccessful: false,
        statusCode: 500,
        errorMessages: ['An error ocurred: $e'],
        resultado: null
      );
    }
  }

  Future<ApiResponseList<ResultadoOrdenVentaModel>> obtenerFacturaBySearch(String search) async {
    final url = Uri.parse('$_baseUrl/invoice?top=5&skip=0&search=$search');

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
      final response = await http.get(url, headers: headers);

      if(response.statusCode == 200){
        
        final data = json.decode(response.body);
        
        // Verifica si la respuestsa contiene el campo resultado
        return ApiResponseList<ResultadoOrdenVentaModel>.fromJson(
          data,
          (item) => ResultadoOrdenVentaModel.fromJson(item),
        );
      } else {
        // Manejo de errores en caso de que no se tenga exito
        final data = json.decode(response.body);
        final errorMessage = data['errorMessages'] ?? 'An error ocurred';
        return ApiResponseList<ResultadoOrdenVentaModel> (
          isSuccessful: false,
          statusCode: response.statusCode,
          errorMessages: [errorMessage],
          resultado: null
        );
      }  
    } catch (e) {
      return ApiResponseList<ResultadoOrdenVentaModel>(
        isSuccessful: false,
        statusCode: 500,
        errorMessages: ['An error ocurred: $e'],
        resultado: null
      );
    }
  }

  // Nuevo método para obtener una orden de venta específica por docNum
  Future<ApiResponse<ResultadoOrdenVentaModel>> obtenerFacturaPorDocNum(String docNum) async {
    final url = Uri.parse('$_baseUrl/invoice/GetInvoiceByDocNum/$docNum');

    final token = await _authRepository.getToken();
    final tokenSAP = await _authRepository.getTokenSap();

    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
      if (tokenSAP != null) 'SessionID': tokenSAP
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return ApiResponse<ResultadoOrdenVentaModel>.fromJson(
          data,
          (item) => ResultadoOrdenVentaModel.fromJson(item),
        );
      } else {
        final data = json.decode(response.body);
        final errorMessage = data['errorMessages'] ?? 'An error occurred';
        return ApiResponse<ResultadoOrdenVentaModel>(
          isSuccessful: false,
          statusCode: response.statusCode,
          errorMessages: [errorMessage],
          resultado: null,
        );
      }
    } catch (e) {
      return ApiResponse<ResultadoOrdenVentaModel>(
        isSuccessful: false,
        statusCode: 500,
        errorMessages: ['An error occurred: $e'],
        resultado: null,
      );
    }
  }
}