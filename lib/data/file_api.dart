import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'api_message.dart';
import 'result.dart';
import 'token_store.dart';

// multipart upload to POST /files (field "file", max 5 MB -> otherwise 400)
class FileApi {
  FileApi(this.baseUrl, this.tokens);

  final String baseUrl;
  final TokenStore tokens;

  // -> Ok("/files/7"): a RELATIVE url, stored on the entity as is
  Future<Result<String>> upload(String path) async {
    try {
      final req = http.MultipartRequest('POST', Uri.parse('$baseUrl/files'))
        ..headers['Authorization'] = 'Bearer ${await tokens.read() ?? ''}'
        ..files.add(await http.MultipartFile.fromPath('file', path));

      // timeout ON send(): otherwise a server frozen DURING the transfer
      // would never expire
      final res = await http.Response.fromStream(
        await req.send().timeout(const Duration(seconds: 20)),
      );
      if (res.statusCode != 201) return Err(apiMessage(res));

      final data = jsonDecode(res.body) as Map<String, dynamic>;
      return Ok(data['url'] as String);
    } on SocketException {
      return const Err('Нет сети — повторите попытку');
    } on TimeoutException {
      return const Err('Сервер не отвечает');
    } on FormatException {
      return const Err('Ответ не тот, что обещан');
    } on TypeError {
      return const Err('Ответ не тот, что обещан');
    }
  }
}
