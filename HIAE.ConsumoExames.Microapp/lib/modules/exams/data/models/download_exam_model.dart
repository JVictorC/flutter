// ignore_for_file: must_be_immutable

import 'package:intl/intl.dart';

import '../../domain/entities/download_exam_entity.dart';

class DownloadExamModel extends DownloadExamEntity {
  DownloadExamModel({
    required DateTime executionDateBegin,
    required DateTime executionDateEnd,
    required List<String> itensIdList,
    required int userType,
    required bool examBreak,
    required String? medicalAppointment,
    required String? passage,
    required String? examCode,
  }) : super(
          medicalAppointment: medicalAppointment,
          passage: passage,
          itensIdList: itensIdList,
          examBreak: examBreak,
          executionDateBegin: executionDateBegin,
          executionDateEnd: executionDateEnd,
          examCode: examCode,
          userType: userType,
        );

  Map<String, dynamic> toMap() => {
        'medicalAppointment': medicalAppointment,
        'passage': passage,
        'itensIdList': itensIdList,
        'examBreak': examBreak,
        'executionDateBegin':
            DateFormat('yyyy-MM-dd').format(executionDateBegin),
        'executionDateEnd': DateFormat('yyyy-MM-dd').format(executionDateEnd),
        'examCode': examCode,
        'userType': userType,
      };

  factory DownloadExamModel.fromEntity({required DownloadExamEntity entity}) =>
      DownloadExamModel(
        examBreak: entity.examBreak,
        examCode: entity.examCode,
        executionDateBegin: entity.executionDateBegin,
        executionDateEnd: entity.executionDateEnd,
        itensIdList: entity.itensIdList,
        medicalAppointment: entity.medicalAppointment,
        passage: entity.passage,
        userType: entity.userType,
      );
}
