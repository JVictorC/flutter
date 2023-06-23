import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:path_provider/path_provider.dart';

import 'package:micro_app_consumo_exame/core/adapters/http/client_response.dart';
import 'package:micro_app_consumo_exame/core/adapters/http/http_interface.dart';
import 'package:micro_app_consumo_exame/core/constants/api_routes.dart';
import 'package:micro_app_consumo_exame/core/di/initInjector.dart';
import 'package:micro_app_consumo_exame/core/exceptions/exceptions.dart';
import 'package:micro_app_consumo_exame/core/utils/step_upload_file_provider.dart';
import 'package:micro_app_consumo_exame/modules/exams/data/datasources/exam_datasource.dart';
import 'package:micro_app_consumo_exame/modules/exams/data/models/download_exam_model.dart';
import 'package:micro_app_consumo_exame/modules/exams/data/models/exam_evolutive_result_model.dart';
import 'package:micro_app_consumo_exame/modules/exams/data/models/exam_pdf_result_model.dart';
import 'package:micro_app_consumo_exame/modules/exams/data/models/image_exam_result_model.dart';
import 'package:micro_app_consumo_exame/modules/exams/data/models/load_date_exam_model.dart';
import 'package:micro_app_consumo_exame/modules/exams/data/models/load_exams_model.dart';
import 'package:micro_app_consumo_exame/modules/exams/domain/entities/date_exam_entity.dart';
import 'package:micro_app_consumo_exame/modules/exams/domain/entities/download_exam_entity.dart';
import 'package:micro_app_consumo_exame/modules/exams/domain/entities/evolutionary_report_request_entity.dart';
import 'package:micro_app_consumo_exame/modules/exams/domain/entities/evolutionary_report_response_entity.dart';
import 'package:micro_app_consumo_exame/modules/exams/domain/entities/exams_filters_entity.dart';
import 'package:micro_app_consumo_exame/modules/exams/domain/entities/exams_filters_external_entity.dart';
import 'package:micro_app_consumo_exame/modules/exams/domain/entities/exams_medical_records_entity.dart';
import 'package:micro_app_consumo_exame/modules/exams/domain/entities/external_exam_entity.dart';
import 'package:micro_app_consumo_exame/modules/exams/domain/entities/external_exam_file_entity.dart';
import 'package:micro_app_consumo_exame/modules/exams/domain/entities/external_exam_file_req_entity.dart';
import 'package:micro_app_consumo_exame/modules/exams/domain/entities/load_date_exam_entity.dart';
import 'package:micro_app_consumo_exame/modules/exams/domain/entities/load_exams_entity.dart';
import 'package:micro_app_consumo_exame/modules/exams/domain/entities/medical_appointment_list_result_exams_entity.dart';
import 'package:micro_app_consumo_exame/modules/exams/domain/entities/radiation_history_entity.dart';
import 'package:micro_app_consumo_exame/modules/exams/domain/entities/radiation_history_param_entity.dart';
import 'package:micro_app_consumo_exame/modules/exams/domain/entities/upload_file_entity.dart';
import 'package:micro_app_consumo_exame/modules/exams/domain/entities/upload_file_response_entity.dart';
import 'package:micro_app_consumo_exame/modules/exams/domain/usecases/get_evolutive_result_usecase.dart';
import 'package:micro_app_consumo_exame/modules/exams/domain/usecases/get_image_result_usecase.dart';
import 'package:micro_app_consumo_exame/modules/exams/domain/usecases/get_pdf_result_usecase.dart';
import 'exam_datasource_test.mocks.dart';

@GenerateMocks([IHttpClient])
void main() {
  late MockIHttpClient mockHttp;
  late ExamDataSource examDataSource;
  String authentication = '2231869';

  setUpAll(() {
    initInjector();
    mockHttp = MockIHttpClient();
    examDataSource = ExamDataSource(http: mockHttp);
  });

  group('downloadExamsPdf', () {
    test(
      'should return Exception when status code is equals 500',
      () async {
        final mapResponse = {
          'pdfResult': 'error',
        };
        final DownloadExamEntity downloadExamEntity = DownloadExamEntity(
          examBreak: true,
          userType: 0,
          examCode: null,
          itensIdList: const ['62f40faf66226523b0590ddf'],
          passage: null,
          medicalAppointment: authentication,
          executionDateBegin: DateTime.now().add(
            const Duration(
              days: 1,
            ),
          ),
          executionDateEnd: DateTime.now().add(
            const Duration(
              days: 1,
            ),
          ),
        );

        when(mockHttp.post(any, body: anyNamed('body'))).thenAnswer(
          (_) async => ClientResponse(data: mapResponse, statusCode: 500),
        );

        expect(
          () async => await examDataSource.downloadExamsPdf(
            downloadExamEntity: downloadExamEntity,
          ),
          throwsA(isA<Exception>()),
        );
        verify(
          mockHttp.post(
            ApiRoutes.examPdf,
            body: DownloadExamModel.fromEntity(entity: downloadExamEntity),
          ),
        ).called(1);
      },
    );

    test(
      'should return HttpNoContent when status code is equals 204 ',
      () async {
        final mapResponse = {
          'pdfResult': null,
        };
        final DownloadExamEntity downloadExamEntity = DownloadExamEntity(
          examBreak: true,
          userType: 0,
          examCode: null,
          itensIdList: const ['62f40faf66226523b0590ddf'],
          passage: null,
          medicalAppointment: authentication,
          executionDateBegin: DateTime.now().add(
            const Duration(
              days: 1,
            ),
          ),
          executionDateEnd: DateTime.now().add(
            const Duration(
              days: 1,
            ),
          ),
        );

        when(mockHttp.post(any, body: anyNamed('body'))).thenAnswer(
          (_) async => ClientResponse(data: mapResponse, statusCode: 204),
        );

        expect(
          () => examDataSource.downloadExamsPdf(
            downloadExamEntity: downloadExamEntity,
          ),
          throwsA(isA<HttpNoContent>()),
        );

        verify(
          mockHttp.post(
            ApiRoutes.examPdf,
            body: DownloadExamModel.fromEntity(entity: downloadExamEntity),
          ),
        ).called(1);
      },
    );
    test(
      'should return String when httpClient returns String '
      '[downloadExamsPdf]'
      '',
      () async {
        final mapResponse = {
          'pdfResult': 'teste resultado',
        };

        final downloadExamEntity = DownloadExamEntity(
          medicalAppointment: authentication,
          passage: null,
          executionDateBegin: DateTime(2016, 10, 01),
          executionDateEnd: DateTime(2022, 08, 15),
          examCode: null,
          itensIdList: const ['62f40faf66226523b0590ddf'],
          examBreak: true,
          userType: 0,
        );

        when(
          mockHttp.post(
            any,
            body: anyNamed('body'),
          ),
        ).thenAnswer(
          (_) async => ClientResponse(
            data: mapResponse,
            statusCode: 200,
          ),
        );

        final result = await examDataSource.downloadExamsPdf(
          downloadExamEntity: downloadExamEntity,
        );

        expect(result, isA<String>());

        verify(
          mockHttp.post(
            ApiRoutes.examPdf,
            body: DownloadExamModel.fromEntity(entity: downloadExamEntity),
          ),
        ).called(1);
      },
    );
  });

  group('getExamsDate', () {
    test('Should return exception when HttpClient return Exception', () async {
      final LoadDateExamEntity loadDataExamEntity = LoadDateExamEntity(
        exams: null,
        medicalAppointment: null,
        passageType: null,
        numberOfRecords: 0,
        chAuthentication: authentication,
        initialDate: DateTime.now().add(
          const Duration(days: 10),
        ),
        finalDate: DateTime.now().add(
          const Duration(days: 10),
        ),
      );

      when(mockHttp.post(any, body: anyNamed('body'))).thenAnswer(
        (_) async => const ClientResponse(data: null, statusCode: 500),
      );

      expect(
        () async => await examDataSource.getExamsDate(
          loadDataExamEntity: loadDataExamEntity,
        ),
        throwsA(isA<Exception>()),
      );
    });

    test(
      'Should return Not Content when HttpClient return status code 204',
      () async {
        final LoadDateExamEntity loadDataExamEntity = LoadDateExamEntity(
          exams: null,
          medicalAppointment: null,
          passageType: null,
          numberOfRecords: 0,
          chAuthentication: authentication,
          initialDate: DateTime.now().add(
            const Duration(days: 10),
          ),
          finalDate: DateTime.now().add(
            const Duration(days: 10),
          ),
        );

        when(mockHttp.post(any, body: anyNamed('body'))).thenAnswer(
          (_) async => const ClientResponse(data: null, statusCode: 204),
        );

        expect(
          () => examDataSource.getExamsDate(
            loadDataExamEntity: loadDataExamEntity,
          ),
          throwsA(isA<HttpNoContent>()),
        );
      },
    );

    test(
      'Should return DataExamResponseEntity when HttpClient returns Map<dynamic,string> ',
      () async {
        final LoadDateExamEntity loadDataExamEntity = LoadDateExamEntity(
          exams: null,
          medicalAppointment: null,
          passageType: null,
          numberOfRecords: 0,
          chAuthentication: authentication,
          initialDate: DateTime(2017, 01, 01),
          finalDate: DateTime.now(),
        );
        Map<String, dynamic> mapResponse = {
          'status': 1,
          'occurrences': 97,
          'dates': [
            {
              'passageId': '29960007',
              'dtExecution': '2022-10-07T00:00:00',
              'position': 1,
              'passagePlace': 'Morumbi',
              'passageType': 'O',
            },
          ],
        };
        final data = LoadDateExamModel.fromEntity(loadDataExamEntity).toMap();

        when(
          mockHttp.post(
            any,
            body: anyNamed('body'),
          ),
        ).thenAnswer(
          (_) async => ClientResponse(data: mapResponse, statusCode: 200),
        );

        final dataResult = await examDataSource.getExamsDate(
          loadDataExamEntity: loadDataExamEntity,
        );

        verify(
          mockHttp.post(
            ApiRoutes.dateExam,
            body: data,
          ),
        ).called(1);

        expect(dataResult, isA<DataExamResponseEntity>());
      },
    );
  });

  group('getExamsDetails', () {
    final LoadExamEntity loadExamEntity = LoadExamEntity(
      medicalAppointment: authentication,
      chAuthentication: null,
      lab: null,
      results: false,
      initialDate: DateTime(2017, 01, 01),
      finalDate: DateTime(2022, 10, 23),
      auxPrint: false,
      numberOfRecords: null,
      passageId: null,
      idItens: null,
      exams: null,
      filters: ExamFiltersEntity(
        examId: null,
        examName: null,
        examType: null,
        executionFinalDate: null,
        executionInitialDate: null,
        passType: null,
        unity: null,
      ),
      externalFilters: FiltersExternalEntity(
        examName: null,
        examType: null,
        executionFinalDate: null,
        executionInitialDate: null,
      ),
    );

    test('Should call exception where httpClient return exception', () async {
      when(mockHttp.post(any, body: anyNamed('body'))).thenAnswer(
        (_) async => const ClientResponse(
          data: null,
          statusCode: 500,
        ),
      );

      expect(
        () => examDataSource.getExamsDetails(loadExamEntity: loadExamEntity),
        throwsA(isA<Exception>()),
      );
    });
    test(
      'Should return No Content when return httpClient return status code equals is 204',
      () {
        when(mockHttp.post(any, body: anyNamed('body'))).thenAnswer(
          (_) async => const ClientResponse(
            data: null,
            statusCode: 204,
          ),
        );

        expect(
          () => examDataSource.getExamsDetails(loadExamEntity: loadExamEntity),
          throwsA(isA<HttpNoContent>()),
        );
      },
    );

    test(
      'should return MedicalAppointmentListResultExamsEntity Result Model when return status code of httpClient equals is 200',
      () async {
        final mapResponse = {
          'status': 0,
          'occurrences': 55,
          'passages': {
            'medicalAppointmentListResultExams': [
              {
                'status': 0,
                'ocorrencies': 1,
                'passage': {
                  'id': '29960007',
                  'passageNumber': 'E23725284',
                  'passageDate': '2022-10-06T00:00:00',
                  'type': '2',
                  'place': 'Morumbi',
                  'medicalRecords': 2231869,
                  'patientName': 'Teste Vivwefwefwef Telemedicina',
                  'patientGender': 'Masculino',
                  'patientDob': '2001-03-17T00:00:00',
                  'doctorAdmName': null,
                  'doctorAdmIdentity': null,
                  'blocked': false,
                  'medicalRecordsBlocked': false,
                  'room': null,
                  'passport': '555777228722',
                  'identity': '52581061014',
                },
                'exams': [
                  {
                    'examId': '28145208||5',
                    'passageId': '29960007',
                    'passageDate': '0001-01-01T00:00:00',
                    'passageIdLab': null,
                    'examName': 'ANDROSTENEDIONA',
                    'examCode': 'LAND',
                    'labCode': '46032477',
                    'examType': 1,
                    'executionDate': '2022-10-07T00:00:00',
                    'executionHour': null,
                    'available': false,
                    'security': false,
                    'releaseDate': null,
                    'blocked': false,
                    'doctorName': null,
                    'doctorIdentity': null,
                    'laudo': false,
                    'laudoFile': null,
                    'place': 'Morumbi',
                    'accessNumber': '28145208/59',
                    'urL1': null,
                    'urL2': null,
                    'result': null,
                    'itemsQuantity': 0,
                    'items': null,
                    'position': 1,
                    'statusResult': 4,
                    'linesQuantity': null,
                    'idmedicalRecords': '2454193',
                    'itemCategory': 'Laboratorio Analises Clinicas',
                    'orderDate': '0001-01-01T00:00:00',
                    'sttDate': '0001-01-01T00:00:00',
                    'executionDate2': '2022-10-07T00:00:00',
                    'tagValue': null,
                    'passType': '2',
                  },
                ],
              },
            ],
          },
          'passagesExternal': {
            'externalExam': [],
          },
        };

        when(mockHttp.post(any, body: anyNamed('body'))).thenAnswer(
          (_) async => ClientResponse(
            data: mapResponse,
            statusCode: 200,
          ),
        );
        MedicalAppointmentListResultExamsEntity result = await examDataSource
            .getExamsDetails(loadExamEntity: loadExamEntity);

        expect(result, isA<MedicalAppointmentListResultExamsEntity>());

        verify(
          mockHttp.post(
            ApiRoutes.examDetail,
            body: LoadExamsModel.fromEntity(loadExamEntity).toMap(),
          ),
        ).called(1);
      },
    );
  });

  group('getPdfResult', () {
    final PdfResultParam pdfResultParam = PdfResultParam(
      medicalAppointment: authentication,
      examBreak: true,
      examCode: null,
      executionDateBegin: DateTime.now().subtract(
        const Duration(days: 300),
      ),
      executionDateEnd: DateTime(2017, 1, 1),
      itensIdList: const ['62f40faf66226523b0590ddf'],
      userType: 0,
      passage: null,
    );
    test(
      'Should return ExamPdfResultModel model when returns status code of httpClient equals is 200',
      () async {
        final mapResponse = {'pdfResult': 'result'};

        when(mockHttp.post(any, body: anyNamed('body'))).thenAnswer(
          (_) async => ClientResponse(
            data: mapResponse,
            statusCode: 200,
          ),
        );

        final result = await examDataSource.getPdfResult(pdfResultParam);

        expect(result, isA<ExamPdfResultModel>());
      },
    );

    test(
      'Should return No Content model when returns status code of httpClient equals is 204',
      () async {
        final mapResponse = {'pdfResult': 'result'};

        when(mockHttp.post(any, body: anyNamed('body'))).thenAnswer(
          (_) async => const ClientResponse(
            data: null,
            statusCode: 204,
          ),
        );

        expect(
          () => examDataSource.getPdfResult(pdfResultParam),
          throwsA(isA<HttpNoContent>()),
        );
      },
    );

    test(
      'Should call exception when httpClient return Exceptions',
      () async {
        when(mockHttp.post(any, body: anyNamed('body'))).thenAnswer(
          (_) async => const ClientResponse(
            data: null,
            statusCode: 500,
          ),
        );

        expect(
          () => examDataSource.getPdfResult(pdfResultParam),
          throwsA(
            isA<Exception>(),
          ),
        );
      },
    );
  });

  group('getEvolutiveResult', () {
    final EvolutiveParam evolutiveParam = EvolutiveParam(
      chAuthentication: authentication,
      codExam: null,
      dtCut: null,
      idPassage: null,
      qtdPassages: null,
    );
    test(
      'Should return ExamEvolutiveResultModel model when returns status code of httpClient equals is 200',
      () async {
        final mapResponse = {
          'chAuthentication': '',
          'idPassage': '20351262',
          'codExam': 'LM611',
          'qtdPassages': 0,
          'dtCut': '2010-06-09',
          'filters': {
            'codExam': 'B025',
          },
        };

        when(mockHttp.post(any, body: anyNamed('body'))).thenAnswer(
          (_) async => ClientResponse(
            data: mapResponse,
            statusCode: 200,
          ),
        );

        final result = await examDataSource.getEvolutiveResult(evolutiveParam);

        expect(result, isA<ExamEvolutiveResultModel>());
      },
    );

    test(
      'Should return not Content when returns status code of httpClient equals is 204',
      () async {
        when(mockHttp.post(any, body: anyNamed('body'))).thenAnswer(
          (_) async => const ClientResponse(
            data: null,
            statusCode: 204,
          ),
        );

        expect(
          () => examDataSource.getEvolutiveResult(evolutiveParam),
          throwsA(
            isA<HttpNoContent>(),
          ),
        );
      },
    );

    test(
      'Should call Exception when returns Exception httpClient',
      () async {
        when(mockHttp.post(any, body: anyNamed('body'))).thenAnswer(
          (_) async => const ClientResponse(
            data: null,
            statusCode: 500,
          ),
        );

        expect(
          () => examDataSource.getEvolutiveResult(evolutiveParam),
          throwsA(
            isA<Exception>(),
          ),
        );
      },
    );
  });

  group('getAllExamsMedicalRecords', () {
    DateTime dateInitial = DateTime.now();
    DateTime dateFinal = DateTime.now();
    test(
      'Should return List<ExamsMedicalRecordsEntity> model when returns status code of httpClient equals is 200',
      () async {
        final mapResponse = {
          'exams': [
            {
              'examCode': 'examCode',
              'examName': 'examName',
              'itemCategory': 'itemCategory',
            },
          ],
        };
        when(mockHttp.post(any, body: anyNamed('body'))).thenAnswer(
          (_) async => ClientResponse(
            data: mapResponse,
            statusCode: 200,
          ),
        );

        final result = await examDataSource.getAllExamsMedicalRecords(
          dateInitial: dateInitial,
          dateFinal: dateFinal,
          medicalRecords: authentication,
        );

        expect(result, isA<List<ExamsMedicalRecordsEntity>>());
      },
    );

    test(
      'Should return not Content when returns status code of httpClient equals is 204',
      () async {
        when(mockHttp.post(any, body: anyNamed('body'))).thenAnswer(
          (_) async => const ClientResponse(
            data: null,
            statusCode: 204,
          ),
        );

        expect(
          () => examDataSource.getAllExamsMedicalRecords(
            dateInitial: dateInitial,
            dateFinal: dateFinal,
            medicalRecords: authentication,
          ),
          throwsA(
            isA<HttpNoContent>(),
          ),
        );
      },
    );

    test(
      'Should call Exception when returns Exception httpClient',
      () async {
        when(mockHttp.post(any, body: anyNamed('body'))).thenAnswer(
          (_) async => const ClientResponse(
            data: null,
            statusCode: 500,
          ),
        );

        expect(
          () => examDataSource.getAllExamsMedicalRecords(
            dateInitial: dateInitial,
            dateFinal: dateFinal,
            medicalRecords: authentication,
          ),
          throwsA(
            isA<Exception>(),
          ),
        );
      },
    );
  });

  group('saveExternalExam', () {
    final ExternalExamEntity externalExam = ExternalExamEntity(
      examType: 1,
      executionDate: DateTime.now(),
      uploadDate: DateTime.now(),
      examName: null,
      fileId: null,
      id: null,
      labName: null,
      path: null,
      url: null,
      medicalRecords: authentication,
    );

    test(
      'Should return ExternalExamEntity when returns httpClient status code equals is 200 ',
      () async {
        final mapResponse = {
          'examType': 1,
          'executionDate': DateFormat('yyyy-MM-dd').format(DateTime.now()),
          'uploadDate': DateFormat('yyyy-MM-dd').format(DateTime.now()),
          'examName': null,
          'fileId': null,
          'id': null,
          'labName': null,
          'path': null,
          'url': null,
          'medicalRecords': authentication,
        };

        when(mockHttp.post(any, body: anyNamed('body'))).thenAnswer(
          (realInvocation) async => ClientResponse(
            data: mapResponse,
            statusCode: 200,
          ),
        );

        final result = await examDataSource.saveExternalExam(
          externalExamEntity: externalExam,
        );

        expect(result, isA<ExternalExamEntity>());
      },
    );

    test(
      'Should return not Content when returns status code of httpClient equals is 204',
      () async {
        when(mockHttp.post(any, body: anyNamed('body'))).thenAnswer(
          (_) async => const ClientResponse(
            data: null,
            statusCode: 204,
          ),
        );

        expect(
          () => examDataSource.saveExternalExam(
            externalExamEntity: externalExam,
          ),
          throwsA(
            isA<HttpNoContent>(),
          ),
        );
      },
    );

    test(
      'Should call Exception when returns Exception httpClient',
      () async {
        when(mockHttp.post(any, body: anyNamed('body'))).thenAnswer(
          (_) async => const ClientResponse(
            data: null,
            statusCode: 500,
          ),
        );

        expect(
          () => examDataSource.saveExternalExam(
            externalExamEntity: externalExam,
          ),
          throwsA(
            isA<Exception>(),
          ),
        );
      },
    );
  });

  group('uploadExternalFile', () {
    const UploadFileEntity uploadFileEntity = UploadFileEntity(
      file: 'test_resources/file.json',
      fileName: 'filename',
    );

    final onSendProgress = (int sent, int total) {
      I.getDependency<StepUploadFileProvider>().updateProgress(
            sent: sent,
            total: total,
          );
    };

    test(
      'Should return uploadExternalFile when returns httpClient status code equals is 200 ',
      () async {
        final directory = await getApplicationDocumentsDirectory();
        await directory.exists().then((value) {
          if (value) {
            directory.create();
          }
        });

        final mapResponse = {
          'id': 'id',
          'bucket': 'bucket',
          'path': 'path',
          'size': 10,
          'lastModified': DateFormat('yyyy-MM-dd').format(DateTime.now()),
          'urlFile': 'urlFile',
        };

        when(
          mockHttp.post(
            any,
            body: anyNamed('body'),
            onSendProgress: onSendProgress,
          ),
        ).thenAnswer(
          (_) async => ClientResponse(
            data: mapResponse,
            statusCode: 200,
          ),
        );

        final result = await examDataSource.uploadExternalFile(
          uploadFileEntity: uploadFileEntity,
          onSendProgress: onSendProgress,
        );

        expect(result, isA<UploadFileResponseEntity>());
      },
    );

    test(
      'Should return not Content when returns status code of httpClient equals is 204',
      () async {
        when(
          mockHttp.post(
            any,
            body: anyNamed('body'),
            onSendProgress: anyNamed('onSendProgress'),
          ),
        ).thenAnswer(
          (_) async => const ClientResponse(
            data: null,
            statusCode: 204,
          ),
        );

        expect(
          () => examDataSource.uploadExternalFile(
            uploadFileEntity: uploadFileEntity,
            onSendProgress: onSendProgress,
          ),
          throwsA(
            isA<HttpNoContent>(),
          ),
        );
      },
    );

    test(
      'Should call Exception when returns Exception httpClient',
      () async {
        when(
          mockHttp.post(
            any,
            body: anyNamed('body'),
            onSendProgress: anyNamed('onSendProgress'),
          ),
        ).thenAnswer(
          (_) async => const ClientResponse(
            data: null,
            statusCode: 500,
          ),
        );

        expect(
          () => examDataSource.uploadExternalFile(
            uploadFileEntity: uploadFileEntity,
            onSendProgress: onSendProgress,
          ),
          throwsA(
            isA<Exception>(),
          ),
        );
      },
    );
  });

  group('getExternalFile', () {
    const ExternalExamFileReqEntity externalExamFileReqEntity =
        ExternalExamFileReqEntity(
      file: 'file',
      path: 'path',
    );

    test(
      'Should return ExternalExamFileEntity when returns httpClient status code equals is 200 ',
      () async {
        final mapResponse = {
          'path': 'path',
          'file': 'file',
        };

        when(mockHttp.post(any, body: anyNamed('body'))).thenAnswer(
          (realInvocation) async => ClientResponse(
            data: mapResponse,
            statusCode: 200,
          ),
        );

        final result = await examDataSource.getExternalFile(
          externalExamFileReqEntity: externalExamFileReqEntity,
        );

        expect(result, isA<ExternalExamFileEntity>());
      },
    );

    test(
      'Should return not Content when returns status code of httpClient equals is 204',
      () async {
        when(mockHttp.post(any, body: anyNamed('body'))).thenAnswer(
          (_) async => const ClientResponse(
            data: null,
            statusCode: 204,
          ),
        );

        expect(
          () => examDataSource.getExternalFile(
            externalExamFileReqEntity: externalExamFileReqEntity,
          ),
          throwsA(
            isA<HttpNoContent>(),
          ),
        );
      },
    );

    test(
      'Should call Exception when returns Exception httpClient',
      () async {
        when(mockHttp.post(any, body: anyNamed('body'))).thenAnswer(
          (_) async => const ClientResponse(
            data: null,
            statusCode: 500,
          ),
        );

        expect(
          () => examDataSource.getExternalFile(
            externalExamFileReqEntity: externalExamFileReqEntity,
          ),
          throwsA(
            isA<Exception>(),
          ),
        );
      },
    );
  });

  group('getRadiationHistory', () {
    const RadiationHistoryParamEntity radiationHistoryParamEntity =
        RadiationHistoryParamEntity(
      medicalAppointment: 1,
      examCode: null,
      examGroup: null,
    );

    test(
      'Should return List of RadiationHistoryEntity when returns httpClient status code equals is 200 ',
      () async {
        final mapResponse = [
          {
            'examRadiationId': 1,
            'examDescription': null,
            'medicalAppointment': 1,
            'itemLaunchDate': DateFormat('yyyy-MM-dd').format(DateTime.now()),
            'groupRadiationId': 1,
            'groupDescriptionExam': null,
            'unityId': 1,
            'examCod': null,
            'radiationUnity': null,
          },
        ];

        when(mockHttp.post(any, body: anyNamed('body'))).thenAnswer(
          (realInvocation) async => ClientResponse(
            data: mapResponse,
            statusCode: 200,
          ),
        );

        final result = await examDataSource.getRadiationHistory(
          radiationHistoryParamEntity: radiationHistoryParamEntity,
        );

        expect(result, isA<List<RadiationHistoryEntity>>());
      },
    );

    test(
      'Should return not Content when returns status code of httpClient equals is 204',
      () async {
        when(mockHttp.post(any, body: anyNamed('body'))).thenAnswer(
          (_) async => const ClientResponse(
            data: null,
            statusCode: 204,
          ),
        );

        expect(
          () => examDataSource.getRadiationHistory(
            radiationHistoryParamEntity: radiationHistoryParamEntity,
          ),
          throwsA(
            isA<HttpNoContent>(),
          ),
        );
      },
    );

    test(
      'Should call Exception when returns Exception httpClient',
      () async {
        when(mockHttp.post(any, body: anyNamed('body'))).thenAnswer(
          (_) async => const ClientResponse(
            data: null,
            statusCode: 500,
          ),
        );

        expect(
          () => examDataSource.getRadiationHistory(
            radiationHistoryParamEntity: radiationHistoryParamEntity,
          ),
          throwsA(
            isA<Exception>(),
          ),
        );
      },
    );
  });

  group('getEvolutionaryReport', () {
    final EvolutionaryReportRequestEntity evolutionaryReportRequestEntity =
        EvolutionaryReportRequestEntity(
      chAuthentication: authentication,
      examCode: '',
      finalDate: DateTime.now(),
      initialDate: DateTime.now(),
      medicalAppointment: authentication,
      numberOfRecords: 1,
    );

    test(
      'Should return EvolutionaryReportExamsEntity when returns httpClient status code equals is 200 ',
      () async {
        final mapResponse = {
          'status': 0,
          'descr': 'Sucesso!',
          'examsConsultation': [
            {
              'code': 'LAGP',
              'codeLabTrak': 'J019',
              'description': 'Agregacao Plaquetaria ADP e ADN',
              'itensConsultation': [
                {
                  'code': 'T9214',
                  'description': 'Resultado COVID-19:',
                  'resultsConsultation': [
                    {
                      'valueResult': 'Detectado',
                      'valueRefMin': 0,
                      'valueRefMax': 0,
                      'unityResult': null,
                      'defaultRefValue': null,
                      'anormalResult': true,
                      'dateResult': '2022-09-08',
                      'hourResult': '11:14:00Z',
                      'idItenResult': '28141350||9',
                      'labTestSetRowResult': null,
                      'typeResult': 'LAB',
                      'idPassageResult': '29956146',
                      'sttDateResult': '2022-09-08',
                    },
                  ],
                },
              ],
            },
          ],
        };

        when(mockHttp.post(any, body: anyNamed('body'))).thenAnswer(
          (realInvocation) async => ClientResponse(
            data: mapResponse,
            statusCode: 200,
          ),
        );

        final result = await examDataSource.getEvolutionaryReport(
          evolutionaryReportLoad: evolutionaryReportRequestEntity,
        );

        expect(result, isA<EvolutionaryReportExamsEntity>());
      },
    );

    test(
      'Should return not Content when returns status code of httpClient equals is 204',
      () async {
        when(mockHttp.post(any, body: anyNamed('body'))).thenAnswer(
          (_) async => const ClientResponse(
            data: null,
            statusCode: 204,
          ),
        );

        expect(
          () => examDataSource.getEvolutionaryReport(
            evolutionaryReportLoad: evolutionaryReportRequestEntity,
          ),
          throwsA(
            isA<HttpNoContent>(),
          ),
        );
      },
    );

    test(
      'Should call Exception when returns Exception httpClient',
      () async {
        when(mockHttp.post(any, body: anyNamed('body'))).thenAnswer(
          (_) async => const ClientResponse(
            data: null,
            statusCode: 500,
          ),
        );

        expect(
          () => examDataSource.getEvolutionaryReport(
            evolutionaryReportLoad: evolutionaryReportRequestEntity,
          ),
          throwsA(
            isA<Exception>(),
          ),
        );
      },
    );
  });

  group('removeExternalExam', () {
    test(
      'Should return true when returns httpClient status code equals is 200',
      () async {
        const ClientResponse response = ClientResponse(
          data: null,
          statusCode: 200,
        );

        const idValue = '633d787e9a0e93fe7b983714';

        final queryParameters = {'id': idValue};

        when(
          mockHttp.delete(
            any,
            queryParameters: queryParameters,
          ),
        ).thenAnswer(
          (realInvocation) async => response,
        );

        final result = await examDataSource.removeExternalExam(
          id: idValue,
        );

        expect(result, isA<bool>());
        expect(result, equals(true));
      },
    );
    test(
      '204',
      () async {
        const ClientResponse response = ClientResponse(
          data: null,
          statusCode: 204,
        );
        when(
          mockHttp.delete(
            any,
            queryParameters: anyNamed('queryParameters'),
          ),
        ).thenAnswer(
          (realInvocation) async => response,
        );

        final result = await examDataSource.removeExternalExam(
          id: '633d787e9a0e93fe7b983714',
        );

        expect(result, isA<bool>());
        expect(result, equals(false));
      },
    );
  });

  group(
    'getImageExamResult',
    () {
      const ExamImageParam param = ExamImageParam(
        accessionNumber: null,
        issuer: null,
        patientId: null,
        studyInstanceUID: null,
      );

      test(
        'Should return ExamImageResultModel model when return httpClient status code is equal  200',
        () async {
          final mapResponse = {'getUserTokenResult': ''};
          when(
            mockHttp.post(
              any,
              body: anyNamed('body'),
            ),
          ).thenAnswer(
            (realInvocation) async => ClientResponse(
              data: mapResponse,
              statusCode: 200,
            ),
          );

          final result = await examDataSource.getImageExamResult(param);

          expect(result, isA<ExamImageResultModel>());
        },
      );

      test(
        'Should return not Content when returns status code of httpClient equals is 204',
        () async {
          when(mockHttp.post(any, body: anyNamed('body'))).thenAnswer(
            (_) async => const ClientResponse(
              data: null,
              statusCode: 204,
            ),
          );

          expect(
            () => examDataSource.getImageExamResult(
              param,
            ),
            throwsA(
              isA<HttpNoContent>(),
            ),
          );
        },
      );

      test(
        'Should call Exception when returns Exception httpClient',
        () async {
          when(mockHttp.post(any, body: anyNamed('body'))).thenAnswer(
            (_) async => const ClientResponse(
              data: null,
              statusCode: 500,
            ),
          );

          expect(
            () => examDataSource.getImageExamResult(
              param,
            ),
            throwsA(
              isA<Exception>(),
            ),
          );
        },
      );
    },
  );
}
