import 'package:equatable/equatable.dart';

class ExternalExamFileReqEntity extends Equatable {
  final String path;
  final String file;

  const ExternalExamFileReqEntity({
    required this.path,
    required this.file,
  });

  @override
  List<Object?> get props => [path, file];
}
