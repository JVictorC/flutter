import '../../data/models/exam_evolutive_result_model.dart';
import '../../data/models/exam_pdf_result_model.dart';
import '../../data/models/image_exam_result_model.dart';
import '../../domain/entities/date_exam_entity.dart';
import '../../domain/entities/download_exam_entity.dart';
import '../../domain/entities/evolutionary_report_request_entity.dart';
import '../../domain/entities/evolutionary_report_response_entity.dart';
import '../../domain/entities/exams_medical_records_entity.dart';
import '../../domain/entities/external_exam_entity.dart';
import '../../domain/entities/external_exam_file_entity.dart';
import '../../domain/entities/external_exam_file_req_entity.dart';
import '../../domain/entities/load_date_exam_entity.dart';
import '../../domain/entities/load_exams_entity.dart';
import '../../domain/entities/medical_appointment_list_result_exams_entity.dart';
import '../../domain/entities/radiation_history_entity.dart';
import '../../domain/entities/radiation_history_param_entity.dart';
import '../../domain/entities/upload_file_entity.dart';
import '../../domain/entities/upload_file_response_entity.dart';
import '../../domain/usecases/get_evolutive_result_usecase.dart';
import '../../domain/usecases/get_image_result_usecase.dart';
import '../../domain/usecases/get_pdf_result_usecase.dart';

abstract class IExamDataSource {
  Future<EvolutionaryReportExamsEntity> getEvolutionaryReport({
    required EvolutionaryReportRequestEntity evolutionaryReportLoad,
  });

  Future<bool> removeExternalExam({
    required String id,
  });

  Future<List<ExamsMedicalRecordsEntity>> getAllExamsMedicalRecords({
    required String medicalRecords,
    required DateTime dateInitial,
    required DateTime dateFinal,
  });

  Future<DataExamResponseEntity> getExamsDate({
    required LoadDateExamEntity loadDataExamEntity,
  });

  Future<MedicalAppointmentListResultExamsEntity> getExamsDetails({
    required LoadExamEntity loadExamEntity,
  });

  Future<String> downloadExamsPdf({
    required DownloadExamEntity downloadExamEntity,
  });

  Future<ExamPdfResultModel> getPdfResult(PdfResultParam param);
  Future<ExamImageResultModel> getImageExamResult(ExamImageParam param);
  Future<ExamEvolutiveResultModel> getEvolutiveResult(EvolutiveParam param);
  Future<ExternalExamEntity> saveExternalExam({
    required ExternalExamEntity externalExamEntity,
  });
  Future<UploadFileResponseEntity> uploadExternalFile({
    required UploadFileEntity uploadFileEntity,
    required Function(int, int) onSendProgress,
  });
  Future<ExternalExamFileEntity> getExternalFile({
    required ExternalExamFileReqEntity externalExamFileReqEntity,
  });
  Future<List<RadiationHistoryEntity>> getRadiationHistory({
    required RadiationHistoryParamEntity radiationHistoryParamEntity,
  });
}
