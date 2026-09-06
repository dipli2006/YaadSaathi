import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'http_client_factory.dart';

class ApiException implements Exception {
  const ApiException(this.statusCode, this.message);

  final int statusCode;
  final String message;

  @override
  String toString() => message;
}

class ApiClient {
  ApiClient._();

  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:8000';
    }
    return 'http://127.0.0.1:8000';
  }

  static final http.Client _client = createHttpClient();
  static String? _cookieHeader;

  static String? get cookieHeader => _cookieHeader;
  static bool get hasSession => _cookieHeader != null && _cookieHeader!.isNotEmpty;

  static void setCookie(String? cookie) {
    if (cookie != null && cookie.isNotEmpty) {
      _cookieHeader = cookie;
    }
  }

  static void clearCookie() {
    _cookieHeader = null;
  }

  static Future<dynamic> get(String path) async {
    return _send('GET', path);
  }

  static Future<dynamic> post(String path, Map<String, dynamic> body) async {
    return _send('POST', path, body: body);
  }

  static Future<dynamic> patch(String path, [Map<String, dynamic>? body]) async {
    return _send('PATCH', path, body: body);
  }

  static Future<dynamic> _send(String method, String path, {Map<String, dynamic>? body}) async {
    final uri = Uri.parse('$baseUrl$path');
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (!kIsWeb && _cookieHeader != null && _cookieHeader!.isNotEmpty) {
      headers['Cookie'] = _cookieHeader!;
    }

    late http.Response response;
    final jsonString = body != null ? jsonEncode(body) : null;

    if (method == 'GET') {
      response = await _client.get(uri, headers: headers);
    } else if (method == 'POST') {
      response = await _client.post(uri, headers: headers, body: jsonString);
    } else if (method == 'PATCH') {
      response = await _client.patch(uri, headers: headers, body: jsonString);
    } else {
      throw ApiException(405, 'Method not allowed');
    }

    final setCookieHeader = response.headers['set-cookie'];
    if (setCookieHeader != null && setCookieHeader.contains('access_token')) {
      final parts = setCookieHeader.split(';');
      for (final part in parts) {
        if (part.trim().startsWith('access_token=')) {
          _cookieHeader = part.trim();
          break;
        }
      }
    }

    dynamic jsonResponse;
    if (response.body.isNotEmpty) {
      try {
        jsonResponse = jsonDecode(response.body);
      } catch (_) {
        jsonResponse = response.body;
      }
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonResponse;
    } else {
      String errorMessage = 'Request failed (${response.statusCode})';
      if (jsonResponse is Map && jsonResponse.containsKey('detail')) {
        final detail = jsonResponse['detail'];
        if (detail is String) {
          errorMessage = detail;
        } else if (detail is List) {
          errorMessage = detail.map((e) => e['msg'] ?? e.toString()).join(', ');
        }
      }
      throw ApiException(response.statusCode, errorMessage);
    }
  }
}
