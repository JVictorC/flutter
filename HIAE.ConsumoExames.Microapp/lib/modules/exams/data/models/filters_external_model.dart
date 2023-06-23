import '../../../../core/extensions/date_time_extension.dart';
import '../../domain/entities/exams_filters_external_entity.dart';

// ignore: must_be_immutable
class FiltersExternalModel extends FiltersExternalEntity {
  FiltersExternalModel({
    required List<int>? examType,
    required String? examName,
    required DateTime? executionInitialDate,
    required DateTime? executionFinalDate,
  }) : super(
          examType: examType,
          examName: examName,
          executionInitialDate: executionInitialDate,
          executionFinalDate: executionFinalDate,
        );

  Map<String, dynamic> toMap() => {
        'examType': examType,
        'examName': examName,
        'executionDate_Inicial': executionInitialDate?.toJson(),
        'executionDate_Final': executionFinalDate?.toJson(),
      };

  factory FiltersExternalModel.fromEntity(FiltersExternalEntity entity) =>
      FiltersExternalModel(
        examType: entity.examType,
        examName: entity.examName,
        executionInitialDate: entity.executionInitialDate,
        executionFinalDate: entity.executionFinalDate,
      );
}
