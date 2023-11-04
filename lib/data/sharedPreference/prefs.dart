import 'dart:convert';

import 'helper.dart';
import 'keyConst.dart';

class Prefs {
  static Future<void> clear() async {
    PreferencesHelper.clearPrefs();
  }

  /// save token
  void saveToken(String token) async {
    removeToken();
    await PreferencesHelper.setString(Const.accessTokenKey, token);
  }

  Future<bool> removeToken() async {
    return await PreferencesHelper.removeKey(Const.accessTokenKey);
  }

  Future<String> getToken() async {
    return await PreferencesHelper.getString(Const.accessTokenKey);
  }
}
