import '../../../../core/exceptions/exceptions.dart';
import '../../../../core/utils/result.dart';
import '../entities/evolutionary_report_response_entity.dart';
import '../repositories/exam_repository_interface.dart';

abstract class IGetEvolutiveReportUseCase {
  Future<Result<Failure, EvolutionaryReportExamsEntity>> call({
    required List<String> examsCodes,
  });
}

class GetEvolutiveReportUseCase implements IGetEvolutiveReportUseCase {
  final IExamRepository _repository;

  GetEvolutiveReportUseCase({
    required IExamRepository repository,
  }) : _repository = repository;

  @override
  Future<Result<Failure, EvolutionaryReportExamsEntity>> call({
    required List<String> examsCodes,
  }) async =>
      await _repository.getEvolutionaryReport(
        examsCodes: examsCodes.join(','),
      );
}
