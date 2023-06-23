import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/exceptions/exceptions.dart';
import '../../../../core/utils/primitive_wrapper.dart';
import '../../domain/entities/date_exam_entity.dart';
import '../../domain/entities/evolutionary_report_response_entity.dart';
import '../../domain/entities/exam_entity.dart';
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
import '../../domain/usecases/filter_list_exams_evolutionary_usecase.dart';
import '../../domain/usecases/get_all_exams_medical_records_usecase.dart';
import '../../domain/usecases/get_evolutive_report_usecase.dart';
import '../../domain/usecases/get_evolutive_result_usecase.dart';
import '../../domain/usecases/get_exams_date_usecase.dart';
import '../../domain/usecases/get_exams_details_usecase.dart';
import '../../domain/usecases/get_external_file_usecase.dart';
import '../../domain/usecases/get_first_evolutionary_report_usecase.dart';
import '../../domain/usecases/get_image_result_usecase.dart';
import '../../domain/usecases/get_map_evolutive_report_usecase.dart';
import '../../domain/usecases/get_patient_target_usecase.dart';
import '../../domain/usecases/get_pdf_result_usecase.dart';
import '../../domain/usecases/get_rediation_history_usecase.dart';
import '../../domain/usecases/group_date_usecase.dart';
import '../../domain/usecases/group_dates_filter_exams_usecase.dart';
import '../../domain/usecases/group_year_month_usecase.dart';
import '../../domain/usecases/list_exams_group_usecase.dart';
import '../../domain/usecases/remove_external_exams_usecase.dart';
import '../../domain/usecases/save_external_file_usecase.dart';
import '../../domain/usecases/set_first_open_evolutionary_report_usecase.dart';
import '../../domain/usecases/upload_external_file_usecase.dart';
import 'exam_state_cubit.dart';

class ExamCubit extends Cubit<ExamState> {
  final IRemoveExternalExamsUseCase _removeExternalExamsUseCase;
  final IGetMapEvolutiveReportUseCase _getMapEvolutiveReportUseCase;
  final IGetEvolutiveReportUseCase _getEvolutiveReportUseCase;
  final IGetExamsDateCase _getDateExamUseCase;
  final IGetExamsDetailsUseCase _getExamsDetailsUseCase;
  final IGroupDateUseCase _groupDateUseCase;
  final GetImageExamResultUseCase _getImageResultUseCase;
  final GetPdfResultUseCase _getPdfResultUseCase;
  final GetEvolutiveResultUseCase _getEvolutiveResultUseCase;
  final IGroupYearMonthUseCase _groupYearMonthUseCase;
  final IGetAllExamsMedicalRecordsUseCase _getAllExamsMedicalRecordsUseCase;
  final IGroupDatesFilterExamsUseCase _groupDatesFilterExamsUseCase;
  final UploadExternalFileUseCase _uploadExternalFileUseCase;
  final ISaveExternalFileUseCase _saveExternalFileUseCase;
  final GetExternalFileUseCase _getExternalFileUseCase;
  final GetRadiationHistoryUseCase _getRadiationHistoryUseCase;
  final IGetPatientTargetUseCase _getPatientTargetRepositoryUseCase;
  final ISetFirstOpenEvolutionaryReportUseCase
      _setFirstOpenEvolutionaryReportUseCase;
  final IGetFirstEvolutionaryRepositoryUseCase
      _getFirstEvolutionaryRepositoryUseCase;
  final IFilterListExamsEvolutionaryUseCase _filterListExamsEvolutionaryUseCase;
  final IListExamsGroupUseCase _listExamsGroupUseCase;

  Map<int, List<int>>? datesCards;
  late final List<DateExamEntity> listDateExams;
  final List<ExamsMedicalRecordsEntity> listMedicalRecordsExams = [];

  bool isLoadedAllDates = false;

  void emitVoice() {
    emit(EmitVoiceState());
  }

  void expandedAll(bool open) {
    emit(ExpandedAllButtonState(open: open));
  }

  ExamCubit({
    required IGetMapEvolutiveReportUseCase getMapEvolutiveReportUseCase,
    required IGetExamsDateCase getDateExamUseCase,
    //required ListExamesAndResultUseCase listExamesAndResultUseCase,
    required IGetExamsDetailsUseCase getExamsDetailsUseCase,
    required GetImageExamResultUseCase getImageResultUseCase,
    required GetPdfResultUseCase getPdfResultUseCase,
    required GetEvolutiveResultUseCase getEvolutiveResultUseCase,
    required IGroupDateUseCase groupDateUseCase,
    required IGroupYearMonthUseCase groupYearMonthUseCase,
    required IGetAllExamsMedicalRecordsUseCase getAllExamsMedicalRecordsUseCase,
    required IGroupDatesFilterExamsUseCase groupDatesFilterExamsUseCase,
    required UploadExternalFileUseCase uploadExternalFileUseCase,
    required ISaveExternalFileUseCase saveExternalFileUseCase,
    required GetExternalFileUseCase getExternalFileUseCase,
    required GetRadiationHistoryUseCase getRadiationHistoryUseCase,
    required IGetPatientTargetUseCase getPatientTargetRepositoryUseCase,
    required ISetFirstOpenEvolutionaryReportUseCase
        setFirstOpenEvolutionaryReportUseCase,
    required IGetFirstEvolutionaryRepositoryUseCase
        getFirstEvolutionaryRepositoryUseCase,
    required IListExamsGroupUseCase listExamsGroupUseCase,
    required IFilterListExamsEvolutionaryUseCase
        filterListExamsEvolutionaryUseCase,
    required IGetEvolutiveReportUseCase getEvolutiveReportUseCase,
    required IRemoveExternalExamsUseCase removeExternalExamsUseCase,
  })  : _getMapEvolutiveReportUseCase = getMapEvolutiveReportUseCase,
        _getDateExamUseCase = getDateExamUseCase,
        _getExamsDetailsUseCase = getExamsDetailsUseCase,
        _getImageResultUseCase = getImageResultUseCase,
        _getPdfResultUseCase = getPdfResultUseCase,
        _getEvolutiveResultUseCase = getEvolutiveResultUseCase,
        _groupDateUseCase = groupDateUseCase,
        _groupYearMonthUseCase = groupYearMonthUseCase,
        _getAllExamsMedicalRecordsUseCase = getAllExamsMedicalRecordsUseCase,
        _groupDatesFilterExamsUseCase = groupDatesFilterExamsUseCase,
        _uploadExternalFileUseCase = uploadExternalFileUseCase,
        _saveExternalFileUseCase = saveExternalFileUseCase,
        _getExternalFileUseCase = getExternalFileUseCase,
        _getRadiationHistoryUseCase = getRadiationHistoryUseCase,
        _getPatientTargetRepositoryUseCase = getPatientTargetRepositoryUseCase,
        _setFirstOpenEvolutionaryReportUseCase =
            setFirstOpenEvolutionaryReportUseCase,
        _getFirstEvolutionaryRepositoryUseCase =
            getFirstEvolutionaryRepositoryUseCase,
        _listExamsGroupUseCase = listExamsGroupUseCase,
        _filterListExamsEvolutionaryUseCase =
            filterListExamsEvolutionaryUseCase,
        _getEvolutiveReportUseCase = getEvolutiveReportUseCase,
        _removeExternalExamsUseCase = removeExternalExamsUseCase,
        super(ExamInitialState()) {
    listDateExams = [];
  }

  Future<void> removeExternalExams({
    required String id,
  }) async {
    final result = await _removeExternalExamsUseCase(id: id);

    if (result.isSuccess && result.value!) {}
  }

  void filterExamsEvolutionaryReport({
    required String? filter,
    required Map<String, List<ExamsMedicalRecordsEntity>> data,
  }) {
    final dataFiltered = _filterListExamsEvolutionaryUseCase(
      filter: filter,
      data: data,
    );

    emit(ExamGroup(examData: dataFiltered));
  }

  Future<EvolutionaryReportExamsEntity?> getMapEvolutionaryReportExams({
    required Map<String, List<String>> mapExams,
  }) async {
    final result = await _getMapEvolutiveReportUseCase(
      mapExams: mapExams,
    );

    if (result.isSuccess) {
      emit(
        GetEvolutionaryReportExamsState(
          evolutionaryReportExams: result.value!,
        ),
      );
      return result.value!;
    } else {
      emit(ExamFailureState(failure: result.error!));
      return null;
    }
  }

  Future<EvolutionaryReportExamsEntity?> getEvolutionaryReportExams({
    required List<String> examsCodes,
  }) async {
    final result = await _getEvolutiveReportUseCase(
      examsCodes: examsCodes,
    );

    if (result.isSuccess) {
      emit(
        GetEvolutionaryReportExamsState(
          evolutionaryReportExams: result.value!,
        ),
      );
      return result.value!;
    } else {
      emit(ExamFailureState(failure: result.error!));
      return null;
    }
  }

  Future<void> getExamsGroup() async {
    emit(ExamLoadState());
    final result = await _listExamsGroupUseCase(
      dateFinal: null,
      dateInitial: null,
    );

    if (result.isSuccess) {
      emit(ExamGroup(examData: result.value!));
    } else {
      if (result.error is! HttpNoContent) {
        emit(ExamFailureState(failure: result.error!));
      } else {
        emit(ExamFailureEmptyGroupExam(failure: result.error!));
      }
    }
  }

  void setFirstOpenEvolutionaryReport() {
    _setFirstOpenEvolutionaryReportUseCase();
  }

  bool getFirstEvolutionaryRepository() {
    final result = _getFirstEvolutionaryRepositoryUseCase();

    return result.isSuccess ? result.value! : false;
  }

  void statusButton(bool status) {
    emit((StatusButton(status)));
  }

  PatientTargetEntity getPatientTarget() =>
      _getPatientTargetRepositoryUseCase();

  Future<ExamPdfResultEntity?> downloadsExamsPdf(PdfResultParam param) async {
    final result = await _getPdfResultUseCase.call(param);
    return result.value;
  }

  void loadShowMoreExams(int value) {
    emit(StatusLoadMoreExams(value));
  }

  Future<ExternalExamFileEntity?> getExternalExam(
    ExternalExamFileReqEntity param,
  ) async {
    final result = await _getExternalFileUseCase.call(param);
    return result.value;
  }

  void incSelectedExams(int count) {
    emit(IncSelectedExamState(count: count));
  }

  void filterExam({required List<ExamsMedicalRecordsEntity> data}) {
    emit(FilterExamState(data));
  }

  void clearStatus() {
    emit(ExamInitialState());
  }

  Future<List<ExamsMedicalRecordsEntity>> getAllMedicalRecordsExams({
    required DateTime dateInitial,
    required DateTime dateFinal,
  }) async {
    emit(ExamLoadState());
    final result = await _getAllExamsMedicalRecordsUseCase(
      dateInitial: dateInitial,
      dateFinal: dateFinal,
    );
    final value =
        result.value != null ? result.value! : <ExamsMedicalRecordsEntity>[];
    emit(ExamsAllRecordsStatus(data: value));
    return value;
  }

  Future<void> loadExamDateAndMedicalRecords({
    required LoadDateExamEntity loadDataExamEntity,
  }) async {
    emit(ExamLoadState());

    await Future.wait(
      [
        _getDateExamUseCase(loadDataExamEntity: loadDataExamEntity),
        _getAllExamsMedicalRecordsUseCase(
          dateInitial: null,
          dateFinal: null,
        ),
      ],
    ).then((value) {
      if (value[1].isSuccess) {
        if (listMedicalRecordsExams.isNotEmpty) {
          listMedicalRecordsExams.clear();
        }

        listMedicalRecordsExams
            .addAll(value[1].value! as List<ExamsMedicalRecordsEntity>);
      } else {
        listMedicalRecordsExams.clear();
      }

      if (value[0].isSuccess) {
        final list = value[0].value as DataExamResponseEntity;
        listDateExams.clear();
        listDateExams.addAll(list.listDateExamEntity);
        isLoadedAllDates =
            list.message == null || list.message?.toUpperCase() == 'FIM';

        if (listDateExams.isNotEmpty || list.externalDate.isNotEmpty) {
          _groupDateUseCase(
            listDate: listDateExams,
            externalDate: list.externalDate,
          );

          datesCards ??= _groupYearMonthUseCase(listDate: [...listDateExams]);

          emit(ExamDateLoadSuccessState());
        } else {
          emit(ExamEmptyState());
        }
      } else {
        isLoadedAllDates = false;
        if (value[0].error is! HttpNoContent) {
          emit(ExamFailureState(failure: value[0].error!));
        } else {
          emit(ExamEmptyState());
        }
      }
    });
  }

  void msgNewExternalExam(ExamEntity exam) {
    emit(ExamSuccessNewExamState(examEntity: exam));
  }

  Future<void> loadExamDate({
    required LoadDateExamEntity loadDataExamEntity,
    bool clearList = false,
  }) async {
    emit(ExamLoadState());
    final result =
        await _getDateExamUseCase.call(loadDataExamEntity: loadDataExamEntity);

    if (result.isSuccess) {
      if (clearList) {
        listDateExams.clear();
      }

      listDateExams.addAll(result.value!.listDateExamEntity);
      isLoadedAllDates = result.value!.message == null ||
          result.value!.message?.toUpperCase() == 'FIM';

      _groupDateUseCase(
        listDate: listDateExams,
        externalDate: result.value!.externalDate,
      );

      emit(ExamDateLoadSuccessState());
    } else {
      isLoadedAllDates = false;
      emit(ExamFailureState(failure: result.error!));
    }
  }

  Future<void> loadFilter({
    required LoadExamEntity loadExamEntity,
  }) async {
    emit(ExamLoadState());

    final result =
        await _getExamsDetailsUseCase(loadExamEntity: loadExamEntity);

    if (result.isSuccess) {
      var examsAccount = PrimitiveWrapper<int>();

      final mapData = _groupDatesFilterExamsUseCase(
        resultInternalExam: result.value!.resultInternalExam,
        resultExternalExam: result.value!.resultExternalExam,
        account: examsAccount,
      );

      if (mapData.isEmpty) {
        emit(ExamFilterEmptyState());
      } else {
        emit(
          ExamLoadFilter(
            data: mapData,
            examsAccount: examsAccount.value ?? 0,
          ),
        );
      }
    } else {
      if (result.error is! HttpNoContent) {
        emit(ExamFailureState(failure: result.error!));
      } else {
        emit(ExamFilterEmptyState());
      }
    }
  }

  Future<MedicalAppointmentListResultExamsEntity?> loadExamsDetails({
    required LoadExamEntity loadExamEntity,
  }) async {
    final result =
        await _getExamsDetailsUseCase(loadExamEntity: loadExamEntity);

    if (result.isSuccess) {
      return result.value!;
    } else if (result.error is! HttpNoContent) {
      emit(ExamFailureState(failure: result.error!));
    }
    return null;
  }

  Future<ExamImageResultEntity?> refreshImageResult(
    ExamImageParam param,
  ) async {
    final result = await _getImageResultUseCase.call(param);
    if (result.isSuccess) {
      return result.value!;
    }
    return null;
  }

  Future<ExamImageResultEntity?> loadImageResult(ExamImageParam param) async {
    emit(ExamLoadState());

    final result = await _getImageResultUseCase.call(param);

    if (result.isSuccess) {
      emit(ExamImageSuccessState(data: result.value!));
      return result.value!;
    } else {
      emit(ExamFailureState(failure: result.error!));
    }
    return null;
  }

  Future<ExamPdfResultEntity?> loadPdfResult(PdfResultParam param) async {
    emit(ExamLoadState());
    final result = await _getPdfResultUseCase.call(param);

    if (result.isSuccess) {
      emit(ExamPdfSuccessState(data: result.value!));
      return result.value!;
    } else {
      emit(ExamFailureState(failure: result.error!));
    }
    return null;
  }

  Future<void> loadEvolutiveResult(EvolutiveParam param) async {
    emit(ExamLoadState());
    final result = await _getEvolutiveResultUseCase.call(param);

    if (result.isSuccess) {
      emit(ExamEvolutiveSuccessState(data: result.value!));
    } else {
      emit(ExamFailureState(failure: result.error!));
    }
  }

  Future<UploadFileResponseEntity?> uploadExternalFile({
    required UploadFileEntity uploadFileEntity,
  }) async {
    emit(ExamLoadState());
    final result = await _uploadExternalFileUseCase.call(uploadFileEntity);

    if (result.isSuccess) {
      emit(UploadFileSuccessState(data: result.value!));
      return result.value!;
    } else {
      emit(ExamFailureState(failure: result.error!));
      return null;
    }
  }

  Future<ExternalExamEntity?> saveExternalFile({
    required ExternalExamEntity externalExamEntity,
  }) async {
    emit(ExamLoadState());
    final result = await _saveExternalFileUseCase.call(externalExamEntity);
    if (result.isSuccess) {
      emit(ExamDateLoadSuccessState());
      return result.value;
    } else {
      emit(ExamFailureState(failure: result.error!));
      return null;
    }
  }

  void emitAllExamsLoaded() {
    emit(AllResultExamLoadedState());
  }

  Future<List<RadiationHistoryEntity>?> getRadiationHistory({
    required RadiationHistoryParamEntity radiationHistoryParamEntity,
  }) async {
    emit(ExamLoadState());
    final result =
        await _getRadiationHistoryUseCase.call(radiationHistoryParamEntity);
    if (result.isSuccess) {
      emit(RadiationHistorySuccessState(data: result.value!));
      return result.value;
    } else {
      emit(ExamFailureState(failure: result.error!));
    }
  }
}
