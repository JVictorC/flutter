import '../../../../core/extensions/date_time_extension.dart';
import '../../domain/entities/external_exam_entity.dart';

class ExternalExamModel extends ExternalExamEntity {
  const ExternalExamModel({
    String? id,
    String? fileId,
    String? examName,
    String? medicalRecords,
    String? path,
    String? labName,
    required int examType,
    required DateTime executionDate,
    String? url,
    required DateTime uploadDate,
  }) : super(
          id: id,
          fileId: fileId,
          examName: examName,
          medicalRecords: medicalRecords,
          path: path,
          labName: labName,
          examType: examType,
          executionDate: executionDate,
          url: url,
          uploadDate: uploadDate,
        );

  factory ExternalExamModel.fromMap(Map<String, dynamic> map) =>
      ExternalExamModel(
        examType: map['examType'],
        executionDate: DateTime.parse(map['executionDate']),
        uploadDate: DateTime.parse(map['uploadDate']),
        examName: map['examName'],
        fileId: map['fileId'],
        id: map['id'],
        labName: map['labName'],
        medicalRecords: map['medicalRecords'],
        path: map['path'],
        url: map['url'],
      );

  factory ExternalExamModel.fromEntity(ExternalExamEntity entity) =>
      ExternalExamModel(
        id: entity.id,
        fileId: entity.fileId,
        examName: entity.examName,
        medicalRecords: entity.medicalRecords,
        path: entity.path,
        labName: entity.labName,
        examType: entity.examType,
        executionDate: entity.executionDate,
        url: entity.url,
        uploadDate: entity.uploadDate,
      );
  Map<String, dynamic> toMap() => {
        'id': id,
        'fileId': fileId,
        'examName': examName,
        'medicalRecords': medicalRecords,
        'path': path,
        'labName': labName,
        'examType': examType,
        'executionDate': executionDate.toJson(),
        'url': url,
        'uploadDate': uploadDate.toJson(),
      };
}
