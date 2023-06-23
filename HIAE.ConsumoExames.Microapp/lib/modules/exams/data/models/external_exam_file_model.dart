import '../../domain/entities/external_exam_file_entity.dart';

class ExternalExamFileModel extends ExternalExamFileEntity {
  const ExternalExamFileModel({
    required String path,
    required String file,
  }) : super(path: path, file: file);

  factory ExternalExamFileModel.fromMap(Map<String, dynamic> map) =>
      ExternalExamFileModel(
        path: map['path'],
        file: map['file'],
      );
}
