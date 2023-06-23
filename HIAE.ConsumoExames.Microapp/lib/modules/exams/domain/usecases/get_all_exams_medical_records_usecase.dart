import '../../../../core/exceptions/exceptions.dart';
import '../../../../core/utils/result.dart';
import '../entities/exams_medical_records_entity.dart';
import '../repositories/exam_repository_interface.dart';

abstract class IGetAllExamsMedicalRecordsUseCase {
  Future<Result<Failure, List<ExamsMedicalRecordsEntity>>> call({
    required DateTime? dateInitial,
    required DateTime? dateFinal,
  });
}

class GetAllExamsMedicalRecordsUseCase
    implements IGetAllExamsMedicalRecordsUseCase {
  final IExamRepository _repository;

  GetAllExamsMedicalRecordsUseCase({required IExamRepository repository})
      : _repository = repository;

  @override
  Future<Result<Failure, List<ExamsMedicalRecordsEntity>>> call({
    required DateTime? dateInitial,
    required DateTime? dateFinal,
  }) async {
    dateFinal ??= DateTime.now();
    dateInitial ??= DateTime(dateFinal.year - 5);

    final result = await _repository.getAllExamsMedicalRecords(
      dateInitial: dateInitial,
      dateFinal: dateFinal,
    );

    if (result.isSuccess) {
      result.value!.sort(
        (a, b) => a.examName.compareTo(b.examName),
      );
    }

    return result;
  }
}
