// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:equatable/equatable.dart';

class UploadFileResponseEntity extends Equatable {
  final String? id;
  final String? bucket;
  final String? path;
  final int size;
  final DateTime lastModified;
  final String? urlFile;

  const UploadFileResponseEntity({
    this.id,
    this.bucket,
    this.path,
    required this.size,
    required this.lastModified,
    this.urlFile,
  });

  @override
  List<Object?> get props => [
        id,
        bucket,
        path,
        size,
        lastModified,
        urlFile,
      ];
}
