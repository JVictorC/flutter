import '../repositories/exam_repository_interface.dart';

abstract class ISetFirstOpenEvolutionaryReportUseCase {
  void call();
}

class SetFirstOpenEvolutionaryReportUseCase
    implements ISetFirstOpenEvolutionaryReportUseCase {
  final IExamRepository _repository;

  SetFirstOpenEvolutionaryReportUseCase({required IExamRepository repository})
      : _repository = repository;

  @override
  void call() {
    _repository.setFirstEvolutionaryReport();
  }
}
