import 'dart:convert';

import '../../../modules/exams/data/models/patient_target_model.dart';
import '../../../modules/exams/domain/entities/patient_target_entity.dart';
import '../../entities/user_auth_info.dart';

class UserAuthInfoModel extends UserAuthInfoEntity {
  UserAuthInfoModel({
    required String id,
    required String accessType,
    required String identifier,
    required String token,
    required String localization,
    required String userType,
    required PatientTargetEntity? patientTarget,
  }) : super(
          id: id,
          accessType: accessType,
          identifier: identifier,
          token: token,
          localization: localization,
          userType: userType,
          patientTarget: patientTarget,
        );

  Map<String, dynamic> toMap() => {
        'id': id,
        'accessType': accessType,
        'identifier': identifier,
        'token': token,
        'localization': localization,
        'patientTarget': patientTarget != null
            ? PatientTargetModel.fromEntity(entity: patientTarget!).toMap()
            : null,
      };

  factory UserAuthInfoModel.fromMap(Map<String, dynamic> map) =>
      UserAuthInfoModel(
        accessType: map['accessType'],
        identifier: map['identifier'],
        id: map['id'],
        token: map['token'] ?? '',
        localization: map['localization'] ?? '',
        userType: map['userType'] ?? '',
        patientTarget: map['patientTarget'] != null
            ? PatientTargetModel.fromMap(map['patientTarget'])
            : null,
      );

  factory UserAuthInfoModel.fromEntity({required UserAuthInfoEntity entity}) =>
      UserAuthInfoModel(
        accessType: entity.accessType,
        identifier: entity.identifier,
        token: entity.token,
        id: entity.id,
        localization: entity.localization,
        userType: entity.userType,
        patientTarget: entity.patientTarget,
      );

  factory UserAuthInfoModel.fromJson(String source) =>
      UserAuthInfoModel.fromMap(json.decode(source));

  String toJson() => json.encode(toMap());
}
