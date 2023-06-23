import '../../../../core/exceptions/exceptions.dart';
import '../../../../core/utils/result.dart';
import '../entities/download_exam_entity.dart';
import '../repositories/exam_repository_interface.dart';

abstract class IDownloadsExamsPdfUseCase {
  Future<Result<Failure, String>> call({
    required DownloadExamEntity downloadExamEntity,
  });
}

class DownloadsExamsPdfUseCase implements IDownloadsExamsPdfUseCase {
  final IExamRepository _repository;

  DownloadsExamsPdfUseCase({required IExamRepository repository})
      : _repository = repository;

  @override
  Future<Result<Failure, String>> call({
    required DownloadExamEntity downloadExamEntity,
  }) async =>
      await _repository.downloadExamsPdf(
        downloadExamEntity: downloadExamEntity,
      );
}
