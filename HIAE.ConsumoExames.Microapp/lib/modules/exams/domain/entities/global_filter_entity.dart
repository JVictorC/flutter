// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:equatable/equatable.dart';

import 'exams_filters_entity.dart';
import 'exams_filters_external_entity.dart';

class GlobalFilterEntity extends Equatable {
  final bool localLab;
  final bool otherLab;
  final ExamFiltersEntity? examFiltersEntity;
  final FiltersExternalEntity? filtersExternalEntity;

  const GlobalFilterEntity({
    required this.localLab,
    required this.otherLab,
    required this.examFiltersEntity,
    required this.filtersExternalEntity,
  });

  @override
  List<Object?> get props =>
      [examFiltersEntity, filtersExternalEntity, localLab, otherLab];
}
