import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

abstract class ISharedPreference {
  Future<bool> saveString(String key, String value);
  Future<bool> saveMap(String key, Map<String, dynamic> value);
  Future<String> getString(
    String key, [
    String defaultValue = '',
  ]);
  Future<Map<String, dynamic>> getMap(String key);
}

class SharedPreference implements ISharedPreference {
  @override
  Future<bool> saveString(String key, String value) async {
    final pref = await SharedPreferences.getInstance();
    return pref.setString(key, value);
  }

  @override
  Future<bool> saveMap(String key, Map<String, dynamic> value) async {
    return saveString(key, jsonEncode(value));
  }

  @override
  Future<String> getString(
    String key, [
    String defaultValue = '',
  ]) async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(key) ?? defaultValue;
  }

  @override
  Future<Map<String, dynamic>> getMap(String key) async {
    try {
      return jsonDecode(await getString(key));
    } catch (e) {
      return {};
    }
  }
}
