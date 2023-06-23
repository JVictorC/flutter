import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'local_storage_interface.dart';

class LocalStorageAdapter implements ILocalStorage {
  late SharedPreferences _localStorage;

  LocalStorageAdapter();

  @override
  List<String>? getStringList({
    required String key,
  }) =>
      _localStorage.getStringList(key);

  @override
  Future<bool> setStringList({
    required String key,
    required List<String> value,
  }) async =>
      await _localStorage.setStringList(key, value);

  @override
  Future<void> init() async {
    _localStorage = await SharedPreferences.getInstance();
  }

  @override
  bool? getBool({required String key}) => _localStorage.getBool(key);

  @override
  int? getInt({required String key}) => _localStorage.getInt(key);

  @override
  String? getString({required String key}) => _localStorage.getString(key);

  @override
  Future<void> removeKey({required String key}) async {
    await _localStorage.remove(key);
  }

  @override
  Future<void> setBool(String key, {required bool value}) async {
    await _localStorage.setBool(key, value);
  }

  @override
  Future<void> setInt(String key, {required int value}) async {
    await _localStorage.setInt(key, value);
  }

  @override
  Future<void> setString(String key, {required String value}) async {
    await _localStorage.setString(key, value);
  }

  @override
  Map? getMap({required String key}) {
    String? encodedMap = _localStorage.getString(key);

    if (encodedMap != null) {
      Map decodedMap = json.decode(encodedMap);
      return decodedMap;
    }
  }

  @override
  Future<void> setMap({
    required String key,
    required Map map,
  }) async {
    String encodedMap = json.encode(map);
    await _localStorage.setString(key, encodedMap);
  }
}
