import 'package:flutter/material.dart';

class EvolutionaryReportExamsEntity {
  final int status;
  final String description;
  final List<ExamsConsultationEntity> examsConsultation;

  EvolutionaryReportExamsEntity({
    required this.status,
    required this.description,
    required this.examsConsultation,
  });
}

mixin GroupNameValue {
  String? groupName;
}

class ExamsConsultationEntity with GroupNameValue {
  final String code;
  final String codeLabTrak;
  final String description;
  final List<ItensConsultationEntity> itensConsultation;

  ExamsConsultationEntity({
    required this.code,
    required this.codeLabTrak,
    required this.description,
    required this.itensConsultation,
  });
}

class ItensConsultationEntity {
  final String code;
  final String description;
  final List<ResultsConsultationEntity> resultsConsultation;

  ItensConsultationEntity({
    required this.code,
    required this.description,
    required this.resultsConsultation,
  });
}

class ResultsConsultationEntity {
  final String? valueResult;
  final String? unityResult;
  final String? defaultRefValue;
  final DateTime? dateResult;
  final TimeOfDay? hourResult;
  final String? idItemResult;
  final num? valueRefMin;
  final num? valueRefMax;
  final String? labTestSetRowResult;
  final String? typeResult;
  final String? idPassageResult;
  final DateTime? sttDateResult;
  final bool anormalResult;
  ResultsConsultationEntity({
    required this.defaultRefValue,
    required this.valueResult,
    required this.unityResult,
    required this.anormalResult,
    required this.dateResult,
    required this.hourResult,
    required this.idItemResult,
    required this.labTestSetRowResult,
    required this.typeResult,
    required this.idPassageResult,
    required this.sttDateResult,
    required this.valueRefMax,
    required this.valueRefMin,
  });
}
