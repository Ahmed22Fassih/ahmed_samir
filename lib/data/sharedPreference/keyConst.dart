import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper {
  static Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  static Future<bool> getBool(String key, {bool defaultValue = false}) async {
    final p = await prefs;
    return p.getBool(key) ?? defaultValue;
  }

  static Future setBool(String key, bool value) async {
    final p = await prefs;
    p.setBool(key, value);
    return p.commit();
  }

  static Future<int> getInt(String key) async {
    final p = await prefs;
    return p.getInt(key) ?? 0;
  }

  static Future setInt(String key, int value) async {
    final p = await prefs;
    return p.setInt(key, value);
  }

  static Future<String> getString(String key,
      {String defaultValue = ''}) async {
    final p = await prefs;
    return p.getString(key) ?? defaultValue;
  }

  static Future setString(String key, String value) async {
    final p = await prefs;
    return p.setString(key, value);
  }

  static Future<bool> removeKey(String key) async {
    final p = await prefs;
    return p.remove(key);
  }

  static Future<double> getDouble(String key) async {
    final p = await prefs;
    return p.getDouble(key) ?? 0.0;
  }

  static Future setDouble(String key, double value) async {
    final p = await prefs;
    return p.setDouble(key, value);
  }

  static void clearPrefs() async {
    await prefs.then((value) => {value.clear()});
  }
}
