// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class ExamFiltersEntity extends Equatable {
  List<int>? examType;
  List<int>? passType;
  List<String>? unity;
  List<int>? statusResult;
  DateTime? executionInitialDate;
  DateTime? executionFinalDate;
  String? examName;
  String? examId;

  ExamFiltersEntity({
    this.examType,
    this.passType,
    this.executionInitialDate,
    this.executionFinalDate,
    this.unity,
    this.examName,
    this.examId,
    this.statusResult,
  });

  @override
  List<Object?> get props => [
        examType,
        passType,
        executionInitialDate,
        executionFinalDate,
        unity,
        examId,
        statusResult,
      ];

  ExamFiltersEntity copyWith({
    List<int>? examType,
    List<int>? passType,
    DateTime? executionInitialDate,
    DateTime? executionFinalDate,
    List<String>? unity,
    String? examId,
    List<int>? statusResult,
  }) =>
      ExamFiltersEntity(
        examType: examType ?? this.examType,
        passType: passType ?? this.passType,
        executionInitialDate: executionInitialDate ?? this.executionInitialDate,
        executionFinalDate: executionFinalDate ?? this.executionFinalDate,
        unity: unity ?? this.unity,
        examId: examId ?? this.examId,
        statusResult: statusResult ?? this.statusResult,
      );
}
