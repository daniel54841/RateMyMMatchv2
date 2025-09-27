import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:rate_my_match_v2/utils/app_string.dart';

import 'api_exception.dart'; // Importa tus excepciones personalizadas

class ApiClient extends GetxService {
  ///
  final String _apiKey = "123";
  ///
  final String _baseUrl;
  ///
  final http.Client _httpClient;
  ///
  final Logger _logger;
  ///
  ApiClient({http.Client? httpClient,required Logger logger})
      : _httpClient = httpClient ?? http.Client(),
        _baseUrl = 'https://www.thesportsdb.com/api/v1/json/',
        _logger = logger;

  Future<ApiClient> init() async {
    _logger.i("ApiClient inicializado para TheSportsDB");
    return this;
  }

  Map<String, String> _getDefaultHeaders() {
    return {
      'Accept': 'application/json',
    };
  }

  /// Método genérico para construir la URL completa con la API Key y el endpoint
  Uri _buildUri(String endpoint, {Map<String, dynamic>? queryParameters}) {
    final path = '$_apiKey/$endpoint';
    final uri = Uri.parse('$_baseUrl$path');
    if (queryParameters != null && queryParameters.isNotEmpty) {
      return uri.replace(queryParameters: queryParameters);
    }
    return uri;
  }

  Future<dynamic> get(String endpoint, {Map<String, dynamic>? queryParameters}) async {
    final uri = _buildUri(endpoint, queryParameters: queryParameters);
    _logger.i('GET Request: $uri');

    try {
      final response = await _httpClient.get(
        uri,
        headers: _getDefaultHeaders(),
      ).timeout(const Duration(seconds: 20)); // Aumentar timeout si es necesario
      return _processResponse(response);
    } on TimeoutException {
      throw NetworkException(AppString.timeOutExceptionMessage);
    } on http.ClientException catch (e) {
      _logger.e('ClientException en GET: ${e.message}');
      throw NetworkException(AppString.networkExceptionMessage);
    } catch (e) {
      // Para errores inesperados antes de _processResponse
      _logger.i('Error desconocido en GET: $e');
      if (e is ApiException) rethrow; // Si ya es una de nuestras excepciones
      throw ApiException(AppString.unexpectedExceptionMessage);
    }
  }

  dynamic _processResponse(http.Response response) {
    final String responseBody = utf8.decode(response.bodyBytes);
    _logger.i('Response Status: ${response.statusCode}');
    // Loguear solo una parte del body si es muy largo
    _logger.i('Response Body incomplete to optimize: ${responseBody.substring(0, responseBody.length > 300 ? 300 : responseBody.length)}...');

    final decodedJson = responseBody.isNotEmpty ? jsonDecode(responseBody) : null;

    switch (response.statusCode) {
      case 200:
        if (decodedJson == null) {
          _logger.i("Warning: Received empty body for a 200 response from ${response.request?.url}");
        }
        return decodedJson;
      case 400:
        throw BadRequestException('Bad Request', responseData: decodedJson);
      case 401:
      case 403:
        throw UnauthorizedException('Unauthorized or Forbidden');
      case 404:
        throw NotFoundException('Resource not found', responseData: decodedJson);
      default:
        throw ApiException(
          'Error connecting to server (Code: ${response.statusCode})',
          statusCode: response.statusCode,
          responseData: decodedJson,
        );
    }
  }


}
