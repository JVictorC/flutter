import '../../modules/exams/domain/entities/patient_target_entity.dart';

class UserAuthInfoEntity {
  final String id;
  final String accessType;
  final String identifier;
  final String token;
  final String localization;
  final String userType;
  final PatientTargetEntity? patientTarget;

  UserAuthInfoEntity({
    required this.id,
    required this.accessType,
    required this.identifier,
    required this.token,
    required this.localization,
    required this.userType,
    required this.patientTarget,
  });
}
