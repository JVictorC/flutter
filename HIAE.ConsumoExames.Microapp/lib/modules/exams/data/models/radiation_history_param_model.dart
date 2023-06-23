// ignore_for_file: public_member_api_docs, sort_constructors_first

import '../../domain/entities/radiation_history_param_entity.dart';

class RadiationHistoryParamModel {
  final int medicalAppointment;
  final String? examCode;
  final String? examGroup;

  RadiationHistoryParamModel({
    required this.medicalAppointment,
    required this.examCode,
    this.examGroup,
  });

  factory RadiationHistoryParamModel.fromEntity(
    RadiationHistoryParamEntity entity,
  ) =>
      RadiationHistoryParamModel(
        medicalAppointment: entity.medicalAppointment,
        examCode: entity.examCode,
        examGroup: entity.examGroup,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'medicalAppointment': medicalAppointment,
        'examCode': examCode,
        'examGroup': examGroup,
      };
}
