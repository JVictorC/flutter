import 'package:equatable/equatable.dart';

import 'result_external_exam_entity.dart';
import 'result_internal_exam_entity.dart';

class MedicalAppointmentListResultExamsEntity extends Equatable {
  final int status;
  final int occurrences;
  final List<ResultInternalExamEntity> resultInternalExam;
  final List<ResultExternalExamEntity> resultExternalExam;

  const MedicalAppointmentListResultExamsEntity({
    required this.status,
    required this.occurrences,
    required this.resultInternalExam,
    required this.resultExternalExam,
  });

  @override
  List<Object> get props => [
        status,
        occurrences,
        resultInternalExam,
        resultExternalExam,
      ];
}
