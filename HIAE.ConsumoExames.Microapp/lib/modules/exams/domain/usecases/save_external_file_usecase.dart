import '../../../../core/exceptions/exceptions.dart';
import '../../../../core/utils/local_storage_utils.dart';
import '../../../../core/utils/result.dart';
import '../entities/external_exam_entity.dart';
import '../repositories/exam_repository_interface.dart';

abstract class ISaveExternalFileUseCase {
  Future<Result<Failure, ExternalExamEntity>> call(
    ExternalExamEntity params,
  );
}

class SaveExternalFileUseCase implements ISaveExternalFileUseCase {
  final IExamRepository _repository;

  SaveExternalFileUseCase({required IExamRepository repository})
      : _repository = repository;
  @override
  Future<Result<Failure, ExternalExamEntity>> call(
    ExternalExamEntity params,
  ) async {
    final result =
        await _repository.saveExternalExam(externalExamEntity: params);

    if (result.isSuccess) {
      await saveExternalExamIdStorage(id: result.value!.id!);
    }
    return result;
  }
}
