import 'package:equatable/equatable.dart';

import '../mixins/exam_mixin.dart';

class ExamEntity extends Equatable with ExamMixin {
  final int examType;
  final DateTime executionDate;
  final DateTime executionDate2;
  final bool available;
  final bool security;
  final bool laudo;
  final int position;
  final int statusResult;

  final String? passType;
  final DateTime? uploadDate;
  final String? labName;
  final String? examId;
  final String? passageId;
  final String? examName;
  final String? examCode;
  final String? labCode;
  final String? doctorName;
  final String? doctorIdentity;
  final String? laudoFile;
  final String? place;
  final String? url1;
  final String? url2;
  final String? accessNumber;
  final String? result;
  final String? linesQuantity;
  final String? idMedicalRecords;
  final String? itemCategory;
  final String? fileId;
  final String? path;

  ExamEntity({
    required this.labName,
    required this.passType,
    required this.uploadDate,
    required this.laudo,
    required this.laudoFile,
    required this.url1,
    required this.url2,
    required this.examId,
    required this.passageId,
    required this.examName,
    required this.examCode,
    required this.labCode,
    required this.examType,
    required this.executionDate,
    required this.available,
    required this.security,
    required this.doctorName,
    required this.doctorIdentity,
    required this.place,
    required this.accessNumber,
    required this.result,
    required this.position,
    required this.statusResult,
    required this.linesQuantity,
    required this.idMedicalRecords,
    required this.itemCategory,
    required this.executionDate2,
    required this.fileId,
    required this.path,
  });

  @override
  List<Object?> get props => [
        laudo,
        passType,
        laudoFile,
        url1,
        url2,
        examId,
        passageId,
        examName,
        examCode,
        labCode,
        examType,
        executionDate,
        available,
        security,
        doctorName,
        doctorIdentity,
        place,
        accessNumber,
        result,
        position,
        statusResult,
        linesQuantity,
        idMedicalRecords,
        itemCategory,
        executionDate2,
      ];

  ExamEntity copyWith({
    int? examType,
    DateTime? executionDate,
    DateTime? executionDate2,
    bool? available,
    bool? security,
    bool? laudo,
    int? position,
    int? statusResult,
    String? passType,
    DateTime? uploadDate,
    String? labName,
    String? examId,
    String? passageId,
    String? examName,
    String? examCode,
    String? labCode,
    String? doctorName,
    String? doctorIdentity,
    String? laudoFile,
    String? place,
    String? url1,
    String? url2,
    String? accessNumber,
    String? result,
    String? linesQuantity,
    String? idMedicalRecords,
    String? itemCategory,
    String? fileId,
    String? path,
  }) =>
      ExamEntity(
        examType: examType ?? this.examType,
        executionDate: executionDate ?? this.executionDate,
        executionDate2: executionDate2 ?? this.executionDate2,
        available: available ?? this.available,
        security: security ?? this.security,
        laudo: laudo ?? this.laudo,
        position: position ?? this.position,
        statusResult: statusResult ?? this.statusResult,
        passType: passType ?? this.passType,
        uploadDate: uploadDate ?? this.uploadDate,
        labName: labName ?? this.labName,
        examId: examId ?? this.examId,
        passageId: passageId ?? this.passageId,
        examName: examName ?? this.examName,
        examCode: examCode ?? this.examCode,
        labCode: labCode ?? this.labCode,
        doctorName: doctorName ?? this.doctorName,
        doctorIdentity: doctorIdentity ?? this.doctorIdentity,
        laudoFile: laudoFile ?? this.laudoFile,
        place: place ?? this.place,
        url1: url1 ?? this.url1,
        url2: url2 ?? this.url2,
        accessNumber: accessNumber ?? this.accessNumber,
        result: result ?? this.result,
        linesQuantity: linesQuantity ?? this.linesQuantity,
        idMedicalRecords: idMedicalRecords ?? this.idMedicalRecords,
        itemCategory: itemCategory ?? this.itemCategory,
        fileId: fileId ?? this.fileId,
        path: path ?? this.path,
      );
}
