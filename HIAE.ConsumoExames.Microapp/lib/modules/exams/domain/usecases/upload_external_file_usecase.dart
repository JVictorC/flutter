import '../../../../core/exceptions/exceptions.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/upload_file_entity.dart';
import '../entities/upload_file_response_entity.dart';
import '../repositories/exam_repository_interface.dart';

class UploadExternalFileUseCase
    implements UseCase<UploadFileResponseEntity, UploadFileEntity> {
  final IExamRepository _repository;

  UploadExternalFileUseCase({required IExamRepository repository})
      : _repository = repository;
  @override
  Future<Result<Failure, UploadFileResponseEntity>> call(
    UploadFileEntity params,
  ) async {
    final result =
        await _repository.uploadExternalFile(uploadFileEntity: params);
    return result;
  }
}
