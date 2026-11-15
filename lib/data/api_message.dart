import 'dart:convert';

import 'package:http/http.dart' as http;

// The contract promises one body for every error:
//   {"error": {"code": "...", "message": "..."}}
// The code is stable and belongs to the program; the English message never
// reaches the screen — the Russian text is decided here, in one place.
String apiMessage(http.Response res) {
  try {
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    final error = body['error'] as Map<String, dynamic>;
    final code = error['code'] as String;

    return switch (code) {
      'VALIDATION_ERROR' => 'Отправленные данные недействительны',
      'UNAUTHORIZED' => 'Неверный email или пароль',
      'EMAIL_TAKEN' => 'Аккаунт с этим email уже существует',
      'NOT_FOUND' => 'Запись не существует',
      'SLOT_TAKEN' => 'Этот слот уже занят',
      _ => 'Ошибка сервера ($code)',
    };
  } on FormatException {
    // body outside the contract: e.g. a 500 with an HTML page
    return 'Ошибка сервера (${res.statusCode})';
  } on TypeError {
    // valid JSON, but not the promised envelope
    return 'Ошибка сервера (${res.statusCode})';
  }
}
