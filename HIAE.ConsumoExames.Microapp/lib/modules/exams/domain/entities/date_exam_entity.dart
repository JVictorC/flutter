// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

class DateExamEntity extends Equatable {
  final String passageId;
  final DateTime dtExecution;
  final int position;
  final String passagePlace;
  final String passageType;
  bool? grouped;
  bool? externalExam;

  DateExamEntity({
    required this.passageId,
    required this.dtExecution,
    required this.position,
    required this.passagePlace,
    required this.passageType,
    this.grouped,
    this.externalExam,
  });

  @override
  List<Object?> get props => [
        passageId,
        dtExecution,
        position,
        passagePlace,
        passageType,
        grouped,
        externalExam,
      ];
}

class DataExamResponseEntity extends Equatable {
  final int status;
  final int occurrences;
  final List<DateExamEntity> listDateExamEntity;
  final List<DateTime> externalDate;
  final String? message;

  const DataExamResponseEntity({
    required this.status,
    required this.occurrences,
    required this.listDateExamEntity,
    required this.externalDate,
    this.message,
  });

  @override
  List<Object> get props => [
        status,
        occurrences,
        listDateExamEntity,
        externalDate,
      ];
}
