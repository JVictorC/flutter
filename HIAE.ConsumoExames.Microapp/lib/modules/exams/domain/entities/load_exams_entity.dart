// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

import 'exams_filters_entity.dart';
import 'exams_filters_external_entity.dart';

class LoadExamEntity extends Equatable {
  final DateTime initialDate;
  final DateTime finalDate;
  final bool results;
  final bool? auxPrint;
  final String? numberOfRecords;
  final String? passageId;
  final String? exams;
  final String? idItens;
  final String? chAuthentication;
  final String? lab;
  final ExamFiltersEntity filters;
  final FiltersExternalEntity externalFilters;
  String? medicalAppointment;
  LoadExamEntity({
    required this.initialDate,
    required this.finalDate,
    required this.filters,
    required this.results,
    required this.lab,
    required this.chAuthentication,
    required this.medicalAppointment,
    required this.auxPrint,
    required this.numberOfRecords,
    required this.passageId,
    required this.exams,
    required this.idItens,
    required this.externalFilters,
  });

  @override
  List<Object?> get props => [
        chAuthentication,
        medicalAppointment,
        results,
        initialDate,
        finalDate,
        auxPrint,
        numberOfRecords,
        passageId,
        exams,
        idItens,
        lab,
        filters,
        externalFilters,
      ];
}
