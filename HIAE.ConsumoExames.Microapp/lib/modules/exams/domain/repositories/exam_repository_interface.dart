import '../../../../core/exceptions/exceptions.dart';
import '../../../../core/utils/result.dart';
import '../entities/date_exam_entity.dart';
import '../entities/download_exam_entity.dart';
import '../entities/evolutionary_report_response_entity.dart';
import '../entities/exam_evolutive_result_entity.dart';
import '../entities/exam_image_result_entity.dart';
import '../entities/exam_pdf_result_entity.dart';
import '../entities/exams_medical_records_entity.dart';
import '../entities/external_exam_entity.dart';
import '../entities/external_exam_file_entity.dart';
import '../entities/external_exam_file_req_entity.dart';
import '../entities/load_date_exam_entity.dart';
import '../entities/load_exams_entity.dart';
import '../entities/medical_appointment_list_result_exams_entity.dart';
import '../entities/patient_target_entity.dart';
import '../entities/radiation_history_entity.dart';
import '../entities/radiation_history_param_entity.dart';
import '../entities/upload_file_entity.dart';
import '../entities/upload_file_response_entity.dart';
import '../usecases/get_evolutive_result_usecase.dart';
import '../usecases/get_image_result_usecase.dart';
import '../usecases/get_pdf_result_usecase.dart';

abstract class IExamRepository {
  Future<Result<Failure, EvolutionaryReportExamsEntity>> getEvolutionaryReport({
    required String examsCodes,
  });
  Result<Failure, bool> getFirstEvolutionaryReport();
  Failure? setFirstEvolutionaryReport();

  PatientTargetEntity getPatientTarget();

  Future<Result<Failure, List<ExamsMedicalRecordsEntity>>>
      getAllExamsMedicalRecords({
    required DateTime dateInitial,
    required DateTime dateFinal,
  });

  Future<Result<Failure, String>> downloadExamsPdf({
    required DownloadExamEntity downloadExamEntity,
  });

  Future<Result<Failure, DataExamResponseEntity>> getExamsDate({
    required LoadDateExamEntity loadDataExamEntity,
  });

  Future<Result<Failure, bool>> removeExternalExam({
    required String id,
  });

  Future<Result<Failure, MedicalAppointmentListResultExamsEntity>>
      getExamsDetails({
    required LoadExamEntity loadExamEntity,
  });

  Future<Result<Failure, ExamPdfResultEntity>> getPdfResult(
    PdfResultParam param,
  );
  Future<Result<Failure, ExamImageResultEntity>> getImageExamResult(
    ExamImageParam param,
  );
  Future<Result<Failure, ExamEvolutiveResultEntity>> getEvolutiveResult(
    EvolutiveParam param,
  );
  Future<Result<Failure, ExternalExamEntity>> saveExternalExam({
    required ExternalExamEntity externalExamEntity,
  });
  Future<Result<Failure, UploadFileResponseEntity>> uploadExternalFile({
    required UploadFileEntity uploadFileEntity,
  });
  Future<Result<Failure, ExternalExamFileEntity>> getExternalFile({
    required ExternalExamFileReqEntity externalExamFileReqEntity,
  });
  Future<Result<Failure, List<RadiationHistoryEntity>>> getRadiationHistory({
    required RadiationHistoryParamEntity radiationHistoryParamEntity,
  });
}
