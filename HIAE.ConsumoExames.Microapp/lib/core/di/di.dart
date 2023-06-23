// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:dio/dio.dart';

import '../../modules/exams/data/datasources/exam_datasource.dart';
import '../../modules/exams/domain/repositories/exam_repository_interface.dart';
import '../../modules/exams/domain/usecases/download_exams_pdf_usecase.dart';
import '../../modules/exams/domain/usecases/filter_list_exams_evolutionary_usecase.dart';
import '../../modules/exams/domain/usecases/get_all_exams_medical_records_usecase.dart';
import '../../modules/exams/domain/usecases/get_evolutive_report_usecase.dart';
import '../../modules/exams/domain/usecases/get_evolutive_result_usecase.dart';
import '../../modules/exams/domain/usecases/get_exams_date_usecase.dart';
import '../../modules/exams/domain/usecases/get_exams_details_usecase.dart';
import '../../modules/exams/domain/usecases/get_external_file_usecase.dart';
import '../../modules/exams/domain/usecases/get_first_evolutionary_report_usecase.dart';
import '../../modules/exams/domain/usecases/get_image_result_usecase.dart';
import '../../modules/exams/domain/usecases/get_map_evolutive_report_usecase.dart';
import '../../modules/exams/domain/usecases/get_patient_target_usecase.dart';
import '../../modules/exams/domain/usecases/get_pdf_result_usecase.dart';
import '../../modules/exams/domain/usecases/get_rediation_history_usecase.dart';
import '../../modules/exams/domain/usecases/group_date_usecase.dart';
import '../../modules/exams/domain/usecases/group_dates_filter_exams_usecase.dart';
import '../../modules/exams/domain/usecases/group_year_month_usecase.dart';
import '../../modules/exams/domain/usecases/list_exams_group_usecase.dart';
import '../../modules/exams/domain/usecases/remove_external_exams_usecase.dart';
import '../../modules/exams/domain/usecases/save_external_file_usecase.dart';
import '../../modules/exams/domain/usecases/set_first_open_evolutionary_report_usecase.dart';
import '../../modules/exams/domain/usecases/upload_external_file_usecase.dart';
import '../../modules/exams/infra/datasources/exam_datasource_interface.dart';
import '../../modules/exams/infra/repositories/exam_repository.dart';
import '../../modules/exams/presenter/cubits/exam_cubit.dart';
import '../../modules/home/data/datasources/validate_datasource.dart';
import '../../modules/home/domain/repositories/validate_repository_interface.dart';
import '../../modules/home/domain/usecases/open_screen_usecase.dart';
import '../../modules/home/infra/datasource/validate_datasource_interface.dart';
import '../../modules/home/infra/repository/validate_repository.dart';
import '../../modules/home/presenter/cubits/validate_cubit.dart';
import '../adapters/check_internet_connection/check_internet_connection_adapter.dart';
import '../adapters/check_internet_connection/check_internet_connection_interface.dart';
import '../adapters/http/http_client_adapter.dart';
import '../adapters/http/http_interface.dart';
import '../adapters/local_storage/local_storage_adapter.dart';
import '../adapters/local_storage/local_storage_interface.dart';
import '../adapters/pdf_view/pdf_view_adapter.dart';
import '../adapters/pdf_view/pdf_view_interface.dart';
import '../adapters/share/share_adapter.dart';
import '../adapters/share/share_interface.dart';
import '../data/datasources/local_storage_datasource.dart';
import '../infra/datasource/local_storage_datasource_interface.dart';
import '../utils/step_upload_file_provider.dart';
import 'initInjector.dart';

void adapters() {
  I.registerLazySingleton<ILocalStorage>(
    LocalStorageAdapter()..init(),
  );

  I.registerFactory<Dio>(
    () => Dio(),
  );

  I.registerFactory<IHttpClient>(
    () => HttpClient(
      I.getDependency<Dio>(),
    ),
  );

  I.registerFactory<IPdfViewAdapter>(
    () => PdfViewerAdapter(),
  );

  I.registerFactory<IShareAdapter>(
    () => ShareAdapter(),
  );
  I.registerSingleton<StepUploadFileProvider>(StepUploadFileProvider());
  I.registerSingleton<ICheckInternetConnection>(CheckInternetConnection());
}

void initUseCase() {
  I.registerFactory<IGetExamsDateCase>(
    () => GetExamsDateCase(
      repository: I.getDependency<IExamRepository>(),
    ),
  );

  I.registerFactory<IGetExamsDetailsUseCase>(
    () => GetExamsDetailsUseCase(
      repository: I.getDependency<IExamRepository>(),
    ),
  );

  I.registerFactory<GetImageExamResultUseCase>(
    () => GetImageExamResultUseCase(I.getDependency<IExamRepository>()),
  );

  I.registerFactory<GetPdfResultUseCase>(
    () => GetPdfResultUseCase(I.getDependency<IExamRepository>()),
  );

  I.registerFactory<GetEvolutiveResultUseCase>(
    () => GetEvolutiveResultUseCase(I.getDependency<IExamRepository>()),
  );

  I.registerFactory<IGroupDateUseCase>(
    () => GroupDateUseCase(),
  );

  I.registerFactory<IDownloadsExamsPdfUseCase>(
    () => DownloadsExamsPdfUseCase(
      repository: I.getDependency<IExamRepository>(),
    ),
  );

  I.registerFactory<IGroupYearMonthUseCase>(
    () => GroupYearMonthUseCase(),
  );

  I.registerFactory<IGetAllExamsMedicalRecordsUseCase>(
    () => GetAllExamsMedicalRecordsUseCase(
      repository: I.getDependency<IExamRepository>(),
    ),
  );

  I.registerFactory<IGroupDatesFilterExamsUseCase>(
    () => GroupDatesFilterExamsUseCase(),
  );

  I.registerFactory<ISaveExternalFileUseCase>(
    () => SaveExternalFileUseCase(
      repository: I.getDependency<IExamRepository>(),
    ),
  );

  I.registerFactory<UploadExternalFileUseCase>(
    () => UploadExternalFileUseCase(
      repository: I.getDependency<IExamRepository>(),
    ),
  );
  I.registerFactory<GetExternalFileUseCase>(
    () => GetExternalFileUseCase(
      repository: I.getDependency<IExamRepository>(),
    ),
  );
  I.registerFactory<GetRadiationHistoryUseCase>(
    () => GetRadiationHistoryUseCase(
      repository: I.getDependency<IExamRepository>(),
    ),
  );

  I.registerFactory<IGetPatientTargetUseCase>(
    () => PatientTargetUseCase(
      repository: I.getDependency<IExamRepository>(),
    ),
  );

  I.registerFactory<IGetFirstEvolutionaryRepositoryUseCase>(
    () => GetFirstEvolutionaryRepositoryUseCase(
      repository: I.getDependency<IExamRepository>(),
    ),
  );

  I.registerFactory<ISetFirstOpenEvolutionaryReportUseCase>(
    () => SetFirstOpenEvolutionaryReportUseCase(
      repository: I.getDependency<IExamRepository>(),
    ),
  );

  I.registerFactory<IListExamsGroupUseCase>(
    () => ListExamsGroupUseCase(
      repository: I.getDependency<IExamRepository>(),
    ),
  );

  I.registerFactory<IFilterListExamsEvolutionaryUseCase>(
    () => FilterListExamsEvolutionaryUseCase(),
  );

  I.registerFactory<IGetEvolutiveReportUseCase>(
    () => GetEvolutiveReportUseCase(
      repository: I.getDependency<IExamRepository>(),
    ),
  );

  I.registerFactory<IGetMapEvolutiveReportUseCase>(
    () => GetMapEvolutiveReportUseCase(
      repository: I.getDependency<IExamRepository>(),
    ),
  );

  I.registerFactory<IRemoveExternalExamsUseCase>(
    () => RemoveExternalExamsUseCase(
      repository: I.getDependency<IExamRepository>(),
    ),
  );

  I.registerFactory<IOpenScreenUseCase>(
    () => OpenScreenUseCase(
      repository: I.getDependency<IValidateRepository>(),
    ),
  );
}

void initRepository() {
  I.registerFactory<IValidateRepository>(
    () => ValidateRepository(
      validateDatasource: I.getDependency<IValidateDataSource>(),
    ),
  );

  I.registerFactory<IExamRepository>(
    () => ExamRepository(
      examDataSource: I.getDependency<IExamDataSource>(),
      localStorageDataSource: I.getDependency<ILocalStorageDataSource>(),
    ),
  );
}

void initDatasource() {
  I.registerFactory<IValidateDataSource>(
    () => ValidateDataSource(
      http: I.getDependency<IHttpClient>(),
    ),
  );

  I.registerFactory<IExamDataSource>(
    () => ExamDataSource(
      http: I.getDependency<IHttpClient>(),
    ),
  );

  I.registerFactory<ILocalStorageDataSource>(
    () => LocalStorageDataSource(
      localStorage: I.getDependency<ILocalStorage>(),
    ),
  );
}

void initCubit() {
  I.registerFactory(
    () => ValidateCubit(
      openScreenUseCase: I.getDependency<IOpenScreenUseCase>(),
    ),
  );

  I.registerFactory(
    () => ExamCubit(
      getDateExamUseCase: I.getDependency<IGetExamsDateCase>(),
      getExamsDetailsUseCase: I.getDependency<IGetExamsDetailsUseCase>(),
      getImageResultUseCase: I.getDependency<GetImageExamResultUseCase>(),
      getPdfResultUseCase: I.getDependency<GetPdfResultUseCase>(),
      getEvolutiveResultUseCase: I.getDependency<GetEvolutiveResultUseCase>(),
      groupDateUseCase: I.getDependency<IGroupDateUseCase>(),
      groupYearMonthUseCase: I.getDependency<IGroupYearMonthUseCase>(),
      getAllExamsMedicalRecordsUseCase:
          I.getDependency<IGetAllExamsMedicalRecordsUseCase>(),
      groupDatesFilterExamsUseCase:
          I.getDependency<IGroupDatesFilterExamsUseCase>(),
      uploadExternalFileUseCase: I.getDependency<UploadExternalFileUseCase>(),
      saveExternalFileUseCase: I.getDependency<ISaveExternalFileUseCase>(),
      getExternalFileUseCase: I.getDependency<GetExternalFileUseCase>(),
      getRadiationHistoryUseCase: I.getDependency<GetRadiationHistoryUseCase>(),
      getPatientTargetRepositoryUseCase:
          I.getDependency<IGetPatientTargetUseCase>(),
      getFirstEvolutionaryRepositoryUseCase:
          I.getDependency<IGetFirstEvolutionaryRepositoryUseCase>(),
      setFirstOpenEvolutionaryReportUseCase:
          I.getDependency<ISetFirstOpenEvolutionaryReportUseCase>(),
      listExamsGroupUseCase: I.getDependency<IListExamsGroupUseCase>(),
      filterListExamsEvolutionaryUseCase:
          I.getDependency<IFilterListExamsEvolutionaryUseCase>(),
      getEvolutiveReportUseCase: I.getDependency<IGetEvolutiveReportUseCase>(),
      getMapEvolutiveReportUseCase:
          I.getDependency<IGetMapEvolutiveReportUseCase>(),
      removeExternalExamsUseCase:
          I.getDependency<IRemoveExternalExamsUseCase>(),
    ),
  );
}
