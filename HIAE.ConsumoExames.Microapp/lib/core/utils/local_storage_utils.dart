import 'dart:convert';

import '../../modules/exams/domain/entities/patient_target_entity.dart';
import '../adapters/local_storage/local_storage_interface.dart';
import '../data/modules/user_auth_info_model.dart';
import '../di/initInjector.dart';
import '../entities/user_auth_info.dart';

const USER_KEY = 'USER';
const TERMS_UPLOAD_KEY = 'TERMS_UPLOAD_KEY';
const ONBOARD_KEY = 'ONBOARD_KEY';
const PARAMS_LOGIN = 'PARAMS_LOGIN';
const NEW_EXTERNAL_EXAM = 'NEW_EXTERNAL_EXAM';

void removeExternalIdStorage({required String id}) {
  final list = getExternalExamIdStorage();

  if (list != null) {
    list.removeWhere((element) => element == id);
    final storage = I.getDependency<ILocalStorage>();

    if (list.isNotEmpty) {
      storage.setStringList(key: NEW_EXTERNAL_EXAM, value: list);
    } else {
      storage.removeKey(key: NEW_EXTERNAL_EXAM);
    }
  }
}

List<String>? getExternalExamIdStorage() {
  final storage = I.getDependency<ILocalStorage>();
  final listData = storage.getStringList(key: NEW_EXTERNAL_EXAM);
  return listData;
}

Future<void> saveExternalExamIdStorage({required String id}) async {
  final storage = I.getDependency<ILocalStorage>();
  final listData = storage.getStringList(key: NEW_EXTERNAL_EXAM);

  if (listData != null) {
    if (!listData.any((element) => element == id)) {
      listData.add(id);
      await storage.setStringList(key: NEW_EXTERNAL_EXAM, value: listData);
    }
  } else {
    await storage.setStringList(key: NEW_EXTERNAL_EXAM, value: [id]);
  }
}

UserAuthInfoEntity? getUserFromLocalStorage() {
  final storage = I.getDependency<ILocalStorage>();
  final userEncoded = storage.getString(key: USER_KEY);

  return userEncoded != null
      ? UserAuthInfoModel.fromJson(jsonDecode(userEncoded))
      : null;
}

String? getTokenUser() {
  final storage = I.getDependency<ILocalStorage>();
  final userEncoded = storage.getString(key: USER_KEY);

  if (userEncoded != null) {
    final userToken = UserAuthInfoModel.fromJson(userEncoded);

    return userToken.token;
  }
}

Future<Map<String, dynamic>> getDataLoginParams() async {
  final storage = I.getDependency<ILocalStorage>();
  final data = storage.getString(key: PARAMS_LOGIN);
  final dataDecode = jsonDecode(data!);
  return dataDecode;
}

Future<void> setDataLoginParams(Map<String, String> data) async {
  final storage = I.getDependency<ILocalStorage>();
  final paramEncode = json.encode(data);
  await storage.setString(PARAMS_LOGIN, value: paramEncode);
}

Future<void> setUserOnStorage(UserAuthInfoEntity userAuth) async {
  final storage = I.getDependency<ILocalStorage>();
  final userEncoded = UserAuthInfoModel.fromEntity(entity: userAuth).toJson();

  await storage.setString(USER_KEY, value: userEncoded);
}

PatientTargetEntity getPatientTargetStorage() {
  final storage = I.getDependency<ILocalStorage>();
  final userEncoded = storage.getString(key: USER_KEY);
  final authentication = UserAuthInfoModel.fromJson(userEncoded!);

  return authentication.patientTarget!;
}

String getIdPatient() {
  final storage = I.getDependency<ILocalStorage>();
  final userEncoded = storage.getString(key: USER_KEY);
  final authentication = UserAuthInfoModel.fromJson(userEncoded!);

  return authentication.accessType.trim().toUpperCase() == 'DOCTOR'
      ? authentication.patientTarget!.id
      : authentication.identifier;
}

String getUserIdentifier() {
  final storage = I.getDependency<ILocalStorage>();
  final userEncoded = storage.getString(key: USER_KEY);

  final authentication = UserAuthInfoModel.fromJson(userEncoded!);

  return authentication.identifier;
}

Future<void> removeUserFromStorage() async {
  final storage = I.getDependency<ILocalStorage>();
  await storage.removeKey(key: USER_KEY);
}

Future<bool> getTermsCheckedFromLocalStorage() async {
  final storage = I.getDependency<ILocalStorage>();
  final isTermChecked = storage.getBool(key: TERMS_UPLOAD_KEY);

  return isTermChecked ?? false;
}

Future<void> setTermsCheckedOnStorage(bool isChecked) async {
  final storage = I.getDependency<ILocalStorage>();
  await storage.setBool(TERMS_UPLOAD_KEY, value: isChecked);
}

Future<bool> getCheckOnboardingLocalStorage() async {
  final storage = I.getDependency<ILocalStorage>();
  final isChecked = storage.getBool(key: ONBOARD_KEY);

  return isChecked ?? false;
}

Future<void> setCheckOnboardingLocalStorage(bool isChecked) async {
  final storage = I.getDependency<ILocalStorage>();
  await storage.setBool(ONBOARD_KEY, value: isChecked);
}
