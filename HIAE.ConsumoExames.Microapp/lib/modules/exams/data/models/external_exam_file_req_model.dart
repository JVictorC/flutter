import '../../domain/entities/external_exam_file_req_entity.dart';

class ExternalExamFileReqModel extends ExternalExamFileReqEntity {
  const ExternalExamFileReqModel({
    required String path,
    required String file,
  }) : super(
          path: path,
          file: file,
        );

  Map<String, dynamic> toMap() => {
        'path': path,
        'file': file,
      };

  factory ExternalExamFileReqModel.fromEntity(
    ExternalExamFileReqEntity entity,
  ) =>
      ExternalExamFileReqModel(
        path: entity.path,
        file: entity.file,
      );
}
