import '../../../../core/exceptions/exceptions.dart';
import '../../../../core/utils/result.dart';
import '../entities/evolutionary_report_response_entity.dart';
import '../repositories/exam_repository_interface.dart';

abstract class IGetMapEvolutiveReportUseCase {
  Future<Result<Failure, EvolutionaryReportExamsEntity>> call({
    required Map<String, List<String>> mapExams,
  });
}

class GetMapEvolutiveReportUseCase implements IGetMapEvolutiveReportUseCase {
  final IExamRepository _repository;

  GetMapEvolutiveReportUseCase({
    required IExamRepository repository,
  }) : _repository = repository;

  @override
  Future<Result<Failure, EvolutionaryReportExamsEntity>> call({
    required Map<String, List<String>> mapExams,
  }) async {
    final List<String> listExamCode = [];

    for (var item in mapExams.values) {
      listExamCode.addAll(item);
    }
    final result = await _repository.getEvolutionaryReport(
      examsCodes: listExamCode.join(','),
    );

    if (result.isSuccess) {
      for (int i = 0; i <= result.value!.examsConsultation.length - 1; i++) {
        MapEntry entry = mapExams.entries.firstWhere(
          (element) =>
              element.value.contains(result.value!.examsConsultation[i].code),
        );

        result.value!.examsConsultation[i].groupName = entry.key;
      }
    }

    return result;
  }
}
