import '../../../../core/exceptions/exceptions.dart';
import '../../../../core/utils/result.dart';
import '../entities/load_exams_entity.dart';
import '../entities/medical_appointment_list_result_exams_entity.dart';
import '../repositories/exam_repository_interface.dart';

abstract class IGetExamsDetailsUseCase {
  Future<Result<Failure, MedicalAppointmentListResultExamsEntity>> call({
    required LoadExamEntity loadExamEntity,
  });
}

class GetExamsDetailsUseCase implements IGetExamsDetailsUseCase {
  final IExamRepository _repository;

  GetExamsDetailsUseCase({required IExamRepository repository})
      : _repository = repository;

  @override
  Future<Result<Failure, MedicalAppointmentListResultExamsEntity>> call({
    required LoadExamEntity loadExamEntity,
  }) async {
    if (loadExamEntity.exams != null &&
        loadExamEntity.filters.examName != null) {
      loadExamEntity.filters.examName = null;
    }

    return await _repository.getExamsDetails(loadExamEntity: loadExamEntity);
  }
}
