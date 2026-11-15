import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'api_message.dart';
import 'result.dart';
import 'token_store.dart';

// register / login against the backend contract; the token goes to TokenStore
class AuthApi {
  AuthApi(this.baseUrl, this.tokens);

  final String baseUrl;
  final TokenStore tokens;

  static const _timeout = Duration(seconds: 8);

  Future<Result<void>> register(String email, String password, String name) =>
      _post('/auth/register', {'email': email, 'password': password, 'name': name});

  Future<Result<void>> login(String email, String password) =>
      _post('/auth/login', {'email': email, 'password': password});

  Future<void> logout() => tokens.clear();

  // register and login differ only by path and body — one _post serves both
  Future<Result<void>> _post(String path, Map<String, Object?> body) async {
    try {
      final res = await http
          .post(
            Uri.parse('$baseUrl$path'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(_timeout);

      // layer 2: the server's bad news does not throw — read it from the status
      if (res.statusCode != 200 && res.statusCode != 201) {
        return Err(apiMessage(res)); // 400 / 401 / 409, from the envelope
      }

      final data = jsonDecode(res.body) as Map<String, dynamic>;
      await tokens.save(data['token'] as String); // login -> setString
      return const Ok(null);

      // layer 1: the road fell — caught by concrete types
    } on SocketException {
      return const Err('Нет сети — повторите попытку');
    } on TimeoutException {
      return const Err('Сервер не отвечает');
      // layer 3: a surprise body — fails while parsing
    } on FormatException {
      return const Err('Ответ не тот, что обещан');
    } on TypeError {
      return const Err('Ответ не тот, что обещан');
    }
  }
}
