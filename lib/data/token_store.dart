import 'package:shared_preferences/shared_preferences.dart';

// the pass (JWT) on top of shared_preferences: the rest of the app
// does not know where the token sleeps.
// The password is NEVER stored locally — the token is replaceable and expires.
class TokenStore {
  static const _key = 'auth_token'; // the key: a constant, in one place

  // null = not logged in
  Future<String?> read() async =>
      (await SharedPreferences.getInstance()).getString(_key);

  // login / register -> setString
  Future<void> save(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, token);
  }

  // logout AND 401: a dead pass is thrown away
  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
