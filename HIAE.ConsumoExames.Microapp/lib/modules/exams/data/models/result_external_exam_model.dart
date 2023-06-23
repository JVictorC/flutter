import '../../domain/entities/result_external_exam_entity.dart';

class ResultExternalExamModel extends ResultExternalExamEntity {
  const ResultExternalExamModel({
    required int examType,
    required DateTime executionDate,
    required DateTime uploadDate,
    required String fileId,
    required String? id,
    required String? examName,
    required String? medicalRecords,
    required String? labName,
    required String? url,
    required String? path,
  }) : super(
          examType: examType,
          executionDate: executionDate,
          uploadDate: uploadDate,
          fileId: fileId,
          id: id,
          examName: examName,
          medicalRecords: medicalRecords,
          labName: labName,
          url: url,
          path: path,
        );

  factory ResultExternalExamModel.fromMap(Map<String, dynamic> map) =>
      ResultExternalExamModel(
        examName: map['examName'],
        examType: map['examType'],
        executionDate: DateTime.parse(map['executionDate']),
        fileId: map['fileId'],
        id: map['id'],
        labName: map['labName'],
        medicalRecords: map['medicalRecords'],
        path: map['path'],
        uploadDate: DateTime.parse(map['uploadDate']),
        url: map['url'],
      );
}
