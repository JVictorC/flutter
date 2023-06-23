// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:equatable/equatable.dart';

class ExternalExamEntity extends Equatable {
  final String? id;
  final String? fileId;
  final String? examName;
  final String? medicalRecords;
  final String? path;
  final String? labName;
  final int examType;
  final DateTime executionDate;
  final String? url;
  final DateTime uploadDate;

  const ExternalExamEntity({
    this.id,
    this.fileId,
    this.examName,
    this.medicalRecords,
    this.path,
    this.labName,
    required this.examType,
    required this.executionDate,
    this.url,
    required this.uploadDate,
  });

  @override
  List<Object?> get props => [
        id,
        fileId,
        examName,
        medicalRecords,
        path,
        labName,
        examType,
        executionDate,
        url,
        uploadDate,
      ];

  ExternalExamEntity copyWith({
    String? id,
    String? fileId,
    String? examName,
    String? medicalRecords,
    String? path,
    String? labName,
    int? examType,
    DateTime? executionDate,
    String? url,
    DateTime? uploadDate,
  }) =>
      ExternalExamEntity(
        id: id ?? this.id,
        fileId: fileId ?? this.fileId,
        examName: examName ?? this.examName,
        medicalRecords: medicalRecords ?? this.medicalRecords,
        path: path ?? this.path,
        labName: labName ?? this.labName,
        examType: examType ?? this.examType,
        executionDate: executionDate ?? this.executionDate,
        url: url ?? this.url,
        uploadDate: uploadDate ?? this.uploadDate,
      );
}
