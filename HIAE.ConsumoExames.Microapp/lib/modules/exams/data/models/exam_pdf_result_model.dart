import 'package:intl/intl.dart';

import '../../domain/entities/exam_pdf_result_entity.dart';
import '../../domain/usecases/get_pdf_result_usecase.dart';

class ExamPdfResultModel extends ExamPdfResultEntity {
  const ExamPdfResultModel({
    required String pdfResult,
  }) : super(pdfResult: pdfResult);

  Map<String, dynamic> toMap() => <String, dynamic>{
        'pdfResult': pdfResult,
      };

  factory ExamPdfResultModel.fromMap(Map<String, dynamic> map) =>
      ExamPdfResultModel(
        pdfResult: map['pdfResult'] as String,
      );

  static Map<String, dynamic> toRequest(PdfResultParam param) =>
      <String, dynamic>{
        'medicalAppointment': param.medicalAppointment,
        'passage': param.passage,
        // 'executionDateBegin':DateTime.parse( param.executionDateBegin),
        // 'executionDateEnd': param.executionDateEnd,
        'executionDateBegin':
            DateFormat('yyyy-MM-dd').format(param.executionDateBegin!),
        'executionDateEnd':
            DateFormat('yyyy-MM-dd').format(param.executionDateEnd!),
        'examCode': param.examCode ?? '',
        'itensIdList': param.itensIdList,
        'userType': param.userType,
        'examBreak': param.examBreak,
      };
}
