import '../../../../core/exceptions/exceptions.dart';
import '../../../../core/utils/result.dart';
import '../entities/date_exam_entity.dart';
import '../entities/load_date_exam_entity.dart';
import '../repositories/exam_repository_interface.dart';

abstract class IGetExamsDateCase {
  Future<Result<Failure, DataExamResponseEntity>> call({
    required LoadDateExamEntity loadDataExamEntity,
  });
}

class GetExamsDateCase implements IGetExamsDateCase {
  final IExamRepository _repository;

  GetExamsDateCase({required IExamRepository repository})
      : _repository = repository;

  @override
  Future<Result<Failure, DataExamResponseEntity>> call({
    required LoadDateExamEntity loadDataExamEntity,
  }) async =>
      await _repository.getExamsDate(loadDataExamEntity: loadDataExamEntity);
}
