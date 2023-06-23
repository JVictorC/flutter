import '../../../../core/exceptions/exceptions.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/external_exam_file_entity.dart';
import '../entities/external_exam_file_req_entity.dart';
import '../repositories/exam_repository_interface.dart';

class GetExternalFileUseCase
    implements UseCase<ExternalExamFileEntity, ExternalExamFileReqEntity> {
  final IExamRepository _repository;

  GetExternalFileUseCase({required IExamRepository repository})
      : _repository = repository;
  @override
  Future<Result<Failure, ExternalExamFileEntity>> call(
    ExternalExamFileReqEntity params,
  ) async {
    final result =
        await _repository.getExternalFile(externalExamFileReqEntity: params);
    return result;
  }
}
