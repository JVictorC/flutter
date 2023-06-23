import '../../domain/entities/patient_target_entity.dart';

class PatientTargetModel extends PatientTargetEntity {
  PatientTargetModel({
    required String name,
    required final String id,
  }) : super(
          name: name,
          id: id,
        );

  Map<String, dynamic> toMap() => {
        'name': name,
        'id': id,
      };

  factory PatientTargetModel.fromMap(Map<String, dynamic> map) =>
      PatientTargetModel(
        id: map['id'],
        name: map['name'],
      );

  factory PatientTargetModel.fromEntity({
    required PatientTargetEntity entity,
  }) =>
      PatientTargetModel(
        id: entity.id,
        name: entity.name,
      );
}
