import '../../../../core/exceptions/exceptions.dart';
import '../../../../core/utils/result.dart';
import '../repositories/exam_repository_interface.dart';

abstract class IRemoveExternalExamsUseCase {
  Future<Result<Failure, bool>> call({
    required String id,
  });
}

class RemoveExternalExamsUseCase implements IRemoveExternalExamsUseCase {
  final IExamRepository _repository;

  RemoveExternalExamsUseCase({
    required IExamRepository repository,
  }) : _repository = repository;

  @override
  Future<Result<Failure, bool>> call({required String id}) async =>
      await _repository.removeExternalExam(id: id);
}
