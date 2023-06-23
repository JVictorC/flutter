// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'exams_filters_entity.dart';
import 'exams_filters_external_entity.dart';
import 'load_date_exam_entity.dart';

class ExamsDoctorEntity {
  final DateTime dateInitial;
  final DateTime dateFinal;
  bool? localLab;
  bool? otherLab;
  bool enableCardFilters;
  String? examCode;
  String? searchExams;
  LoadDateExamEntity examsDate;
  ExamFiltersEntity? internalFilter;
  FiltersExternalEntity? externalFilter;
  DateTime? dateCardInitial;
  DateTime? dateCardFinal;

  ExamsDoctorEntity({
    required this.dateInitial,
    required this.dateFinal,
    required this.examsDate,
    required this.enableCardFilters,
    this.examCode,
    this.searchExams,
    this.internalFilter,
    this.externalFilter,
    this.dateCardInitial,
    this.dateCardFinal,
    this.localLab,
    this.otherLab,
  });

  ExamsDoctorEntity copyWith({
    DateTime? dateInitial,
    DateTime? dateFinal,
    String? examCode,
    String? searchExams,
    LoadDateExamEntity? examsDate,
    ExamFiltersEntity? internalFilter,
    FiltersExternalEntity? externalFilter,
    DateTime? dateCardInitial,
    DateTime? dateCardFinal,
    bool? localLab,
    bool? otherLab,
  }) =>
      ExamsDoctorEntity(
        localLab: localLab ?? this.localLab,
        otherLab: otherLab ?? this.otherLab,
        enableCardFilters: enableCardFilters,
        dateInitial: dateInitial ?? this.dateInitial,
        dateFinal: dateFinal ?? this.dateFinal,
        examCode: examCode ?? this.examCode,
        searchExams: searchExams ?? this.searchExams,
        examsDate: examsDate ?? this.examsDate,
        internalFilter: internalFilter ?? this.internalFilter,
        externalFilter: externalFilter ?? this.externalFilter,
        dateCardInitial: dateCardInitial ?? this.dateCardInitial,
        dateCardFinal: dateCardFinal ?? this.dateCardFinal,
      );
}
