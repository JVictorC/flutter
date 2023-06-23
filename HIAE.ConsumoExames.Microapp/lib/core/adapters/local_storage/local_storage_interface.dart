abstract class ILocalStorage {
  Future<void> init();

  Future<bool> setStringList({
    required String key,
    required List<String> value,
  });

  List<String>? getStringList({
    required String key,
  });

  bool? getBool({
    required String key,
  });

  int? getInt({
    required String key,
  });

  String? getString({
    required String key,
  });

  Future<void> setBool(
    String key, {
    required bool value,
  });

  Future<void> setInt(
    String key, {
    required int value,
  });

  Future<void> setString(
    String key, {
    required String value,
  });

  Future<void> removeKey({
    required String key,
  });

  Future<void> setMap({
    required String key,
    required Map map,
  });

  Map? getMap({
    required String key,
  });
}
