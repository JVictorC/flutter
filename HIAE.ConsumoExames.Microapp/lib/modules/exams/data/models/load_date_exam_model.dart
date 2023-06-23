import 'dart:convert';

import '../../../../core/extensions/date_time_extension.dart';
import '../../domain/entities/load_date_exam_entity.dart';

//ignore: must_be_immutable
class LoadDateExamModel extends LoadDateExamEntity {
  LoadDateExamModel({
    required DateTime initialDate,
    required DateTime finalDate,
    required int numberOfRecords,
    String? chAuthentication,
    String? medicalAppointment,
    String? exams,
    String? passageType,
  }) : super(
          initialDate: initialDate,
          finalDate: finalDate,
          numberOfRecords: numberOfRecords,
          chAuthentication: chAuthentication,
          medicalAppointment: medicalAppointment,
          exams: exams,
          passageType: passageType,
        );

  factory LoadDateExamModel.fromMap(Map<String, dynamic> map) =>
      LoadDateExamModel(
        initialDate: DateTime.parse(map['initialDate']),
        finalDate: DateTime.parse(map['finalDate']),
        numberOfRecords: map['numberOfRecords']?.toInt() ?? 10,
        medicalAppointment: map['medicalAppointment'],
        exams: map['exams'],
        passageType: map['passageType'],
        chAuthentication: map['chAuthentication'],
      );

  factory LoadDateExamModel.fromJson(String source) =>
      LoadDateExamModel.fromMap(json.decode(source));

  Map<String, dynamic> toMap() => {
        'initialDate': initialDate.toJson(),
        'finalDate': finalDate.toJson(),
        'numberOfRecords': numberOfRecords,
        'chAuthentication': chAuthentication,
        'medicalAppointment': medicalAppointment,
        'exams': exams,
        'passageType': passageType,
      };

  factory LoadDateExamModel.fromEntity(LoadDateExamEntity entity) =>
      LoadDateExamModel(
        initialDate: entity.initialDate,
        finalDate: entity.finalDate,
        numberOfRecords: entity.numberOfRecords,
        chAuthentication: entity.chAuthentication,
        exams: entity.exams,
        medicalAppointment: entity.medicalAppointment,
        passageType: entity.passageType,
      );
}
