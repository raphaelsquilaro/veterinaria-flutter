import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Android Emulator:
  // 10.0.2.2 aponta para o localhost da máquina.
  //
  // Se estiver usando celular físico,
  // troque pelo IP da máquina na rede.
  static const String baseUrl = 'http://10.0.2.2:8080';

  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  Future<List<dynamic>> getList(String endpoint) async {
    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: defaultHeaders,
    );

    _checkResponse(response);

    return jsonDecode(response.body) as List<dynamic>;
  }

  Future<Map<String, dynamic>> get(String endpoint) async {
    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: defaultHeaders,
    );

    _checkResponse(response);

    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: defaultHeaders,
      body: jsonEncode(body),
    );

    _checkResponse(response);

    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> put(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final response = await http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: defaultHeaders,
      body: jsonEncode(body),
    );

    _checkResponse(response);

    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<void> delete(String endpoint) async {
    final response = await http.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: defaultHeaders,
    );

    _checkResponse(response);
  }

  void _checkResponse(http.Response response) {
    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      return;
    }

    String message = 'Erro na comunicação com o servidor.';

    try {
      final body = jsonDecode(response.body);

      if (body is Map<String, dynamic> &&
          body['message'] != null) {
        message = body['message'].toString();
      }
    } catch (_) {
      // Mantém a mensagem padrão.
    }

    throw Exception(
      '$message Código: ${response.statusCode}',
    );
  }
}