import '../../../../core/exceptions/exceptions.dart';
import '../../../../core/utils/result.dart';
import '../repositories/exam_repository_interface.dart';

abstract class IGetFirstEvolutionaryRepositoryUseCase {
  Result<Failure, bool> call();
}

class GetFirstEvolutionaryRepositoryUseCase
    implements IGetFirstEvolutionaryRepositoryUseCase {
  final IExamRepository _repository;
  GetFirstEvolutionaryRepositoryUseCase({required IExamRepository repository})
      : _repository = repository;

  @override
  Result<Failure, bool> call() => _repository.getFirstEvolutionaryReport();
}
