import 'package:equatable/equatable.dart';

class ExamPdfResultEntity extends Equatable {
  final String pdfResult;

  const ExamPdfResultEntity({
    required this.pdfResult,
  });

  @override
  List<Object> get props => [pdfResult];
}
