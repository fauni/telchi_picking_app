import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:picking_app/config/constants/environment.dart';
import 'package:picking_app/models/api_reponse_list_model.dart';
import 'package:picking_app/models/api_response_model.dart';
import 'package:picking_app/models/traslado/resultado_solicitud_traslado.dart';
import 'package:picking_app/repository/auth_repository.dart';

class TransferenciaStockRepository {
  final String _baseUrl = Environment.UrlApi;
  final AuthRepository _authRepository = AuthRepository();
  
  Future<ApiResponseList<SolicitudTraslado>> obtenerTransferenciasStock(int pageNumber, int pageSize, {String? search, DateTime? docDate}) async {

    // Construcción dinámica de la URL con filtros opcionales
    final queryParams = {
      'pageNumber': '$pageNumber',
      'pageSize': '$pageSize',
      if(search != null) 'search': search,
      if(docDate != null) 'docDate': docDate.toIso8601String(),
    };

    final url = Uri.parse('$_baseUrl/transferenciastock').replace(queryParameters: queryParams);

    final token = await _authRepository.getToken();
    final tokenSAP = await _authRepository.getTokenSap();

    final headers = {
      'Content-Type': 'application/json',
      if(token != null) 'Authorization': 'Bearer $token',
      if(tokenSAP != null) 'SessionID': tokenSAP
    };

    try {
      final response = await http.get(url, headers: headers);

      if(response.statusCode == 200){
        final data = json.decode(response.body);
        return ApiResponseList<SolicitudTraslado>.fromJson(
          data,
          (item) => SolicitudTraslado.fromJson(item),
        );
      } else {
        return ApiResponseList<SolicitudTraslado>(
          isSuccessful: false,
          statusCode: response.statusCode
        );
      }

    } catch (e) {
      return ApiResponseList<SolicitudTraslado>(
        isSuccessful: false,
        statusCode: 500,
      );
    }
  }

  Future<ApiResponse<SolicitudTraslado>> obtenerTransferenciaStockPorId(int id) async {
    final url = Uri.parse('$_baseUrl/transferenciastock/$id');

    final token = await _authRepository.getToken();
    final tokenSAP = await _authRepository.getTokenSap();

    final headers = {
      'Content-Type': 'application/json',
      if(token != null) 'Authorization': 'Bearer $token',
      if(tokenSAP != null) 'SessionID': tokenSAP
    };

    try {
      final response = await http.get(url, headers: headers);

      if(response.statusCode == 200){
        final data = json.decode(response.body);
        return ApiResponse<SolicitudTraslado>.fromJson(
          data,
          (item) => SolicitudTraslado.fromJson(item),
        );
      } else {        
        return ApiResponse<SolicitudTraslado>(
          isSuccessful: false,
          statusCode: response.statusCode
        );
      }

    } catch (e) {
      return ApiResponse<SolicitudTraslado>(
        isSuccessful: false,
        statusCode: 500,
      );
    }
  }
}