import 'package:equatable/equatable.dart';

class ResultExternalExamEntity extends Equatable {
  final int examType;
  final DateTime executionDate;
  final DateTime uploadDate;
  final String fileId;
  final String? id;
  final String? examName;
  final String? medicalRecords;
  final String? labName;
  final String? url;
  final String? path;

  const ResultExternalExamEntity({
    required this.id,
    required this.examName,
    required this.medicalRecords,
    required this.labName,
    required this.examType,
    required this.executionDate,
    required this.url,
    required this.uploadDate,
    required this.fileId,
    required this.path,
  });

  @override
  List<Object?> get props => [
        id,
        examName,
        medicalRecords,
        labName,
        examType,
        executionDate,
        url,
        uploadDate,
        fileId,
        path,
      ];
}
