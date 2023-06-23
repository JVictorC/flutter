import '../../../../core/exceptions/exceptions.dart';
import '../../../../core/utils/result.dart';
import '../entities/exams_medical_records_entity.dart';
import '../repositories/exam_repository_interface.dart';

abstract class IListExamsGroupUseCase {
  Future<Result<Failure, Map<String, List<ExamsMedicalRecordsEntity>>>> call({
    required DateTime? dateInitial,
    required DateTime? dateFinal,
  });
}

class ListExamsGroupUseCase implements IListExamsGroupUseCase {
  final IExamRepository _repository;

  ListExamsGroupUseCase({required IExamRepository repository})
      : _repository = repository;

  @override
  Future<Result<Failure, Map<String, List<ExamsMedicalRecordsEntity>>>> call({
    required DateTime? dateInitial,
    required DateTime? dateFinal,
  }) async {
    Map<String, List<ExamsMedicalRecordsEntity>> mapData = {};
    const int fiveYearsInDays = 1825;

    dateInitial ??= DateTime.now().subtract(
      const Duration(days: fiveYearsInDays),
    );

    dateFinal ??= DateTime.now();

    final result = await _repository.getAllExamsMedicalRecords(
      dateInitial: dateInitial,
      dateFinal: dateFinal,
    );

    if (result.isSuccess) {
      final List<ExamsMedicalRecordsEntity> copyList = [...result.value!];

      for (var item in result.value!) {
        final List<ExamsMedicalRecordsEntity> sortList = [
          ...copyList
              .where((element) => element.itemCategory == item.itemCategory)
              .toList(),
        ];

        sortList.sort(
          (a, b) => a.examName.compareTo(b.examName),
        );

        mapData.putIfAbsent(
          item.itemCategory,
          () => sortList,
        );

        copyList.removeWhere(
          (element) => element.itemCategory == item.itemCategory,
        );
      }
      return Result.success(mapData);
    } else {
      return Result.failure(result.error);
    }
  }
}
