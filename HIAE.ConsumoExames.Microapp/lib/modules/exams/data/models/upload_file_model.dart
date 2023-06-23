import '../../domain/entities/upload_file_entity.dart';

class UploadFileModel extends UploadFileEntity {
  const UploadFileModel({
    required String? fileName,
    // required Base64Codec? file,
    required String? file,
  }) : super(
          fileName: fileName,
          file: file,
        );

  factory UploadFileModel.fromMap(Map<String, dynamic> map) => UploadFileModel(
        fileName: map['filename'],
        file: map['file'],
      );
  Map<String, dynamic> toMap() => {
        'filename': fileName,
        'file': file,
      };

  factory UploadFileModel.fromEntity(UploadFileEntity entity) =>
      UploadFileModel(
        fileName: entity.fileName,
        file: entity.file,
      );
}
