import '../../../../core/exceptions/exceptions.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/radiation_history_entity.dart';
import '../entities/radiation_history_param_entity.dart';
import '../repositories/exam_repository_interface.dart';

class GetRadiationHistoryUseCase
    implements
        UseCase<List<RadiationHistoryEntity>, RadiationHistoryParamEntity> {
  final IExamRepository _repository;

  GetRadiationHistoryUseCase({required IExamRepository repository})
      : _repository = repository;

  @override
  Future<Result<Failure, List<RadiationHistoryEntity>>> call(
    RadiationHistoryParamEntity params,
  ) async {
    final result = await _repository.getRadiationHistory(
      radiationHistoryParamEntity: params,
    );
    return result;
  }
}
