import '../../entities/user_auth_info.dart';

abstract class ILocalStorageDataSource {
  bool getFirstEvolutionaryReport();
  void setFirstEvolutionaryReport();
  Future<void> init();
  Future<UserAuthInfoEntity?> getUser();
  Future<void> setUserOnStorage(UserAuthInfoEntity userAuth);
  bool getTermsCheckedFromLocalStorage();
  Future<void> setTermsCheckedOnStorage(bool isChecked);
  String getIdentifier();
  Future<void> saveData({
    required String key,
    required Map map,
  });
  Map getData({
    required String key,
  });
}
