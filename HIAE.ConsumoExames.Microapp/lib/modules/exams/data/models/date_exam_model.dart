// ignore_for_file: must_be_immutable

import '../../domain/entities/date_exam_entity.dart';

class DataExamModel extends DateExamEntity {
  DataExamModel({
    required String passageId,
    required DateTime dtExecution,
    required int position,
    required String passagePlace,
    required String passageType,
  }) : super(
          passageId: passageId,
          dtExecution: dtExecution,
          position: position,
          passagePlace: passagePlace,
          passageType: passageType,
        );

  factory DataExamModel.fromMap(Map<String, dynamic> map) => DataExamModel(
        dtExecution: DateTime.parse(map['dtExecution']),
        passageId: map['passageId'],
        passagePlace: map['passagePlace'],
        passageType: map['passageType'],
        position: map['position'],
      );
}

class DataExamResponseModel extends DataExamResponseEntity {
  const DataExamResponseModel({
    required int status,
    required int occurrences,
    required List<DateExamEntity> listDateExamEntity,
    required List<DateTime> externalDate,
    String? message,
  }) : super(
          status: status,
          occurrences: occurrences,
          listDateExamEntity: listDateExamEntity,
          externalDate: externalDate,
          message: message,
        );

  factory DataExamResponseModel.fromMap(Map<String, dynamic> map) =>
      DataExamResponseModel(
        status: map['status'],
        occurrences: map['occurrences'],
        message: map['messages'],
        listDateExamEntity: map['dates'] != null
            ? List<DateExamEntity>.from(
                map['dates'].map(
                  (data) => DataExamModel.fromMap(data),
                ),
              )
            : [],
        externalDate: map['datesExternal'] != null
            ? List<DateTime>.from(
                map['datesExternal'].map(
                  (data) => DateTime.parse(data['dtExecution']),
                ),
              )
            : [],
      );
}
