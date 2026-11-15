import 'dart:async';
import 'dart:io';

import 'result.dart';
import 'token_store.dart';

// What both http repositories share: the Bearer header, the 401 flow and
// the catch of the "fallen road" / "surprise body" layers.
abstract class HttpRepositoryBase {
  HttpRepositoryBase(this.baseUrl, this.tokens, {this.onUnauthorized});

  final String baseUrl;
  final TokenStore tokens;
  final void Function()? onUnauthorized; // decided by the root: back to /login

  static const timeout = Duration(seconds: 8);

  Future<Map<String, String>> headers() async => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${await tokens.read() ?? ''}', // C8: Bearer
      };

  // 401 = the pass died: the token is thrown away (C9), the root navigates.
  // The repository does NOT import the router.
  Future<String> sessionDied() async {
    await tokens.clear();
    onUnauthorized?.call();
    return 'Сессия истекла — войдите снова';
  }

  // The three layers of failure (C8), each with its own tool:
  //  1) the road fell        -> throws, caught here by concrete types;
  //  2) the server's bad news -> does not throw, read via statusCode
  //                             inside each method + apiMessage;
  //  3) a surprise body      -> throws while parsing, caught here.
  // No generic catch (e): only the failures we expect become Err(msg).
  Future<Result<T>> guard<T>(Future<Result<T>> Function() request) async {
    try {
      return await request();
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
