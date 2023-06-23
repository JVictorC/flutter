// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:equatable/equatable.dart';

import '../../../../core/exceptions/exceptions.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/exam_image_result_entity.dart';
import '../repositories/exam_repository_interface.dart';

class GetImageExamResultUseCase
    implements UseCase<ExamImageResultEntity, ExamImageParam> {
  final IExamRepository _repository;

  GetImageExamResultUseCase(this._repository);
  @override
  Future<Result<Failure, ExamImageResultEntity>> call(
    ExamImageParam params,
  ) async =>
      await _repository.getImageExamResult(params);
}

class ExamImageParam extends Equatable {
  final String? patientId;
  final String? issuer;
  final String? studyInstanceUID;
  final String? accessionNumber;

  const ExamImageParam({
    this.patientId,
    this.issuer,
    this.studyInstanceUID,
    this.accessionNumber,
  });

  @override
  List<Object?> get props => [
        patientId,
        issuer,
        studyInstanceUID,
        accessionNumber,
      ];
}
