import '../../../../core/extensions/date_time_extension.dart';
import '../../domain/entities/evolutionary_report_request_entity.dart';

class EvolutionaryReportRequestModel extends EvolutionaryReportRequestEntity {
  EvolutionaryReportRequestModel({
    required final String? chAuthentication,
    required final DateTime? initialDate,
    required final DateTime? finalDate,
    required final String medicalAppointment,
    required final String examCode,
    required final int numberOfRecords,
  }) : super(
          chAuthentication: chAuthentication,
          initialDate: initialDate,
          finalDate: finalDate,
          medicalAppointment: medicalAppointment,
          examCode: examCode,
          numberOfRecords: numberOfRecords,
        );

  Map<String, dynamic> toMap() => {
        'chAuthentication': chAuthentication,
        'examCode': examCode,
        'initialDate': initialDate?.toJson(),
        'finalDate': finalDate?.toJson(),
        'medicalAppointment': medicalAppointment,
        'numberOfRecords': numberOfRecords,
      };

  factory EvolutionaryReportRequestModel.fromEntity({
    required EvolutionaryReportRequestEntity entity,
  }) =>
      EvolutionaryReportRequestModel(
        chAuthentication: entity.chAuthentication,
        examCode: entity.examCode,
        finalDate: entity.finalDate,
        initialDate: entity.initialDate,
        medicalAppointment: entity.medicalAppointment,
        numberOfRecords: entity.numberOfRecords,
      );
}
