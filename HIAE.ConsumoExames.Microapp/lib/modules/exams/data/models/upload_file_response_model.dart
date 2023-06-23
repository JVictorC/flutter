import '../../domain/entities/upload_file_response_entity.dart';

class UploadFileResponseModel extends UploadFileResponseEntity {
  const UploadFileResponseModel({
    required String? id,
    required String? bucket,
    required String? path,
    required int size,
    required DateTime lastModified,
    required String? urlFile,
  }) : super(
          id: id,
          bucket: bucket,
          path: path,
          size: size,
          lastModified: lastModified,
          urlFile: urlFile,
        );

  factory UploadFileResponseModel.fromMap(Map<String, dynamic> map) =>
      UploadFileResponseModel(
        id: map['id'],
        bucket: map['bucket'],
        path: map['path'],
        size: map['size'],
        lastModified: DateTime.parse(map['lastModified']),
        urlFile: map['urlFile'],
      );
}
