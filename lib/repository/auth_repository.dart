import 'dart:convert';

import 'package:picking_app/models/almacen/almacen_model.dart';
import 'package:picking_app/models/api_response_model.dart';
import 'package:picking_app/models/auth/login_model.dart';
import 'package:picking_app/models/auth/resultado_login_model.dart';
import 'package:picking_app/models/auth/usuario_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/constants/environment.dart';
import 'package:http/http.dart' as http;


class AuthRepository {
  final String _baseUrl = Environment.UrlApi;

  Future<void> setOtherTokenSap() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token_sap', 'asdasdsadsad123123asdsa');
  }
  Future<void> saveUserData(Usuario usuario, String token, String tokenSAP) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('usuario', jsonEncode(usuario));
    await prefs.setString('token', token);
    await prefs.setString('token_sap', tokenSAP);
    await prefs.setString('almacenes', jsonEncode(usuario.almacenes));
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

  Future<List<Almacen>> getAlmacenesUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('almacenes');
    if(data == null){return[];}
    // Decodificamos la cadena JSON
    final List<dynamic> jsonList = jsonDecode(data);
    // Convertimos cada elemento del JSON en una instancia de Almacen
    final almacenes = jsonList.map((item) => Almacen.fromJson(item)).toList();
    return almacenes;
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

  /// Método para verificar si el usuario está autenticado
  Future<bool> checkAuthentication() async {
    final token = await getToken();
    final user = await getUserData();

    // Si hay un token válido y datos de usuario, se considera autenticado
    if (token != null && token.isNotEmpty && user != null) {
      // Aquí puedes agregar lógica adicional para verificar la validez del token, 
      // como realizar una llamada a un endpoint para validar el token.
      return true;
    }

    // Si no hay token o datos de usuario, no está autenticado
    return false;
  }
}