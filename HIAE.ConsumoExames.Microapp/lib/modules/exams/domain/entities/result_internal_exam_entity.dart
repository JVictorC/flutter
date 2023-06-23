import 'package:equatable/equatable.dart';

import 'exam_entity.dart';
import 'passage_entity.dart';

class ResultInternalExamEntity extends Equatable {
  final int status;
  final int occurrences;
  final PassageEntity passage;
  final List<ExamEntity> listExam;

  const ResultInternalExamEntity({
    required this.status,
    required this.occurrences,
    required this.passage,
    required this.listExam,
  });

  @override
  List<Object?> get props => [
        status,
        occurrences,
        passage,
        listExam,
      ];

  ResultInternalExamEntity copyWith({
    int? status,
    int? occurrences,
    PassageEntity? passage,
    List<ExamEntity>? listExam,
  }) =>
      ResultInternalExamEntity(
        status: status ?? this.status,
        occurrences: occurrences ?? this.occurrences,
        passage: passage ?? this.passage,
        listExam: listExam ?? this.listExam,
      );
}
