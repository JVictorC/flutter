// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:equatable/equatable.dart';

class UploadFileEntity extends Equatable {
  final String? fileName;
  final String? file;
  // final Base64Codec? file;

  const UploadFileEntity({
    this.fileName,
    this.file,
  });

  @override
  List<Object?> get props => [fileName, file];
}
