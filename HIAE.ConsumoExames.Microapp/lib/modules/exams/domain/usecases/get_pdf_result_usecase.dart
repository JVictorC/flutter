// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:equatable/equatable.dart';

import '../../../../core/exceptions/exceptions.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/exam_pdf_result_entity.dart';
import '../repositories/exam_repository_interface.dart';

class GetPdfResultUseCase
    implements UseCase<ExamPdfResultEntity, PdfResultParam> {
  final IExamRepository _repository;

  GetPdfResultUseCase(this._repository);
  @override
  Future<Result<Failure, ExamPdfResultEntity>> call(
    PdfResultParam params,
  ) async =>
      await _repository.getPdfResult(params);
}

/// Quando for laudo de imagem, vem com número de Acesso No Exame (NumAcesso)
/// IdPassagem
/// IdExame
class PdfResultParam extends Equatable {
  final String? medicalAppointment;
  final String? passage;
  final DateTime? executionDateBegin;
  final DateTime? executionDateEnd;
  final String? examCode;
  final List<String>? itensIdList;
  final int? userType;
  final bool? examBreak;

  const PdfResultParam({
    this.medicalAppointment,
    this.passage,
    this.executionDateBegin,
    this.executionDateEnd,
    this.examCode,
    this.itensIdList,
    this.userType,
    this.examBreak,
  });

  @override
  List<Object?> get props => [
        medicalAppointment,
        passage,
        executionDateBegin,
        executionDateEnd,
        examCode,
        itensIdList,
        userType,
        examBreak,
      ];
}
