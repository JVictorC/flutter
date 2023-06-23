// ignore_for_file: must_be_immutable

import '../../../../core/extensions/date_time_extension.dart';
import '../../domain/entities/exams_filters_entity.dart';

class ExamFiltersModel extends ExamFiltersEntity {
  ExamFiltersModel({
    List<int>? examType,
    List<int>? passType,
    List<int>? statusResult,
    DateTime? executionInitialDate,
    DateTime? executionFinalDate,
    List<String>? unity,
    String? examName,
  }) : super(
          examType: examType,
          passType: passType,
          executionInitialDate: executionInitialDate,
          executionFinalDate: executionFinalDate,
          unity: unity,
          examName: examName,
          statusResult: statusResult,
        );

  Map<String, dynamic> toMap() => {
        'examName': examName,
        'examType': examType,
        'passType': passType,
        'statusResult': statusResult,
        'executionDate_Inicial': executionInitialDate?.toJson(),
        'executionDate_Final': executionFinalDate?.toJson(),
        'unity': unity ?? [],
      };
  factory ExamFiltersModel.fromEntity(ExamFiltersEntity entity) =>
      ExamFiltersModel(
        examName: entity.examName,
        examType: entity.examType,
        executionInitialDate: entity.executionInitialDate,
        executionFinalDate: entity.executionFinalDate,
        passType: entity.passType,
        unity: entity.unity,
        statusResult: entity.statusResult,
      );
}
