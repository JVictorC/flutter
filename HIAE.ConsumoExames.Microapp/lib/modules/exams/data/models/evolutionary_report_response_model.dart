import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import '../../domain/entities/evolutionary_report_response_entity.dart';

class EvolutionaryReportExamsModel extends EvolutionaryReportExamsEntity {
  EvolutionaryReportExamsModel({
    required final int status,
    required final String description,
    required final List<ExamsConsultationEntity> examsConsultation,
  }) : super(
          status: status,
          description: description,
          examsConsultation: examsConsultation,
        );

  factory EvolutionaryReportExamsModel.fromMap(Map<String, dynamic> map) =>
      EvolutionaryReportExamsModel(
        status: map['status'],
        description: map['descr'],
        examsConsultation: List<ExamsConsultationEntity>.from(
          map['examsConsultation'].map(
            (data) => ExamsConsultationModel.fromMap(data),
          ),
        ),
      );
}

class ExamsConsultationModel extends ExamsConsultationEntity {
  ExamsConsultationModel({
    required final String code,
    required final String codeLabTrak,
    required final String description,
    required final List<ItensConsultationEntity> itensConsultation,
  }) : super(
          code: code,
          codeLabTrak: codeLabTrak,
          description: description,
          itensConsultation: itensConsultation,
        );

  factory ExamsConsultationModel.fromMap(Map<String, dynamic> map) =>
      ExamsConsultationModel(
        code: map['code'],
        codeLabTrak: map['codeLabTrak'] ?? '',
        description: map['description'],
        itensConsultation: List<ItensConsultationEntity>.from(
          map['itensConsultation'].map(
            (data) => ItensConsultationModel.fromMap(data),
          ),
        ),
      );
}

class ItensConsultationModel extends ItensConsultationEntity {
  ItensConsultationModel({
    required final String code,
    required final String description,
    required final List<ResultsConsultationEntity> resultsConsultation,
  }) : super(
          code: code,
          description: description,
          resultsConsultation: resultsConsultation,
        );

  factory ItensConsultationModel.fromMap(Map<String, dynamic> map) =>
      ItensConsultationModel(
        code: map['code'] ?? '',
        description: map['description'] ?? '',
        resultsConsultation: List<ResultsConsultationEntity>.from(
          map['resultsConsultation'].map(
            (data) => ResultsConsultationModel.fromMap(data),
          ),
        ),
      );
}

class ResultsConsultationModel extends ResultsConsultationEntity {
  ResultsConsultationModel({
    required final String? defaultRefValue,
    required final String? valueResult,
    required final String? unityResult,
    required final DateTime? dateResult,
    required final TimeOfDay? hourResult,
    required final String? idItemResult,
    required final String? labTestSetRowResult,
    required final String? typeResult,
    required final String? idPassageResult,
    required final DateTime? sttDateResult,
    required final bool anormalResult,
    required final num? valueRefMin,
    required final num? valueRefMax,
  }) : super(
          defaultRefValue: defaultRefValue,
          valueResult: valueResult,
          unityResult: unityResult,
          dateResult: dateResult,
          hourResult: hourResult,
          idItemResult: idItemResult,
          labTestSetRowResult: labTestSetRowResult,
          typeResult: typeResult,
          idPassageResult: idPassageResult,
          sttDateResult: sttDateResult,
          anormalResult: anormalResult,
          valueRefMin: valueRefMin,
          valueRefMax: valueRefMax,
        );

  factory ResultsConsultationModel.fromMap(Map<String, dynamic> map) =>
      ResultsConsultationModel(
        defaultRefValue: map['defaultRefValue'],
        valueResult: map['valueResult'],
        unityResult: map['unityResult'],
        anormalResult: map['anormalResult'] ?? false,
        dateResult: map['dateResult'] != null
            ? DateTime.parse(map['dateResult'])
            : null,
        hourResult: TimeOfDay.fromDateTime(
          DateFormat('HH:mm').parse(map['hourResult']),
        ),
        idItemResult: map['idItenResult'],
        labTestSetRowResult: map['labTestSetRowResult'],
        typeResult: map['typeResult'],
        idPassageResult: map['idPassageResult'],
        valueRefMin: map['valueRefMin'],
        valueRefMax: map['valueRefMax'],
        sttDateResult: map['sttDateResult'] != null
            ? DateTime.parse(map['sttDateResult'])
            : null,
      );
}
