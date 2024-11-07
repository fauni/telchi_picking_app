import 'dart:convert';

import 'package:picking_app/models/api_response_model.dart';
import 'package:picking_app/models/auth/login_model.dart';
import 'package:picking_app/models/auth/resultado_login_model.dart';
import 'package:picking_app/models/auth/usuario_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/constants/environment.dart';
import 'package:http/http.dart' as http;


class AuthRepository {
  final String _baseUrl = Environment.UrlApi;

  Future<void> saveUserData(Usuario usuario, String token, String tokenSAP) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('usuario', jsonEncode(usuario));
    await prefs.setString('token', token);
    await prefs.setString('token_sap', tokenSAP);
  }

  Future<Usuario?> getUserData()async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('usuario');

    if(data != null){
      try {
        return Usuario.fromJson(jsonDecode(data));   
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('token');
    return data;
  }
  Future<String?> getTokenSap() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('token_sap');
    return data;
  }

  Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('usuario');
    await prefs.remove('token');
    await prefs.remove('token_sap');
  }

  Future<ApiResponse<ResultadoLogin>> login(Login data) async {
    final url = Uri.parse('$_baseUrl/Auth/login');
    final body = jsonEncode(data);

    try {
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
        final errorMessage = parsedJson['errorMessages'] ?? 'An error ocurred';
        return ApiResponse<ResultadoLogin> (
          isSuccessful: false,
          statusCode: response.statusCode,
          errorMessages: [errorMessage],
          resultado: null
        );
      }
    } catch (e) {
      // Manejo de excepciones para errores de red u otros
      return ApiResponse<ResultadoLogin>(
        isSuccessful: false,
        statusCode: 500,
        errorMessages: ['An error ocurred: $e'],
        resultado: null
      );
    }
  }
}