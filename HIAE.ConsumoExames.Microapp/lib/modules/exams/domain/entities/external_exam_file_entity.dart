import 'package:equatable/equatable.dart';

class ExternalExamFileEntity extends Equatable {
  final String path;
  final String file;

  const ExternalExamFileEntity({
    required this.path,
    required this.file,
  });

  @override
  List<Object?> get props => [path, file];
}
