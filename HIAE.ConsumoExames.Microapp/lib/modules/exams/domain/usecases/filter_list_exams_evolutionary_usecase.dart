import '../../../../core/extensions/string_extension.dart';
import '../entities/exams_medical_records_entity.dart';

abstract class IFilterListExamsEvolutionaryUseCase {
  Map<String, List<ExamsMedicalRecordsEntity>> call({
    required Map<String, List<ExamsMedicalRecordsEntity>> data,
    required String? filter,
  });
}

class FilterListExamsEvolutionaryUseCase
    implements IFilterListExamsEvolutionaryUseCase {
  @override
  Map<String, List<ExamsMedicalRecordsEntity>> call({
    required Map<String, List<ExamsMedicalRecordsEntity>> data,
    required String? filter,
  }) {
    if (filter != null) {
      final Map<String, List<ExamsMedicalRecordsEntity>> localData = {};

      data.forEach(
        (key, value) {
          final valueFiltered = value
              .where(
                (element) => element.examName
                    .trim()
                    .withoutDiacriticalMarks
                    .toUpperCase()
                    .contains(
                      filter.trim().withoutDiacriticalMarks.toUpperCase(),
                    ),
              )
              .toList();

          if (valueFiltered.isNotEmpty) {
            localData.addAll({key: valueFiltered});
          }
        },
      );

      return localData;
    } else {
      return data;
    }
  }
}
