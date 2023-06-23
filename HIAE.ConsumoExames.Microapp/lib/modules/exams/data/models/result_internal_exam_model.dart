import '../../domain/entities/exam_entity.dart';
import '../../domain/entities/passage_entity.dart';
import '../../domain/entities/result_internal_exam_entity.dart';
import 'exam_model.dart';
import 'passage_model.dart';

class ResultInternalExamModel extends ResultInternalExamEntity {
  const ResultInternalExamModel({
    required int status,
    required int occurrences,
    required PassageEntity passage,
    required List<ExamEntity> listExam,
  }) : super(
          status: status,
          occurrences: occurrences,
          passage: passage,
          listExam: listExam,
        );

  factory ResultInternalExamModel.fromMap(Map<String, dynamic> map) =>
      ResultInternalExamModel(
        status: map['status'],
        occurrences: map['ocorrencies'],
        passage: PassageModel.fromMap(map['passage']),
        listExam: map['exams'] != null
            ? List<ExamEntity>.from(
                map['exams'].map(
                  (data) => ExamModel.fromMap(data),
                ),
              )
            : [],
      );
}
