import 'dart:convert';

import 'package:picking_app/config/constants/environment.dart';
import 'package:picking_app/models/api_reponse_list_model.dart';
import 'package:picking_app/models/conteo/conteo_model.dart';
import 'package:picking_app/repository/auth_repository.dart';
import 'package:http/http.dart' as http;

class ConteoRepository {
  final String _baseUrl = Environment.UrlApi;
  final AuthRepository _authRepository = AuthRepository();

  Future<ApiResponseList<Conteo>> obtenerConteosPorUsuario() async {
    final user = await _authRepository.getUserData();
    final url = Uri.parse('$_baseUrl/conteo/${user!.usuarioNombre}');

    final headers = {
      'Content-Type': 'application/json'
    };

    try{
      final response = await http.get(url, headers: headers);
      if(response.statusCode == 200){
        final data = json.decode(response.body);
        return ApiResponseList<Conteo>.fromJson(
          data, 
          (item) => Conteo.fromJson(item)
        );
      } else {
        // Manejo de errores en caso de que no se tenga éxito
        // final data = json.decode(response.body);
        // final errorMessage = data['errorMessages'] ?? 'An error ocurred';
        return ApiResponseList<Conteo>(
          statusCode: response.statusCode, 
          isSuccessful: false);
      }
    } catch (e) {
      return ApiResponseList<Conteo>(
        isSuccessful: false,
        statusCode: 500,
        // errorMessages: ['An error ocurred: $e'],
        // resultado: null
      );
    }
  }
}