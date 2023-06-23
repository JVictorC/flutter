import '../entities/patient_target_entity.dart';
import '../repositories/exam_repository_interface.dart';

abstract class IGetPatientTargetUseCase {
  PatientTargetEntity call();
}

class PatientTargetUseCase implements IGetPatientTargetUseCase {
  final IExamRepository _repository;

  PatientTargetUseCase({
    required IExamRepository repository,
  }) : _repository = repository;

  @override
  PatientTargetEntity call() => _repository.getPatientTarget();
}
