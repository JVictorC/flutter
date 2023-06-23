import '../../domain/entities/medical_appointment_list_result_exams_entity.dart';
import '../../domain/entities/result_external_exam_entity.dart';
import '../../domain/entities/result_internal_exam_entity.dart';
import 'result_external_exam_model.dart';
import 'result_internal_exam_model.dart';

class MedicalAppointmentListResultExamsModel
    extends MedicalAppointmentListResultExamsEntity {
  const MedicalAppointmentListResultExamsModel({
    required int status,
    required int occurrences,
    required List<ResultInternalExamEntity> resultInternalExam,
    required List<ResultExternalExamEntity> resultExternalExam,
  }) : super(
          status: status,
          occurrences: occurrences,
          resultInternalExam: resultInternalExam,
          resultExternalExam: resultExternalExam,
        );

  factory MedicalAppointmentListResultExamsModel.fromMap(
    Map<String, dynamic> map,
  ) =>
      MedicalAppointmentListResultExamsModel(
        status: map['status'],
        occurrences: map['occurrences'],
        resultInternalExam: List<ResultInternalExamEntity>.from(
          map['passages']['medicalAppointmentListResultExams'].map(
            (data) => ResultInternalExamModel.fromMap(data),
          ),
        ),
        resultExternalExam: map['passagesExternal']['externalExam'] != null
            ? List<ResultExternalExamEntity>.from(
                map['passagesExternal']['externalExam'].map(
                  (data) => ResultExternalExamModel.fromMap(data),
                ),
              )
            : [],
      );
}
