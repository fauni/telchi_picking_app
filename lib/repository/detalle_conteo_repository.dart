import 'dart:convert';

import 'package:picking_app/config/constants/environment.dart';
import 'package:picking_app/models/api_reponse_list_model.dart';
import 'package:picking_app/models/conteo/detalle_conteo_model.dart';
import 'package:http/http.dart' as http;

class DetalleConteoRepository {
  final String _baseUrl = Environment.UrlApi;
  
  Future<ApiResponseList<DetalleConteo>> obtenerDetalleConteoPorId(int conteoId) async {
    final url = Uri.parse('$_baseUrl/conteo/detalles/$conteoId');
    
    final headers = {
      'Content-Type': 'application/json'
    };

    try {
      final response = await http.get(url, headers: headers);
      if(response.statusCode == 200){
        final data = json.decode(response.body);
        return ApiResponseList<DetalleConteo>.fromJson(
          data,
          (item) => DetalleConteo.fromJson(item)
        );
      } else {
        // final data = json.decode(response.body);
        return ApiResponseList<DetalleConteo>(
          statusCode: response.statusCode, 
          isSuccessful: false
        );
      }
    } catch (e) {
      return ApiResponseList<DetalleConteo>(
        isSuccessful: true,
        statusCode: 500
      );
    }
  }
}