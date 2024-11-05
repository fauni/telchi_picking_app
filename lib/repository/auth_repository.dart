import 'dart:convert';

import 'package:picking_app/models/api_response_model.dart';
import 'package:picking_app/models/auth/login_model.dart';
import 'package:picking_app/models/auth/resultado_login_model.dart';

import '../config/constants/environment.dart';
import 'package:http/http.dart' as http;


class AuthRepository {
  final String _baseUrl = Environment.UrlApi;

  Future<ApiResponse<ResultadoLogin>> login(Login data) async {
    final url = Uri.parse('$_baseUrl/Auth/login');
    final body = jsonEncode(data);
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: body,
    );
    if(response.statusCode == 200){
      // Parsear ña respuesta utilizando ApiResponse con el tipo ResultadoLogin
      final parsedJson = json.decode(response.body);
      return ApiResponse<ResultadoLogin>.fromJson(parsedJson, ResultadoLogin.fromJson);
    } else {
      // Manejo de errores en caso de que el login no sea exitoso
      final parsedJson = json.decode(response.body);
      final errorMessage = parsedJson['erroMessages'] ?? 'An error ocurred';
      return ApiResponse<ResultadoLogin> (
        isSuccessful: false,
        statusCode: response.statusCode,
        errorMessages: [errorMessage],
        resultado: null
      );
    }
  }
}