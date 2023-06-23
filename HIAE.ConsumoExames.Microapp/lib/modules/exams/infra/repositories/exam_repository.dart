import '../../../../core/di/initInjector.dart';
import '../../../../core/exceptions/exceptions.dart';
import '../../../../core/infra/datasource/local_storage_datasource_interface.dart';
import '../../../../core/utils/local_storage_utils.dart';
import '../../../../core/utils/result.dart';
import '../../../../core/utils/step_upload_file_provider.dart';
import '../../domain/entities/date_exam_entity.dart';
import '../../domain/entities/download_exam_entity.dart';
import '../../domain/entities/evolutionary_report_request_entity.dart';
import '../../domain/entities/evolutionary_report_response_entity.dart';
import '../../domain/entities/exam_evolutive_result_entity.dart';
import '../../domain/entities/exam_image_result_entity.dart';
import '../../domain/entities/exam_pdf_result_entity.dart';
import '../../domain/entities/exams_medical_records_entity.dart';
import '../../domain/entities/external_exam_entity.dart';
import '../../domain/entities/external_exam_file_entity.dart';
import '../../domain/entities/external_exam_file_req_entity.dart';
import '../../domain/entities/load_date_exam_entity.dart';
import '../../domain/entities/load_exams_entity.dart';
import '../../domain/entities/medical_appointment_list_result_exams_entity.dart';
import '../../domain/entities/patient_target_entity.dart';
import '../../domain/entities/radiation_history_entity.dart';
import '../../domain/entities/radiation_history_param_entity.dart';
import '../../domain/entities/upload_file_entity.dart';
import '../../domain/entities/upload_file_response_entity.dart';
import '../../domain/repositories/exam_repository_interface.dart';
import '../../domain/usecases/get_evolutive_result_usecase.dart';
import '../../domain/usecases/get_image_result_usecase.dart';
import '../../domain/usecases/get_pdf_result_usecase.dart';
import '../datasources/exam_datasource_interface.dart';

class ExamRepository implements IExamRepository {
  final IExamDataSource _examDataSource;
  final ILocalStorageDataSource _localStorageDataSource;

  @override
  Future<Result<Failure, String>> downloadExamsPdf({
    required DownloadExamEntity downloadExamEntity,
  }) async {
    try {
      downloadExamEntity.medicalAppointment = getIdPatient();
      final result = await _examDataSource.downloadExamsPdf(
        downloadExamEntity: downloadExamEntity,
      );
      return Result.success(result);
    } on NoInternetConnectionFailure catch (error, stackTrace) {
      return Result.failure(
        NoInternetConnectionFailure(
          message: error.toString(),
          stackTrace: stackTrace,
        ),
      );
    } on HttpNoContent catch (error, stackTrace) {
      return Result.failure(
        HttpNoContent(
          message: error.message,
          stackTrace: stackTrace,
        ),
      );
    } catch (error, stackTrace) {
      return Result.failure(
        HttpFailure(
          message: error.toString(),
          stackTrace: stackTrace,
        ),
      );
    }
  }

  ExamRepository({
    required IExamDataSource examDataSource,
    required ILocalStorageDataSource localStorageDataSource,
  })  : _examDataSource = examDataSource,
        _localStorageDataSource = localStorageDataSource;

  @override
  Future<Result<Failure, MedicalAppointmentListResultExamsEntity>>
      getExamsDetails({required LoadExamEntity loadExamEntity}) async {
    try {
      loadExamEntity.medicalAppointment = getIdPatient();

      final result =
          await _examDataSource.getExamsDetails(loadExamEntity: loadExamEntity);
      return Result.success(result);
    } on NoInternetConnectionFailure catch (error, stackTrace) {
      return Result.failure(
        NoInternetConnectionFailure(
          message: error.toString(),
          stackTrace: stackTrace,
        ),
      );
    } on HttpNoContent catch (error, stackTrace) {
      return Result.failure(
        HttpNoContent(
          message: error.message,
          stackTrace: stackTrace,
        ),
      );
    } catch (error, stackTrace) {
      return Result.failure(
        HttpFailure(
          message: error.toString(),
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<Result<Failure, DataExamResponseEntity>> getExamsDate({
    required LoadDateExamEntity loadDataExamEntity,
  }) async {
    try {
      loadDataExamEntity.medicalAppointment = getIdPatient();

      final result = await _examDataSource.getExamsDate(
        loadDataExamEntity: loadDataExamEntity,
      );

      return Result.success(result);
    } on NoInternetConnectionFailure catch (error, stackTrace) {
      return Result.failure(
        NoInternetConnectionFailure(
          message: error.toString(),
          stackTrace: stackTrace,
        ),
      );
    } on HttpNoContent catch (error, stackTrace) {
      return Result.failure(
        HttpNoContent(
          message: error.message,
          stackTrace: stackTrace,
        ),
      );
    } catch (error, stackTrace) {
      return Result.failure(
        HttpFailure(
          message: error.toString(),
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<Result<Failure, ExamPdfResultEntity>> getPdfResult(
    PdfResultParam param,
  ) async {
    try {
      final result = await _examDataSource.getPdfResult(
        param,
      );
      return Result.success(result);
    } on NoInternetConnectionFailure catch (error, stackTrace) {
      return Result.failure(
        NoInternetConnectionFailure(
          message: error.toString(),
          stackTrace: stackTrace,
        ),
      );
    } on HttpNoContent catch (error, stackTrace) {
      return Result.failure(
        HttpNoContent(
          message: error.message,
          stackTrace: stackTrace,
        ),
      );
    } catch (error, stackTrace) {
      return Result.failure(
        HttpFailure(
          message: error.toString(),
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<Result<Failure, ExamImageResultEntity>> getImageExamResult(
    ExamImageParam param,
  ) async {
    try {
      final result = await _examDataSource.getImageExamResult(param);
      return Result.success(result);
    } on NoInternetConnectionFailure catch (error, stackTrace) {
      return Result.failure(
        NoInternetConnectionFailure(
          message: error.toString(),
          stackTrace: stackTrace,
        ),
      );
    } on HttpNoContent catch (error, stackTrace) {
      return Result.failure(
        HttpNoContent(
          message: error.message,
          stackTrace: stackTrace,
        ),
      );
    } catch (error, stackTrace) {
      return Result.failure(
        HttpFailure(
          message: error.toString(),
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<Result<Failure, ExamEvolutiveResultEntity>> getEvolutiveResult(
    EvolutiveParam param,
  ) async {
    // Future<Result<Failure, ExamPdfResultEntity>> getPdfResult(loadDataExamEntity) async {
    try {
      // loadDataExamEntity.medicalAppointment = getUserIdentifier();

      // final result = await _examDataSource.getEvolutiveResult(
      //   param,
      // );
      throw Exception('error');
      // return Result.success(result);
    } on NoInternetConnectionFailure catch (error, stackTrace) {
      return Result.failure(
        NoInternetConnectionFailure(
          message: error.toString(),
          stackTrace: stackTrace,
        ),
      );
    } on HttpNoContent catch (error, stackTrace) {
      return Result.failure(
        HttpNoContent(
          message: error.message,
          stackTrace: stackTrace,
        ),
      );
    } catch (error, stackTrace) {
      return Result.failure(
        HttpFailure(
          message: error.toString(),
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<Result<Failure, List<ExamsMedicalRecordsEntity>>>
      getAllExamsMedicalRecords({
    required DateTime dateInitial,
    required DateTime dateFinal,
  }) async {
    try {
      final String medicalRecords = getIdPatient();

      final result = await _examDataSource.getAllExamsMedicalRecords(
        medicalRecords: medicalRecords,
        dateInitial: dateInitial,
        dateFinal: dateFinal,
      );

      return Result.success(result);
    } on NoInternetConnectionFailure catch (error, stackTrace) {
      return Result.failure(
        NoInternetConnectionFailure(
          message: error.toString(),
          stackTrace: stackTrace,
        ),
      );
    } on HttpNoContent catch (error, stackTrace) {
      return Result.failure(
        HttpNoContent(
          message: error.message,
          stackTrace: stackTrace,
        ),
      );
    } catch (error, stackTrace) {
      return Result.failure(
        HttpFailure(
          message: error.toString(),
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<Result<Failure, ExternalExamEntity>> saveExternalExam({
    required ExternalExamEntity externalExamEntity,
  }) async {
    try {
      final result = await _examDataSource.saveExternalExam(
        externalExamEntity: externalExamEntity,
      );
      return Result.success(result);
    } on NoInternetConnectionFailure catch (error, stackTrace) {
      return Result.failure(
        NoInternetConnectionFailure(
          message: error.toString(),
          stackTrace: stackTrace,
        ),
      );
    } on HttpNoContent catch (error, stackTrace) {
      return Result.failure(
        HttpNoContent(
          message: error.message,
          stackTrace: stackTrace,
        ),
      );
    } catch (error, stackTrace) {
      return Result.failure(
        HttpFailure(
          message: error.toString(),
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<Result<Failure, UploadFileResponseEntity>> uploadExternalFile({
    required UploadFileEntity uploadFileEntity,
  }) async {
    try {
      final result = await _examDataSource.uploadExternalFile(
        uploadFileEntity: uploadFileEntity,
        onSendProgress: (int sent, int total) {
          I.getDependency<StepUploadFileProvider>().updateProgress(
                sent: sent,
                total: total,
              );
        },
      );
      return Result.success(result);
    } on NoInternetConnectionFailure catch (error, stackTrace) {
      return Result.failure(
        NoInternetConnectionFailure(
          message: error.toString(),
          stackTrace: stackTrace,
        ),
      );
    } on HttpNoContent catch (error, stackTrace) {
      return Result.failure(
        HttpNoContent(
          message: error.message,
          stackTrace: stackTrace,
        ),
      );
    } catch (error, stackTrace) {
      return Result.failure(
        HttpFailure(
          message: error.toString(),
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<Result<Failure, ExternalExamFileEntity>> getExternalFile({
    required ExternalExamFileReqEntity externalExamFileReqEntity,
  }) async {
    try {
      final result = await _examDataSource.getExternalFile(
        externalExamFileReqEntity: externalExamFileReqEntity,
      );
      return Result.success(result);
    } on NoInternetConnectionFailure catch (error, stackTrace) {
      return Result.failure(
        NoInternetConnectionFailure(
          message: error.toString(),
          stackTrace: stackTrace,
        ),
      );
    } on HttpNoContent catch (error, stackTrace) {
      return Result.failure(
        HttpNoContent(
          message: error.message,
          stackTrace: stackTrace,
        ),
      );
    } catch (error, stackTrace) {
      return Result.failure(
        HttpFailure(
          message: error.toString(),
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<Result<Failure, List<RadiationHistoryEntity>>> getRadiationHistory({
    required RadiationHistoryParamEntity radiationHistoryParamEntity,
  }) async {
    try {
      final result = await _examDataSource.getRadiationHistory(
        radiationHistoryParamEntity: radiationHistoryParamEntity,
      );
      return Result.success(result);
    } on NoInternetConnectionFailure catch (error, stackTrace) {
      return Result.failure(
        NoInternetConnectionFailure(
          message: error.toString(),
          stackTrace: stackTrace,
        ),
      );
    } on HttpNoContent catch (error, stackTrace) {
      return Result.failure(
        HttpNoContent(
          message: error.message,
          stackTrace: stackTrace,
        ),
      );
    } catch (error, stackTrace) {
      return Result.failure(
        HttpFailure(
          message: error.toString(),
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  PatientTargetEntity getPatientTarget() => getPatientTargetStorage();

  @override
  Result<Failure, bool> getFirstEvolutionaryReport() {
    try {
      final result = _localStorageDataSource.getFirstEvolutionaryReport();
      return Result.success(result);
    } on NoInternetConnectionFailure catch (error, stackTrace) {
      return Result.failure(
        NoInternetConnectionFailure(
          message: error.toString(),
          stackTrace: stackTrace,
        ),
      );
    } on HttpNoContent catch (error, stackTrace) {
      return Result.failure(
        HttpNoContent(
          message: error.message,
          stackTrace: stackTrace,
        ),
      );
    } catch (error, stackTrace) {
      return Result.failure(
        LocalStorageFailure(
          message: error.toString(),
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Failure? setFirstEvolutionaryReport() {
    try {
      _localStorageDataSource.setFirstEvolutionaryReport();
    } catch (error, stackTrace) {
      return LocalStorageFailure(
        message: error.toString(),
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<Result<Failure, EvolutionaryReportExamsEntity>> getEvolutionaryReport({
    required String examsCodes,
  }) async {
    try {
      final String medicalRecords = getIdPatient();

      final result = await _examDataSource.getEvolutionaryReport(
        evolutionaryReportLoad: EvolutionaryReportRequestEntity(
          examCode: examsCodes,
          medicalAppointment: medicalRecords,
          numberOfRecords: 0,
          chAuthentication: null,
          finalDate: null,
          initialDate: null,
        ),
      );
      return Result.success(result);
    } on NoInternetConnectionFailure catch (error, stackTrace) {
      return Result.failure(
        NoInternetConnectionFailure(
          message: error.toString(),
          stackTrace: stackTrace,
        ),
      );
    } on HttpNoContent catch (error, stackTrace) {
      return Result.failure(
        HttpNoContent(
          message: error.message,
          stackTrace: stackTrace,
        ),
      );
    } catch (error, stackTrace) {
      return Result.failure(
        HttpFailure(
          message: error.toString(),
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<Result<Failure, bool>> removeExternalExam({
    required String id,
  }) async {
    try {
      final result = await _examDataSource.removeExternalExam(id: id);

      return Result.success(result);
    } on NoInternetConnectionFailure catch (error, stackTrace) {
      return Result.failure(
        NoInternetConnectionFailure(
          message: error.toString(),
          stackTrace: stackTrace,
        ),
      );
    } on HttpNoContent catch (error, stackTrace) {
      return Result.failure(
        HttpNoContent(
          message: error.message,
          stackTrace: stackTrace,
        ),
      );
    } catch (error, stackTrace) {
      return Result.failure(
        HttpFailure(
          message: error.toString(),
          stackTrace: stackTrace,
        ),
      );
    }
  }
}
