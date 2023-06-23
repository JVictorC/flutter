import 'dart:convert';

import 'package:intl/intl.dart';

import '../../../../core/adapters/http/client_response.dart';
import '../../../../core/adapters/http/http_interface.dart';
import '../../../../core/constants/api_routes.dart';
import '../../../../core/constants/strings.dart';
import '../../../../core/exceptions/exceptions.dart';
import '../../../../core/extensions/translate_extension.dart';
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
import '../../infra/datasources/exam_datasource_interface.dart';
import '../models/date_exam_model.dart';
import '../models/download_exam_model.dart';
import '../models/evolutionary_report_request_model.dart';
import '../models/evolutionary_report_response_model.dart';
import '../models/exam_evolutive_result_model.dart';
import '../models/exam_pdf_result_model.dart';
import '../models/exams_medical_records_model.dart';
import '../models/external_exam_file_model.dart';
import '../models/external_exam_file_req_model.dart';
import '../models/external_exam_model.dart';
import '../models/image_exam_result_model.dart';
import '../models/load_date_exam_model.dart';
import '../models/load_exams_model.dart';
import '../models/medical_appointment_list_result_exams_model.dart';
import '../models/radiation_history_model.dart';
import '../models/radiation_history_param_model.dart';
import '../models/upload_file_model.dart';
import '../models/upload_file_response_model.dart';

class ExamDataSource implements IExamDataSource {
  final IHttpClient _http;

  ExamDataSource({required IHttpClient http}) : _http = http;

  @override
  Future<String> downloadExamsPdf({
    required DownloadExamEntity downloadExamEntity,
  }) async {
    final data = DownloadExamModel.fromEntity(entity: downloadExamEntity);

    final response = await _http.post(
      ApiRoutes.examPdf,
      body: data,
    );

    if (response.statusCode == 200) {
      return response.data['pdfResult'] as String;
    } else if (response.statusCode == 204) {
      throw HttpNoContent(
        message: NO_RECORD_FOUND.translate(),
      );
    } else {
      throw Exception(response.data);
    }
  }

  @override
  Future<MedicalAppointmentListResultExamsEntity> getExamsDetails({
    required LoadExamEntity loadExamEntity,
  }) async {
    final data = LoadExamsModel.fromEntity(loadExamEntity).toMap();

    final response = await _http.post(
      ApiRoutes.examDetail,
      body: data,
    );

    if (response.statusCode == 200) {
      return MedicalAppointmentListResultExamsModel.fromMap(response.data);
    } else if (response.statusCode == 204) {
      throw HttpNoContent(
        message: NO_RECORD_FOUND.translate(),
      );
    } else {
      throw Exception();
    }
  }

  @override
  Future<DataExamResponseEntity> getExamsDate({
    required LoadDateExamEntity loadDataExamEntity,
  }) async {
    final data = LoadDateExamModel.fromEntity(loadDataExamEntity).toMap();

    final response = await _http.post(
      ApiRoutes.dateExam,
      body: data,
    );

    if (response.statusCode == 200) {
      return DataExamResponseModel.fromMap(response.data);
    } else if (response.statusCode == 204) {
      throw HttpNoContent(
        message: NO_RECORD_FOUND.translate(),
      );
    } else {
      throw Exception();
    }
  }

  @override
  Future<ExamPdfResultModel> getPdfResult(PdfResultParam param) async {
    final body = ExamPdfResultModel.toRequest(param);
    late ClientResponse response;
    response = await _http.post(
      ApiRoutes.examPdf,
      body: json.encode(body),
    );
    if (response.statusCode == 200) {
      return ExamPdfResultModel.fromMap(response.data);
    } else if (response.statusCode == 204) {
      throw HttpNoContent(
        message: NO_RECORD_FOUND.translate(),
      );
    } else {
      throw Exception();
    }
  }

  @override
  Future<ExamImageResultModel> getImageExamResult(ExamImageParam param) async {
    final response = await _http.post(
      ApiRoutes.examImage,
      body: json.encode(
        ExamImageResultModel.toRequest(param),
      ),
    );

    if (response.statusCode == 200) {
      return ExamImageResultModel.fromMap(response.data);
    } else if (response.statusCode == 204) {
      throw HttpNoContent(
        message: NO_RECORD_FOUND.translate(),
      );
    } else {
      throw Exception();
    }
  }

  @override
  Future<ExamEvolutiveResultModel> getEvolutiveResult(
    EvolutiveParam param,
  ) async {
    final response = await _http.post(
      ApiRoutes.examEvolutive,
      body: ExamEvolutiveResultModel.toRequest(param),
    );

    if (response.statusCode == 200) {
      return ExamEvolutiveResultModel.fromMap(response.data);
    } else if (response.statusCode == 204) {
      throw HttpNoContent(
        message: NO_RECORD_FOUND.translate(),
      );
    } else {
      throw Exception();
    }
  }

  @override
  Future<List<ExamsMedicalRecordsEntity>> getAllExamsMedicalRecords({
    required String medicalRecords,
    required DateTime dateInitial,
    required DateTime dateFinal,
  }) async {
    final response = await _http.post(
      ApiRoutes.listAllExamMedicalRecords,
      body: {
        'chAuthentication': null,
        'medicalRecords': medicalRecords,
        'initialDate': DateFormat('yyyy-MM-dd').format(dateInitial),
        'finalDate': DateFormat('yyyy-MM-dd').format(dateFinal),
      },
    );

    if (response.statusCode == 200) {
      return List<ExamsMedicalRecordsEntity>.from(
        response.data['exams'].map(
          (e) => ExamsMedicalRecordsModel.fromMap(e),
        ),
      );
    } else if (response.statusCode == 204) {
      throw HttpNoContent(
        message: NO_RECORD_FOUND.translate(),
      );
    } else {
      throw Exception();
    }
  }

  @override
  Future<ExternalExamEntity> saveExternalExam({
    required ExternalExamEntity externalExamEntity,
  }) async {
    final data = ExternalExamModel.fromEntity(externalExamEntity).toMap();

    final response = await _http.post(
      ApiRoutes.externalExam,
      body: data,
    );

    if (response.statusCode == 200) {
      return ExternalExamModel.fromMap(response.data);
    } else if (response.statusCode == 204) {
      throw HttpNoContent(
        message: NO_RECORD_FOUND.translate(),
      );
    } else {
      throw Exception();
    }
  }

  @override
  Future<UploadFileResponseEntity> uploadExternalFile({
    required UploadFileEntity uploadFileEntity,
    required Function(int, int) onSendProgress,
  }) async {
    final data = UploadFileModel.fromEntity(uploadFileEntity).toMap();

    final response = await _http.post(
      ApiRoutes.uploadFile,
      body: data,
      onSendProgress:
          onSendProgress, /*(int sent, int total) {
        I.getDependency<StepUploadFileProvider>().updateProgress(
              sent: sent,
              total: total,
            );
      },*/
    );

    if (response.statusCode == 200) {
      return UploadFileResponseModel.fromMap(response.data);
    } else if (response.statusCode == 204) {
      throw HttpNoContent(
        message: NO_RECORD_FOUND.translate(),
      );
    } else {
      throw Exception();
    }
  }

  @override
  Future<ExternalExamFileEntity> getExternalFile({
    required ExternalExamFileReqEntity externalExamFileReqEntity,
  }) async {
    final data =
        ExternalExamFileReqModel.fromEntity(externalExamFileReqEntity).toMap();

    final response = await _http.post(
      ApiRoutes.downloadFile,
      body: data,
    );
    if (response.statusCode == 200) {
      return ExternalExamFileModel.fromMap(response.data);
    } else if (response.statusCode == 204) {
      throw HttpNoContent(
        message: NO_RECORD_FOUND.translate(),
      );
    } else {
      throw Exception();
    }
  }

  @override
  Future<List<RadiationHistoryEntity>> getRadiationHistory({
    required RadiationHistoryParamEntity radiationHistoryParamEntity,
  }) async {
    final data =
        RadiationHistoryParamModel.fromEntity(radiationHistoryParamEntity)
            .toMap();

    final response = await _http.post(
      ApiRoutes.radiationExposure,
      body: data,
    );
    if (response.statusCode == 200) {
      final List result = response.data as List;

      return result.map((e) => RadiationHistoryModel.fromMap(e)).toList();
    } else if (response.statusCode == 204) {
      throw HttpNoContent(
        message: NO_RECORD_FOUND.translate(),
      );
    } else {
      throw Exception();
    }
  }

  @override
  Future<EvolutionaryReportExamsEntity> getEvolutionaryReport({
    required EvolutionaryReportRequestEntity evolutionaryReportLoad,
  }) async {
    final data = EvolutionaryReportRequestModel.fromEntity(
      entity: evolutionaryReportLoad,
    ).toMap();

    final response = await _http.post(
      ApiRoutes.evolutionaryReport,
      body: data,
    );

    if (response.statusCode == 200) {
      return EvolutionaryReportExamsModel.fromMap(response.data);
    } else if (response.statusCode == 204) {
      throw HttpNoContent(
        message: NO_RECORD_FOUND.translate(),
      );
    } else {
      throw Exception();
    }
  }

  @override
  Future<bool> removeExternalExam({
    required String id,
  }) async {
    final response = await _http.delete(
      ApiRoutes.examsResultsRemoveExternalExam,
      queryParameters: {
        'id': id,
      },
    );

    return response.statusCode == 200;
  }
}
