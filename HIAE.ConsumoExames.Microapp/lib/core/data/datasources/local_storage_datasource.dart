import '../../adapters/local_storage/local_storage_interface.dart';
import '../../constants/strings.dart';
import '../../entities/user_auth_info.dart';
import '../../extensions/translate_extension.dart';
import '../../infra/datasource/local_storage_datasource_interface.dart';
import '../../utils/local_storage_utils.dart';

class LocalStorageDataSource implements ILocalStorageDataSource {
  final ILocalStorage _localStorage;

  LocalStorageDataSource({required ILocalStorage localStorage})
      : _localStorage = localStorage;

  @override
  Map getData({
    required String key,
  }) =>
      _localStorage.getMap(key: key) as Map;

  @override
  bool getTermsCheckedFromLocalStorage() =>
      _localStorage.getBool(key: TERMS_UPLOAD_KEY) ?? false;

  @override
  Future<UserAuthInfoEntity?> getUser() async => getUserFromLocalStorage();

  @override
  String getIdentifier() => getUserIdentifier();

  @override
  Future<void> saveData({required String key, required Map map}) async {
    await _localStorage.setMap(key: key, map: map);
  }

  @override
  Future<void> setTermsCheckedOnStorage(bool isChecked) async {
    await _localStorage.setBool(TERMS_UPLOAD_KEY, value: isChecked);
  }

  @override
  Future<void> setUserOnStorage(UserAuthInfoEntity userAuth) async {
    await setUserOnStorage(userAuth);
  }

  @override
  Future<void> init() async {
    _localStorage.init();
  }

  @override
  bool getFirstEvolutionaryReport() {
    try {
      return _localStorage.getBool(key: 'evolutionary_report') ?? false;
    } catch (_) {
      throw LOCAL_STORAGE_INTERNAL_ERROR.translate();
    }
  }

  @override
  void setFirstEvolutionaryReport() {
    try {
      _localStorage.setBool('evolutionary_report', value: true);
    } catch (_) {
      throw LOCAL_STORAGE_INTERNAL_ERROR.translate();
    }
  }
}
