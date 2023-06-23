import 'dart:async';
import 'dart:convert';

import 'package:base_dependencies/dependencies.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/adapters/priting/printing_adapter.dart';
import '../../../../core/adapters/share/share_adapter.dart';
import '../../../../core/adapters/share/share_interface.dart';
import '../../../../core/adapters/speech/speech_adapter.dart';
import '../../../../core/adapters/speech/speech_interface.dart';
import '../../../../core/constants/assets_constants.dart';
import '../../../../core/constants/parameters_constants.dart';
import '../../../../core/constants/routes.dart';
import '../../../../core/constants/strings.dart';
import '../../../../core/di/initInjector.dart';
import '../../../../core/exceptions/exceptions.dart';
import '../../../../core/extensions/date_time_extension.dart';
import '../../../../core/extensions/mobile_size_extension.dart';
import '../../../../core/extensions/numeric_helper_extension.dart';
import '../../../../core/extensions/string_extension.dart';
import '../../../../core/extensions/translate_extension.dart';
import '../../../../core/utils/camera_file_picker.dart';
import '../../../../core/utils/handler_files_picker.dart';
import '../../../../core/utils/local_storage_utils.dart';
import '../../../../core/utils/open_url.dart';
import '../../../../core/utils/primitive_wrapper.dart';
import '../../../../core/utils/show_loading_dialog.dart';
import '../../../../core/widgets/bread_crumbs.dart';
import '../../../../core/widgets/default_app_bar.dart';
import '../../../../core/widgets/default_header_title.dart';
import '../../../../core/widgets/header_expansion_tile.dart';
import '../../domain/entities/exam_entity.dart';
import '../../domain/entities/exams_filters_entity.dart';
import '../../domain/entities/exams_filters_external_entity.dart';
import '../../domain/entities/external_exam_entity.dart';
import '../../domain/entities/global_filter_entity.dart';
import '../../domain/entities/load_date_exam_entity.dart';
import '../../domain/entities/load_exams_entity.dart';
import '../../domain/usecases/get_pdf_result_usecase.dart';
import '../cubits/exam_cubit.dart';
import '../cubits/exam_state_cubit.dart';
import '../widgets/button_clear_list_exam.dart';
import '../widgets/button_filter.dart';
import '../widgets/clear_fields_filter_label.dart';
import '../widgets/error_upload_bottom_sheet.dart';
import '../widgets/exam_filter_all_types_widget.dart';
import '../widgets/exam_upload_mobile_bottom_sheet.dart';
import '../widgets/filter_body_widget.dart';
import '../widgets/filter_category.dart';
import '../widgets/float_menu_button.dart';
import '../widgets/header_filter_exam.dart';
import '../widgets/header_group_year.dart';
import '../widgets/label_count_exams.dart';
import '../widgets/list_load_exams_button.dart';
import '../widgets/list_search_exams.dart';
import '../widgets/load_exams_details.dart';
import 'button_shortcut.dart';
import 'imported_exams_filter.dart';
import 'passage_type_filter.dart';
import 'released_results_filter_page.dart';
import 'selecte_date_filters_page.dart';
import 'unity_einstein_filter.dart';

enum FilterType {
  date,
  category,
  released_results,
  einstein_unity,
  passage,
  imported,
  all,
}

class ListExamsPage extends StatefulWidget {
  const ListExamsPage({Key? key}) : super(key: key);

  @override
  State<ListExamsPage> createState() => _ListExamsPageState();
}

class _ListExamsPageState extends State<ListExamsPage> {
  final int fiveYearsInDays = 1825;
  bool emptyExams = false;

  late final ExamCubit _cubit;
  late LoadDateExamEntity loadDateFilter; //carrega as datas

  late ExamFiltersEntity internalFilter; //filtro interno
  late FiltersExternalEntity externalFilter; //filtro externo

  late final TextEditingController _controllerSearch;
  late final TextEditingController _controllerVoice;
  late final DateTime dateStart;
  late final DateTime dateEnd;
  late final ISpeech _speech;
  late bool visibleLabelCount;
  late ScrollController _scrollController;
  late ScrollController _bodyScrollController;
  late final PrimitiveWrapper<bool> enableCardFilters;
  late final PrimitiveWrapper<String> examCode;
  late final PrimitiveWrapper<bool> localLab;
  late final PrimitiveWrapper<bool> otherLab;
  late final List<String> shareList;

  int loadCountList = 10;
  DateTime? dateCardInit;
  DateTime? dateCardFinal;
  late final ValueNotifier<bool> shareExamState;
  int? selectedYearCard;
  int? selectedMonthCard;
  double? positionScroll;

  Future<void> _loadData() async => await _cubit.loadExamDateAndMedicalRecords(
        loadDataExamEntity: loadDateFilter,
      );

  late TextEditingController _startDateTimeController;
  late TextEditingController _endDateTimeController;

  @override
  void initState() {
    super.initState();
    otherLab = PrimitiveWrapper<bool>();
    localLab = PrimitiveWrapper<bool>();
    shareExamState = ValueNotifier<bool>(false);

    enableCardFilters = PrimitiveWrapper<bool>();
    examCode = PrimitiveWrapper<String>();
    enableCardFilters.value = false;
    shareList = [];

    visibleLabelCount = false;
    _controllerVoice = TextEditingController();
    _scrollController = ScrollController();
    _bodyScrollController = ScrollController();
    _startDateTimeController = TextEditingController();
    _endDateTimeController = TextEditingController();
    _controllerSearch = TextEditingController();
    _speech = SpeechAdapter(controller: _controllerVoice);

    internalFilter = ExamFiltersEntity();
    externalFilter = FiltersExternalEntity();

    dateStart = DateTime.now().subtract(Duration(days: fiveYearsInDays));
    dateEnd = DateTime.now();

    _cubit = I.getDependency<ExamCubit>();

    loadDateFilter = LoadDateExamEntity(
      initialDate: dateStart,
      finalDate: dateEnd,
      numberOfRecords: 0,
    );

    _loadData();

    _controllerVoice.addListener(() async {
      _controllerSearch.text = _controllerVoice.text;
      _cubit.emitVoice();
    });
  }

  Future<void> loadExamFilter() async {
    DateTime dateFilterInitial = internalFilter.executionInitialDate ??
        externalFilter.executionInitialDate ??
        dateStart;

    DateTime dateFilterFinal = internalFilter.executionFinalDate ??
        externalFilter.executionFinalDate ??
        dateEnd;

    if (_controllerSearch.text.isNotEmpty && examCode.value == null) {
      internalFilter.examName = _controllerSearch.text.trim();
      externalFilter.examName = _controllerSearch.text.trim();
    } else {
      internalFilter.examName = null;
      externalFilter.examName = null;
    }

    localLab.value ??= false;
    otherLab.value ??= false;

    final loadData = LoadExamEntity(
      lab: ((localLab.value! && otherLab.value!) ||
              (!localLab.value! && !otherLab.value!))
          ? null
          : localLab.value!
              ? 'Albert Einstein'
              : 'Outros',
      passageId: null,
      initialDate: dateFilterInitial,
      finalDate: dateFilterFinal,
      auxPrint: false,
      chAuthentication: null,
      medicalAppointment: null,
      results: true,
      numberOfRecords: null,
      exams: examCode.value,
      idItens: null,
      filters: internalFilter,
      externalFilters: externalFilter,
    );

    positionScroll = null;
    selectedMonthCard = null;
    selectedYearCard = null;

    await _cubit.loadFilter(loadExamEntity: loadData);
  }

  Future<void> _showFilterExams({
    required FilterType filterType,
    required BuildContext context,
  }) async {
    final ValueNotifier<bool> enableButton = ValueNotifier<bool>(false);
    final StreamController<bool> clearFields = StreamController<bool>();
    final PrimitiveWrapper<int> selectedYear = PrimitiveWrapper<int>();
    final PrimitiveWrapper<DateTime> initSelectedDate =
        PrimitiveWrapper<DateTime>();
    final PrimitiveWrapper<DateTime> finalSelectedDate =
        PrimitiveWrapper<DateTime>();

    List<int> examType = [];
    List<String> unity = [];
    List<int> passage = [];
    List<int> statusResult = [];

    String title = <FilterType, String>{
      FilterType.category: 'Categoria',
      FilterType.date: 'Data de Realização',
      FilterType.passage: 'Passage',
      FilterType.released_results: 'Resultados liberados',
      FilterType.einstein_unity: 'Unidades Einstein',
      FilterType.imported: 'Exames importados',
      FilterType.all: 'Filtrar por',
    }[filterType]!;

    if (internalFilter.executionInitialDate != null) {
      initSelectedDate.value = internalFilter.executionInitialDate;
    }

    if (internalFilter.executionFinalDate != null) {
      finalSelectedDate.value = internalFilter.executionFinalDate;
    }

    if (internalFilter.examType != null) {
      examType.addAll([...internalFilter.examType!]);
    }

    if (externalFilter.examType != null) {
      examType.addAll([...externalFilter.examType!]);
    }

    if (internalFilter.unity != null) {
      unity.addAll([...internalFilter.unity!]);
    }

    if (internalFilter.passType != null) {
      passage.addAll([...internalFilter.passType!]);
    }

    if (internalFilter.statusResult != null) {
      statusResult.addAll([...internalFilter.statusResult!]);
    }

    selectedYear.value = selectedYearCard;

    examType = examType.toSet().toList();

    Future<void> setFilter() async {
      if (examType.isNotEmpty ||
          unity.isNotEmpty ||
          passage.isNotEmpty ||
          statusResult.isNotEmpty ||
          initSelectedDate.value != null ||
          selectedYear.value != null ||
          localLab.value != false ||
          otherLab.value != false) {
        await loadExamFilter();
      } else {
        loadDateFilter.initialDate = dateStart;
        loadDateFilter.finalDate = dateEnd;
        localLab.value = false;
        otherLab.value = false;

        internalFilter.passType?.clear();
        internalFilter.examType?.clear();
        internalFilter.unity?.clear();
        internalFilter.executionInitialDate = null;
        internalFilter.executionFinalDate = null;
        externalFilter.examType?.clear();
        externalFilter.executionInitialDate = null;
        externalFilter.executionFinalDate = null;

        positionScroll = null;
        selectedMonthCard = null;
        selectedYearCard = null;
        enableCardFilters.value = false;
        dateCardInit = null;
        dateCardFinal = null;

        await _cubit.loadExamDate(
          loadDataExamEntity: loadDateFilter,
        );
      }
    }

    Widget bodyFilter = <FilterType, Widget>{
      FilterType.all: ExamFilterAllTypesWidget(
        clearFields: clearFields,
        enableButton: enableButton,
        examType: examType,
        unity: unity,
        passage: passage,
        localLab: localLab,
        otherLab: otherLab,
        statusResult: statusResult,
        initSelectedDate: initSelectedDate,
        finalSelectedDate: finalSelectedDate,
        selectedYear: selectedYear,
      ),
      FilterType.category: FilterCategory(
        examType: examType,
        clearAllFields: clearFields,
        enableButton: enableButton,
      ),
      FilterType.einstein_unity: UnityEinsteinFilterExam(
        clearFields: clearFields,
        enableButton: enableButton,
        unity: unity,
      ),
      FilterType.passage: PassageTypeFilter(
        clearFields: clearFields,
        enableButton: enableButton,
        passage: passage,
      ),
      FilterType.imported: ImportedExamFilter(
        clearFields: clearFields,
        enableButton: enableButton,
        localLab: localLab,
        otherLab: otherLab,
      ),
      FilterType.released_results: ReleasedResultsFilterPage(
        clearFields: clearFields,
        enableButton: enableButton,
        statusResult: statusResult,
      ),
      FilterType.date: SelectDateFiltersPage(
        clearFields: clearFields,
        enableButton: enableButton,
        initSelectedDate: initSelectedDate,
        finalSelectedDate: finalSelectedDate,
        selectedYear: selectedYear,
      ),
    }[filterType]!;

    Future<void> applyFilter() async {
      internalFilter.examType?.clear();
      internalFilter.passType?.clear();
      internalFilter.unity?.clear();
      internalFilter.statusResult?.clear();
      externalFilter.examType?.clear();

      internalFilter.executionInitialDate = null;
      internalFilter.executionFinalDate = null;
      externalFilter.executionInitialDate = null;
      externalFilter.executionFinalDate = null;
      selectedYearCard = null;

      if (examType.isNotEmpty) {
        internalFilter.examType = [...examType];
        externalFilter.examType = [...examType];
      }

      if (unity.isNotEmpty) {
        internalFilter.unity = [...unity];
      }

      if (passage.isNotEmpty) {
        internalFilter.passType = [...passage];
      }

      if (statusResult.isNotEmpty) {
        internalFilter.statusResult = [...statusResult];
      }

      if (initSelectedDate.value != null && finalSelectedDate.value != null) {
        internalFilter.executionInitialDate = initSelectedDate.value;
        internalFilter.executionFinalDate = finalSelectedDate.value;
        externalFilter.executionInitialDate = initSelectedDate.value;
        externalFilter.executionFinalDate = finalSelectedDate.value;
        loadDateFilter.initialDate = initSelectedDate.value!;
        loadDateFilter.finalDate = finalSelectedDate.value!;
      } else {
        loadDateFilter.initialDate = dateStart;
        loadDateFilter.finalDate = dateEnd;
      }

      if (selectedYear.value != null) {
        selectedYearCard = selectedYear.value;
      }

      localLab.value ??= false;
      otherLab.value ??= false;

      if (localLab.value! && otherLab.value!) {
        localLab.value = false;
        otherLab.value = false;
      }

      await setFilter();
    }

    Future<void> clearFilters() async {
      enableCardFilters.value = examType.isNotEmpty ||
          unity.isNotEmpty ||
          passage.isNotEmpty ||
          statusResult.isNotEmpty ||
          initSelectedDate.value != null ||
          selectedYear.value != null;

      if (FilterType.all == filterType) {
        internalFilter.examType?.clear();
        externalFilter.examType?.clear();
        examType.clear();
        internalFilter.unity?.clear();
        unity.clear();
        internalFilter.passType?.clear();
        passage.clear();
        localLab.value = false;
        otherLab.value = false;
        internalFilter.statusResult?.clear();
        statusResult.clear();

        selectedYear.value = null;
        initSelectedDate.value = null;
        finalSelectedDate.value = null;

        selectedYearCard = null;

        internalFilter.executionInitialDate = null;
        internalFilter.executionFinalDate = null;
        externalFilter.executionInitialDate = null;
        externalFilter.executionFinalDate = null;
        loadDateFilter.initialDate = dateStart;
        loadDateFilter.finalDate = dateEnd;

        positionScroll = null;
        selectedMonthCard = null;
        enableCardFilters.value = false;
        dateCardInit = null;
        dateCardFinal = null;

        await _cubit.loadExamDate(
          loadDataExamEntity: loadDateFilter,
        );
      } else if (FilterType.category == filterType) {
        internalFilter.examType?.clear();
        externalFilter.examType?.clear();
        examType.clear();

        await setFilter();
      } else if (FilterType.einstein_unity == filterType) {
        internalFilter.unity?.clear();
        unity.clear();

        await setFilter();
      } else if (FilterType.passage == filterType) {
        internalFilter.passType?.clear();
        passage.clear();

        await setFilter();
      } else if (FilterType.imported == filterType) {
        localLab.value = false;
        otherLab.value = false;
        await setFilter();
      } else if (FilterType.released_results == filterType) {
        internalFilter.statusResult?.clear();
        statusResult.clear();

        await setFilter();
      } else if (FilterType.date == filterType) {
        selectedYear.value = null;
        initSelectedDate.value = null;
        finalSelectedDate.value = null;

        selectedYearCard = null;

        internalFilter.executionInitialDate = null;
        internalFilter.executionFinalDate = null;
        externalFilter.executionInitialDate = null;
        externalFilter.executionFinalDate = null;
        loadDateFilter.initialDate = dateStart;
        loadDateFilter.finalDate = dateEnd;

        positionScroll = null;
        selectedMonthCard = null;
        enableCardFilters.value = false;
        dateCardInit = null;
        dateCardFinal = null;

        await _cubit.loadExamDate(
          loadDataExamEntity: loadDateFilter,
        );
      }
    }

    if (context.isDevice()) {
      await showModalBottomSheet<void>(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        builder: (BuildContext context) => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              HeaderFilterExam(
                title: title,
              ),
              bodyFilter,
              const SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: ValueListenableBuilder<bool>(
                  valueListenable: enableButton,
                  builder: (BuildContext context, bool value, _) => Padding(
                    padding:
                        const EdgeInsets.only(top: 24, left: 24, right: 24),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: ZeraButton(
                        enabled: value,
                        text: APPLY.translate(),
                        onPressed: () async {
                          Navigator.of(context).pop();
                          await applyFilter();
                        },
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: ClearFieldsFilterLabel(
                  action: () async {
                    await clearFilters();
                  },
                  clearFiled: clearFields,
                  enableButton: enableButton,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      );
    } else {
      await showDialog<void>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: SizedBox(
            width: 500,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: context.isDevice()
                        ? MainAxisAlignment.center
                        : MainAxisAlignment.spaceBetween,
                    children: [
                      HeaderFilterExam(
                        title: title,
                      ),
                      Visibility(
                        visible: !context.isDevice(),
                        child: IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(
                            Icons.close,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Visibility(
                    child: ZeraDivider(),
                    visible: !context.isDevice(),
                  ),
                  bodyFilter,
                  const SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ValueListenableBuilder<bool>(
                      valueListenable: enableButton,
                      builder: (BuildContext context, bool value, _) => Padding(
                        padding: const EdgeInsets.only(
                          top: 24,
                          left: 24,
                          right: 24,
                        ),
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: ZeraButton(
                            enabled: value,
                            text: APPLY.translate(),
                            onPressed: () async {
                              Navigator.of(context).pop();
                              await applyFilter();
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ClearFieldsFilterLabel(
                      action: () async {
                        await clearFilters();
                      },
                      clearFiled: clearFields,
                      enableButton: enableButton,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    setState(() {});
  }

  Future<void> _importExams() async {
    if (shareExamState.value) {
      if (shareList.isNotEmpty) {
        showLoadingDialog(
          context: context,
          action: () async {
            final result = await _cubit.downloadsExamsPdf(
              PdfResultParam(
                medicalAppointment: getUserIdentifier(),
                examCode: null,
                passage: null,
                executionDateBegin: dateStart,
                executionDateEnd: dateEnd,
                itensIdList: shareList,
                userType: 0,
                examBreak: true,
              ),
            );

            if (result != null) {
              final file = await result.pdfResult.base64ToFile(
                fileName: 'exames.pdf',
                openFileAfterConvert: false,
              );

              if (file != null && await file.exists()) {
                final IShareAdapter share = ShareAdapter();
                await share.shareFiles([file.path], 'exame');
              }
            }
          },
        );
      }
    } else {
      if (await getTermsCheckedFromLocalStorage()) {
        FileEntity? fileResult;

        if (kIsWeb) {
          try {
            fileResult = await LibraryDocumentUtil().getFile();
          } on FileSizeException catch (err) {
            return erroUploadBottomSheet(
              context,
              err.error,
            );
          } on FileExtensionException catch (err) {
            return erroUploadBottomSheet(
              context,
              err.error,
            );
          }
        } else {
          await getMobileBottomPicker(
            pdfFun: () async {
              fileResult = await LibraryDocumentUtil().getFile();
            },
            cameraFun: () async {
              fileResult = await CameraUtil().getFile();
            },
          );
        }

        if (fileResult != null) {
          ExternalExamEntity? externalExam =
              await Navigator.of(context).pushNamed(
            Routes.uploadStepsPage,
            arguments: fileResult,
          ) as ExternalExamEntity?;
          if (externalExam != null) {
            loadDateFilter.initialDate = dateStart;
            loadDateFilter.finalDate = dateEnd;

            await _clearFilters(
              resetGroupDates: true,
            );

            _cubit.msgNewExternalExam(
              ExamEntity(
                fileId: externalExam.fileId,
                path: externalExam.path,
                examType: externalExam.examType,
                executionDate: externalExam.executionDate,
                executionDate2: externalExam.executionDate,
                uploadDate: externalExam.uploadDate,
                labName: externalExam.labName,
                examId: externalExam.id,
                examName: externalExam.examName,
                laudoFile: externalExam.path,
                url1: externalExam.url,
                idMedicalRecords: externalExam.medicalRecords,
                position: 0,
                passType: null,
                statusResult: 0,
                available: true,
                security: true,
                laudo: false,
                passageId: null,
                examCode: null,
                labCode: null,
                doctorName: null,
                doctorIdentity: null,
                place: null,
                url2: null,
                accessNumber: null,
                result: null,
                linesQuantity: null,
                itemCategory: null,
              ),
            );
          }
        }
      } else {
        ExternalExamEntity? externalExam = await Navigator.of(context)
            .pushNamed(Routes.uploadExamsPage) as ExternalExamEntity?;

        if (externalExam != null) {
          loadDateFilter.initialDate = dateStart;
          loadDateFilter.finalDate = dateEnd;

          await _clearFilters(resetGroupDates: true);

          _cubit.msgNewExternalExam(
            ExamEntity(
              fileId: externalExam.fileId,
              path: externalExam.path,
              examType: externalExam.examType,
              executionDate: externalExam.executionDate,
              executionDate2: externalExam.executionDate,
              uploadDate: externalExam.uploadDate,
              labName: externalExam.labName,
              examId: externalExam.id,
              examName: externalExam.examName,
              laudoFile: externalExam.path,
              url1: externalExam.url,
              idMedicalRecords: externalExam.medicalRecords,
              position: 0,
              passType: null,
              statusResult: 0,
              available: true,
              security: true,
              laudo: false,
              passageId: null,
              examCode: null,
              labCode: null,
              doctorName: null,
              doctorIdentity: null,
              place: null,
              url2: null,
              accessNumber: null,
              result: null,
              linesQuantity: null,
              itemCategory: null,
            ),
          );
        }
      }
    }
  }

  Future<void> _clearFilters({bool resetGroupDates = false}) async {
    _controllerSearch.clear();
    _controllerVoice.clear();
    loadDateFilter.initialDate = dateStart;
    loadDateFilter.finalDate = dateEnd;

    internalFilter.examName = null;
    internalFilter.passType?.clear();
    internalFilter.examType?.clear();
    internalFilter.unity?.clear();
    internalFilter.executionInitialDate = null;
    internalFilter.executionFinalDate = null;

    externalFilter.examName = null;
    externalFilter.examType?.clear();
    externalFilter.executionInitialDate = null;
    externalFilter.executionFinalDate = null;

    examCode.value = null;

    positionScroll = null;
    selectedMonthCard = null;
    selectedYearCard = null;
    enableCardFilters.value = false;
    dateCardInit = null;
    dateCardFinal = null;

    await _cubit.loadExamDate(
      loadDataExamEntity: loadDateFilter,
      clearList: resetGroupDates,
    );
  }

  @override
  void dispose() {
    _cubit.close();
    _scrollController.dispose();
    _bodyScrollController.dispose();
    _controllerSearch.dispose();
    _startDateTimeController.dispose();
    _endDateTimeController.dispose();
    super.dispose();
  }

  Future<void> loadFilter(GlobalFilterEntity result) async {
    internalFilter = result.examFiltersEntity ?? ExamFiltersEntity();

    externalFilter = result.filtersExternalEntity ?? FiltersExternalEntity();

    DateTime dateFilterInitial = internalFilter.executionInitialDate ??
        externalFilter.executionInitialDate ??
        dateStart;

    DateTime dateFilterFinal = internalFilter.executionFinalDate ??
        externalFilter.executionFinalDate ??
        dateEnd;

    if (_controllerSearch.text.isNotEmpty && examCode.value == null) {
      internalFilter.examName = _controllerSearch.text.trim();
      externalFilter.examName = _controllerSearch.text.trim();
    } else {
      internalFilter.examName = null;
      externalFilter.examName = null;
    }

    localLab.value = result.localLab;
    otherLab.value = result.otherLab;

    final loadData = LoadExamEntity(
      lab: ((localLab.value! && otherLab.value!) ||
              (!localLab.value! && !otherLab.value!))
          ? null
          : localLab.value!
              ? 'Albert Einstein'
              : 'Outros',
      passageId: null,
      initialDate: dateFilterInitial,
      finalDate: dateFilterFinal,
      auxPrint: false,
      chAuthentication: null,
      medicalAppointment: null,
      results: true,
      numberOfRecords: null,
      exams: examCode.value,
      idItens: null,
      filters: internalFilter,
      externalFilters: externalFilter,
    );

    positionScroll = null;
    selectedMonthCard = null;
    selectedYearCard = null;
    enableCardFilters.value = true;

    await _cubit.loadFilter(loadExamEntity: loadData);
  }

  Future<void> clearDataCard() async {
    positionScroll = null;
    selectedMonthCard = null;
    selectedYearCard = null;
    enableCardFilters.value = false;
    dateCardInit = null;
    dateCardFinal = null;

    loadDateFilter.initialDate = dateStart;
    loadDateFilter.finalDate = dateEnd;

    if (_controllerSearch.text.isNotEmpty) {
      final loadData = LoadExamEntity(
        lab: null,
        passageId: null,
        initialDate: dateStart,
        finalDate: dateEnd,
        auxPrint: false,
        chAuthentication: null,
        medicalAppointment: null,
        results: true,
        numberOfRecords: null,
        exams: null,
        idItens: null,
        filters: internalFilter,
        externalFilters: FiltersExternalEntity(
          examName: null,
          examType: null,
          executionFinalDate: null,
          executionInitialDate: null,
        ),
      );

      await _cubit.loadFilter(
        loadExamEntity: loadData,
      );
    } else {
      await _cubit.loadExamDate(
        loadDataExamEntity: loadDateFilter,
      );
    }
  }

  Future<void> _refreshData() async {
    _controllerSearch.clear();
    _controllerVoice.clear();
    loadDateFilter.initialDate = dateStart;
    loadDateFilter.finalDate = dateEnd;

    internalFilter.examName = null;
    internalFilter.passType?.clear();
    internalFilter.examType?.clear();
    internalFilter.unity?.clear();
    internalFilter.executionInitialDate = null;
    internalFilter.executionFinalDate = null;

    externalFilter.examName = null;
    externalFilter.examType?.clear();
    externalFilter.executionInitialDate = null;
    externalFilter.executionFinalDate = null;

    examCode.value = null;

    positionScroll = null;
    selectedMonthCard = null;
    selectedYearCard = null;
    enableCardFilters.value = false;
    dateCardInit = null;
    dateCardFinal = null;

    await _cubit.loadExamDateAndMedicalRecords(
      loadDataExamEntity: loadDateFilter,
    );
  }

  Future<void> loadDataCard(DateTime dateInit, DateTime dateFim) async {
    enableCardFilters.value = false;
    dateCardInit = dateInit;
    dateCardFinal = dateFim;
    selectedMonthCard = dateCardInit!.month;
    selectedYearCard = dateCardInit!.year;
    positionScroll = _scrollController.offset;

    if (positionScroll == _scrollController.position.maxScrollExtent) {
      positionScroll = _scrollController.offset + 50;
    }
    loadDateFilter.initialDate = dateInit;
    loadDateFilter.finalDate = dateFim;

    if (_controllerSearch.text.isEmpty && internalFilter.examName != null) {
      internalFilter.examName = null;
    }

    if (_controllerSearch.text.isEmpty && externalFilter.examName != null) {
      externalFilter.examName = null;
    }

    final loadData = LoadExamEntity(
      lab: null,
      passageId: null,
      initialDate: dateInit,
      finalDate: dateFim,
      auxPrint: false,
      chAuthentication: null,
      medicalAppointment: null,
      results: true,
      numberOfRecords: null,
      exams: null,
      idItens: null,
      filters: internalFilter,
      externalFilters: externalFilter,
    );

    await _cubit.loadFilter(
      loadExamEntity: loadData,
    );
  }

  Future<void> showAlertDialog({
    required BuildContext context,
    required String msg,
  }) async =>
      await showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text(WARNING.translate()),
          content: Text(msg),
          actions: <Widget>[
            ZeraButton(
              text: CLOSE.translate(),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
  final double defaultLeftPaddingPage = DEFAULT_LEFT_PADDING + 4;

  void _openEndDrawer(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }

  Future<dynamic> _showFilter(BuildContext context) async {
    if (!context.isMobile()) {
      _openEndDrawer(context);
    } else {
      final result = await Navigator.of(context).pushNamed(
        Routes.filterExamPage,
      );
      if (result != null && result is GlobalFilterEntity) {
        await loadFilter(result);
      }
    }
  }

  double getFloatPadding(BuildContext context) {
    double value = ((MediaQuery.of(context).size.width - 1200) / 2) - 6;

    return value < 0 ? 0.0 : value;
  }

  Future<void> backNavigator(BuildContext context) async {
    if (kIsWeb) {
      Navigator.of(context, rootNavigator: true).pop();
    } else {
      final rootNavigator = await getDataLoginParams();

      if (rootNavigator['rootNavigator'] == 'S') {
        await SystemChannels.platform.invokeMethod<void>(
          'SystemNavigator.pop',
          true,
        );
      } else {
        Navigator.of(context, rootNavigator: true).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () async {
          await backNavigator(context);

          return false;
        },
        child: ZeraScaffold(
          endDrawerEnableOpenDragGesture: false,
          endDrawer: SafeArea(
            child: Container(
              constraints: const BoxConstraints(
                maxWidth: 572,
              ),
              width: double.infinity,
              child: Drawer(
                child: FilterBodyWidget(
                  filter: internalFilter,
                  filterChanged: (newFilter) {
                    internalFilter = newFilter ?? ExamFiltersEntity();
                  },
                  finalDateController: _endDateTimeController,
                  initialDateController: _startDateTimeController,
                  resultFilter: (result) async {
                    Navigator.of(context).pop();
                    await loadFilter(result);
                  },
                ),
              ),
            ),
          ),
          floatingActionButtonLocation: shareExamState.value
              ? FloatingActionButtonLocation.centerDocked
              : null,
          floatingActionButton: ValueListenableBuilder<bool>(
            valueListenable: shareExamState,
            builder: (context, value, _) => value
                ? FloatMenuBUtton(
                    printOut: () async {
                      if (shareList.isNotEmpty) {
                        await showLoadingDialog(
                          context: context,
                          action: () async {
                            final result = await _cubit.downloadsExamsPdf(
                              PdfResultParam(
                                medicalAppointment: getUserIdentifier(),
                                examCode: null,
                                passage: null,
                                executionDateBegin: dateStart,
                                executionDateEnd: dateEnd,
                                itensIdList: shareList,
                                userType: 0,
                                examBreak: true,
                              ),
                            );

                            if (result != null) {
                              PrintingAdapter printing = PrintingAdapter();
                              await printing.showLayoutPDF(
                                file: base64.decode(result.pdfResult),
                              );
                            }
                          },
                        );
                      }
                    },
                    download: () async {
                      if (shareList.isNotEmpty) {
                        showLoadingDialog(
                          context: context,
                          action: () async {
                            final result = await _cubit.downloadsExamsPdf(
                              PdfResultParam(
                                medicalAppointment: getUserIdentifier(),
                                examCode: null,
                                passage: null,
                                executionDateBegin: dateStart,
                                executionDateEnd: dateEnd,
                                itensIdList: shareList,
                                userType: 0,
                                examBreak: true,
                              ),
                            );

                            if (result != null) {
                              final file = await result.pdfResult.base64ToFile(
                                fileName: 'exames.pdf',
                                openFileAfterConvert: true,
                              );
                            }
                          },
                        );
                      }
                    },
                    share: () async {
                      if (shareList.isNotEmpty) {
                        showLoadingDialog(
                          context: context,
                          action: () async {
                            final result = await _cubit.downloadsExamsPdf(
                              PdfResultParam(
                                medicalAppointment: getUserIdentifier(),
                                examCode: null,
                                passage: null,
                                executionDateBegin: dateStart,
                                executionDateEnd: dateEnd,
                                itensIdList: shareList,
                                userType: 0,
                                examBreak: true,
                              ),
                            );

                            if (result != null) {
                              final file = await result.pdfResult.base64ToFile(
                                fileName: 'exames.pdf',
                                openFileAfterConvert: false,
                              );

                              if (file != null && await file.exists()) {
                                final IShareAdapter share = ShareAdapter();
                                await share.shareFiles([file.path], 'exame');
                              }
                            }
                          },
                        );
                      }
                    },
                  )
                : SizedBox(
                    height: 64,
                    width: 64,
                    child: FloatingActionButton(
                      heroTag: 'whatsapp',
                      onPressed: () async {
                        await openUrl(WHATSAPP_PATIENT);
                      },
                      foregroundColor: Colors.white,
                      backgroundColor: ZeraColors.secondaryDark,
                      child: Image.asset(
                        WHATSAPP,
                        package: MICRO_APP_PACKAGE_NAME,
                      ),
                      elevation: 12,
                    ),
                  ),
            // : Column(
          ),
          body: SafeArea(
            child: CustomScrollView(
              controller: _bodyScrollController,
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1200),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Visibility(
                                visible: kIsWeb,
                                child: Container(
                                  padding: const EdgeInsets.only(
                                    left: 16,
                                    top: 16,
                                  ),
                                  child: BreadCrumbs(
                                    listBreadCrumbs: [
                                      EXAM_RESULTS.translate(),
                                      EXAMS_EINSTEIN.translate(),
                                    ],
                                  ),
                                ),
                              ),
                              ValueListenableBuilder<bool>(
                                valueListenable: shareExamState,
                                builder: (context, shareValue, _) => Column(
                                  children: [
                                    SizedBox(
                                      height: kNavBarHeight,
                                      child: DefaultAppBar(
                                        leading: shareValue
                                            ? null
                                            : ZeraIconButton(
                                                onPressed: () async {
                                                  backNavigator(context);
                                                },
                                                icon: ZeraIcons.arrow_left_1,
                                                style: ZeraIconButtonStyle
                                                    .ICON_CLOSE,
                                              ),
                                        actionButton: shareValue
                                            ? () {
                                                shareList.clear();
                                                shareExamState.value = false;
                                                setState(() {});
                                              }
                                            : null,
                                        iconAppBar: shareValue
                                            ? ZeraIcons.close
                                            : ZeraIcons.arrow_left_1,
                                        rootNavigator: true,
                                        leftPaddingHeader:
                                            context.isDevice() ? 5.0 : 0.0,
                                      ),
                                    ),
                                    Visibility(
                                      visible: shareValue,
                                      child: BlocBuilder<ExamCubit, ExamState>(
                                        bloc: _cubit,
                                        buildWhen: (context, state) =>
                                            state is IncSelectedExamState,
                                        builder: (context, state) =>
                                            DefaultHeaderTitle(
                                          leftPaddingHeader:
                                              context.isDevice() ? 5.0 : 0.0,
                                          title: state
                                                      is IncSelectedExamState &&
                                                  shareList.isNotEmpty
                                              ? '${shareList.length} ${SELECTED_EXAMS.translate()}'
                                              : EXAMS_SHARE.translate(),
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: !shareValue,
                                      child: DefaultHeaderTitle(
                                        leftPaddingHeader:
                                            context.isDevice() ? 5.0 : 0.0,
                                        title: !shareValue
                                            ? RESULTS_OF_EXAMS.translate()
                                            : EXAMS_SHARE.translate(),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 16,
                                        bottom: 64,
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          ButtonShortCut(
                                            title: EVOLUTIONARY_REPORT4
                                                .translate(),
                                            action: () {
                                              final ExamCubit cubit =
                                                  I.getDependency<ExamCubit>();

                                              final bool
                                                  firstOpenEvolutionaryReport =
                                                  cubit
                                                      .getFirstEvolutionaryRepository();

                                              if (!firstOpenEvolutionaryReport) {
                                                Navigator.of(context).pushNamed(
                                                  Routes.evolutionaryReportHome,
                                                );
                                              } else {
                                                Navigator.of(context).pushNamed(
                                                  Routes
                                                      .evolutionaryReportGroupsExams,
                                                );
                                              }
                                            },
                                            icon: Image.asset(
                                              EVOLUTIONARY_REPORT_SHORTCUT_IMG,
                                              color: ZeraColors.primaryMedium,
                                              package: MICRO_APP_PACKAGE_NAME,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          ButtonShortCut(
                                            title: IMPORT_EXAMS.translate(),
                                            action: _importExams,
                                            icon: Image.asset(
                                              EXAM_IMPORT_IMG,
                                              color: ZeraColors.primaryMedium,
                                              package: MICRO_APP_PACKAGE_NAME,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          ButtonShortCut(
                                            title: HELP.translate(),
                                            action: () {},
                                            icon: Image.asset(
                                              HELP_IMG,
                                              package: MICRO_APP_PACKAGE_NAME,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                BlocConsumer<ExamCubit, ExamState>(
                  bloc: _cubit,
                  buildWhen: (context, state) =>
                      state is ExamLoadState ||
                      state is ExamDateLoadSuccessState ||
                      state is ExamLoadFilter ||
                      state is ExamFailureState ||
                      state is ExamFilterEmptyState ||
                      state is ExamEmptyState,
                  listenWhen: (context, state) =>
                      state is ExamFailureState ||
                      state is ExamFilterEmptyState ||
                      state is ExamLoadFilter ||
                      state is ExamDateLoadSuccessState ||
                      state is ExamEmptyState ||
                      state is ExamSuccessNewExamState,
                  listener: (context, state) async {
                    if (state is ExamSuccessNewExamState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: const Duration(seconds: 15),
                          padding: const EdgeInsets.only(
                            left: 20,
                            right: 20,
                            bottom: 10.0,
                          ),
                          behavior: SnackBarBehavior.fixed,
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          content: Container(
                            padding: const EdgeInsets.only(left: 16),
                            color: const Color(0xFFe7f5ee),
                            height: 73,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ZeraText(
                                      EXAM_IMPORTED_SUCCESSFULLY,
                                      color: const Color(0xFF0e6038),
                                      theme: const ZeraTextTheme(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    IconButton(
                                      splashRadius: 20,
                                      padding: EdgeInsets.zero,
                                      onPressed: () {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).hideCurrentSnackBar();
                                      },
                                      icon: const Icon(
                                        Icons.close,
                                        color: Color(0xFF0e6038),
                                      ),
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                      Routes.examResultPage,
                                      arguments: state.examEntity,
                                    );
                                  },
                                  child: MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: ZeraText(
                                      SEE_EXAM.translate(),
                                      color: const Color(0xFF0e6038),
                                      theme: const ZeraTextTheme(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w600,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    } else if (state is ExamFailureState &&
                        state.failure is NoInternetConnectionFailure) {
                      final refresh = await Navigator.of(context).pushNamed(
                        Routes.failedConnectionPage,
                        arguments: MY_EXAMS.translate(),
                      ) as bool?;

                      if (refresh == true) {
                        _refreshData();
                      } else {
                        Navigator.of(context).pop();
                      }
                    } else if (state is ExamFailureState) {
                      await Navigator.of(context).popAndPushNamed(
                        Routes.errorPage,
                        arguments: MY_EXAMS.translate(),
                      );
                    } else if (state is ExamFilterEmptyState ||
                        state is ExamEmptyState) {
                      emptyExams = true;
                      setState(() {});
                    } else if (emptyExams == true) {
                      setState(() {
                        emptyExams = false;
                      });
                    }
                  },
                  builder: (context, state) {
                    if (state is ExamLoadState) {
                      return const SliverFillRemaining(
                        child: Center(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      );
                    } else if (state is ExamEmptyState) {
                      return SliverFillRemaining(
                        fillOverscroll: false,
                        hasScrollBody: false,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Center(
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxWidth: 1200,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    left: 20,
                                    right: 20,
                                    top: context.isDevice() ? 50 : 100,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      FittedBox(
                                        fit: BoxFit.contain,
                                        child: Image.asset(
                                          UNDRAW_MEDICINE,
                                          package: MICRO_APP_PACKAGE_NAME,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 44,
                                      ),
                                      SizedBox(
                                        child: ZeraText(
                                          NO_EXAM_FOR_VIEW.translate(),
                                          color: ZeraColors.neutralDark01,
                                          theme: const ZeraTextTheme(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.bottomCenter,
                              height: kIsWeb
                                  ? MediaQuery.of(context).size.height / 2.7
                                  : MediaQuery.of(context).size.height / 3.1,
                              child: ButtonClearListExam(
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else if (state is ExamFilterEmptyState) {
                      return SliverFillRemaining(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              BlocBuilder<ExamCubit, ExamState>(
                                bloc: _cubit,
                                buildWhen: (context, state) =>
                                    state is EmitVoiceState,
                                builder: (context, state) => ListSearchExam(
                                  externalFilter: externalFilter,
                                  examCode: examCode,
                                  clearField: _clearFilters,
                                  actionVoice: () async {
                                    if (!_speech.isActive()) {
                                      await _speech.initSpeechState();
                                    }

                                    await _speech.startListening();
                                  },
                                  enabledCard: selectedYearCard != null,
                                  cubit: _cubit,
                                  filter: internalFilter,
                                  loadDateFilter: loadDateFilter,
                                  controller: _controllerSearch,
                                  /*onTap: () {
                                    _showFilter(context);
                                  },*/
                                ),
                              ),
                              const SizedBox(
                                height: 81,
                              ),
                              Center(
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    maxWidth: 1200,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 20,
                                      right: 20,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image.asset(
                                          EMPTY_PAGE,
                                          fit: BoxFit.contain,
                                          package: MICRO_APP_PACKAGE_NAME,
                                        ),
                                        const SizedBox(
                                          height: 40,
                                        ),
                                        SizedBox(
                                          child: ZeraText(
                                            EMPTY_PAGE_MSG.translate(),
                                            color: ZeraColors.neutralDark01,
                                            theme: const ZeraTextTheme(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        SizedBox(
                                          width: 340,
                                          child: ZeraText(
                                            RETRY_AGAIN_SEARCH.translate(),
                                            color: ZeraColors.neutralDark01,
                                            theme: const ZeraTextTheme(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.bottomCenter,
                                height: kIsWeb
                                    ? MediaQuery.of(context).size.height / 3
                                    : MediaQuery.of(context).size.height / 4,
                                child: ButtonClearListExam(
                                  onPressed: _clearFilters,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else if (state is ExamLoadFilter) {
                      int? year;
                      bool visibleCard = false;
                      bool enableBorder = false;
                      return SliverList(
                        delegate: SliverChildListDelegate([
                          BlocBuilder<ExamCubit, ExamState>(
                            bloc: _cubit,
                            buildWhen: (context, state) =>
                                state is EmitVoiceState,
                            builder: (context, state) => ListSearchExam(
                              externalFilter: externalFilter,
                              examCode: examCode,
                              clearField: () async {
                                examCode.value = null;
                                internalFilter.examName = null;
                                externalFilter.examName = null;

                                if (dateCardInit != null &&
                                    dateCardFinal != null) {
                                  await loadDataCard(
                                    dateCardInit!,
                                    dateCardFinal!,
                                  );
                                } else {
                                  await _cubit.loadExamDate(
                                    loadDataExamEntity: loadDateFilter,
                                  );
                                }
                              },
                              actionVoice: () async {
                                if (!_speech.isActive()) {
                                  await _speech.initSpeechState();
                                }

                                await _speech.startListening();
                              },
                              enabledCard: selectedYearCard != null,
                              cubit: _cubit,
                              filter: internalFilter,
                              loadDateFilter: loadDateFilter,
                              controller: _controllerSearch,
                              onTap: () {
                                _showFilter(context);
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(
                                maxWidth: 1200,
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: context.isDevice() ? 16 : 0,
                                ),
                                child: Row(
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        await _showFilterExams(
                                          context: context,
                                          filterType: FilterType.all,
                                        );
                                      },
                                      child: SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: FittedBox(
                                          fit: BoxFit.contain,
                                          child: Image.asset(
                                            SLIDE_MENU_IMG,
                                            fit: BoxFit.contain,
                                            package: MICRO_APP_PACKAGE_NAME,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5.0,
                                    ),
                                    Expanded(
                                      child: SizedBox(
                                        height: 80,
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          padding: EdgeInsets.only(
                                            left: context.isDevice() ? 16 : 0,
                                            right: context.isDevice() ? 16 : 0,
                                          ),
                                          child: Row(
                                            children: [
                                              ButtonFilter(
                                                title: SELECT_COMPLETION_DATE
                                                    .translate(),
                                                selectedCard: internalFilter
                                                            .executionInitialDate !=
                                                        null &&
                                                    internalFilter
                                                            .executionFinalDate !=
                                                        null,
                                                action: () async {
                                                  await _showFilterExams(
                                                    context: context,
                                                    filterType: FilterType.date,
                                                  );
                                                },
                                              ),
                                              const SizedBox(
                                                width: 8.0,
                                              ),
                                              ButtonFilter(
                                                title: CATEGORY.translate(),
                                                action: () async {
                                                  await _showFilterExams(
                                                    context: context,
                                                    filterType:
                                                        FilterType.category,
                                                  );
                                                },
                                                selectedCard:
                                                    internalFilter.examType !=
                                                            null &&
                                                        internalFilter.examType!
                                                            .isNotEmpty,
                                              ),
                                              const SizedBox(
                                                width: 8.0,
                                              ),
                                              ButtonFilter(
                                                title: RESULTS_RELEASED
                                                    .translate(),
                                                action: () async {
                                                  await _showFilterExams(
                                                    context: context,
                                                    filterType: FilterType
                                                        .released_results,
                                                  );
                                                },
                                                selectedCard: internalFilter
                                                            .statusResult !=
                                                        null &&
                                                    internalFilter.statusResult!
                                                        .isNotEmpty,
                                              ),
                                              const SizedBox(
                                                width: 8.0,
                                              ),
                                              ButtonFilter(
                                                title:
                                                    IMPORTED_EXAMS.translate(),
                                                action: () async {
                                                  await _showFilterExams(
                                                    context: context,
                                                    filterType:
                                                        FilterType.imported,
                                                  );
                                                },
                                                selectedCard: (localLab.value ??
                                                        false) ||
                                                    (otherLab.value ?? false),
                                              ),
                                              const SizedBox(
                                                width: 8.0,
                                              ),
                                              ButtonFilter(
                                                title: EINSTEIN_UNIT,
                                                action: () async {
                                                  await _showFilterExams(
                                                    context: context,
                                                    filterType: FilterType
                                                        .einstein_unity,
                                                  );
                                                },
                                                selectedCard:
                                                    internalFilter.unity !=
                                                            null &&
                                                        internalFilter
                                                            .unity!.isNotEmpty,
                                              ),
                                              const SizedBox(
                                                width: 8.0,
                                              ),
                                              ButtonFilter(
                                                title: PASSAGE.translate(),
                                                action: () async {
                                                  await _showFilterExams(
                                                    context: context,
                                                    filterType:
                                                        FilterType.passage,
                                                  );
                                                },
                                                selectedCard:
                                                    internalFilter.passType !=
                                                            null &&
                                                        internalFilter.passType!
                                                            .isNotEmpty,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: enableCardFilters.value!,
                            child: LabelAccountExams(
                              action: () async {
                                loadDateFilter.initialDate = dateStart;
                                loadDateFilter.finalDate = dateEnd;

                                internalFilter.examName = null;
                                internalFilter.passType?.clear();
                                internalFilter.examType?.clear();
                                internalFilter.unity?.clear();
                                internalFilter.executionInitialDate = null;
                                internalFilter.executionFinalDate = null;

                                externalFilter.examName = null;
                                externalFilter.examType?.clear();
                                externalFilter.executionInitialDate = null;
                                externalFilter.executionFinalDate = null;

                                examCode.value = null;

                                positionScroll = null;
                                selectedMonthCard = null;
                                selectedYearCard = null;
                                enableCardFilters.value = false;
                                dateCardInit = null;
                                dateCardFinal = null;

                                await _cubit.loadExamDate(
                                  loadDataExamEntity: loadDateFilter,
                                );
                              },
                              monthLabel: selectedYearCard != null
                                  ? selectedMonthCard?.getMonth()
                                  : null,
                              yearLabel: selectedYearCard?.toString(),
                              filterCardMonth: selectedYearCard != null,
                              dateCount: state.data.entries.length,
                              countLabel: state.examsAccount,
                            ),
                          ),
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: state.data.length,
                            itemBuilder: (
                              BuildContext context,
                              int index,
                            ) {
                              if (year == null) {
                                year = state.data.keys.elementAt(index).year;

                                visibleCard = true;
                              } else {
                                enableBorder = true;
                                visibleCard = year !=
                                    state.data.keys.elementAt(index).year;

                                year = state.data.keys.elementAt(index).year;
                              }

                              return Center(
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    maxWidth: 1200,
                                  ),
                                  child: Column(
                                    children: [
                                      Visibility(
                                        visible: visibleCard,
                                        child: HeaderGroupYear(
                                          enableBorder: enableBorder,
                                          year: year,
                                        ),
                                      ),
                                      const Divider(),
                                      HeaderExpansionTile(
                                        fontSize: 16.0,
                                        showIconTrailing: true,
                                        initiallyExpanded: index == 0,
                                        title: state.data.keys
                                            .elementAt(index)
                                            .dateInFull(),
                                        body: [
                                          Container(
                                            constraints: const BoxConstraints(
                                              maxWidth: 1200,
                                            ),
                                            width: double.infinity,
                                            child: ValueListenableBuilder<bool>(
                                              valueListenable: shareExamState,
                                              builder:
                                                  (context, shareValue, _) =>
                                                      LoadExamsDetails(
                                                multipleShareExams: () {
                                                  if (!shareExamState.value) {
                                                    shareExamState.value = true;
                                                    setState(() {});
                                                  }
                                                  shareList.clear();
                                                },
                                                refreshAfterDelete: () {
                                                  state.data.removeWhere(
                                                    (key, value) =>
                                                        key ==
                                                        state.data.keys
                                                            .elementAt(index),
                                                  );
                                                  setState(() {});
                                                },
                                                removeExternalExam:
                                                    _cubit.removeExternalExams,
                                                downloadExternalPDF:
                                                    _cubit.getExternalExam,
                                                updateCount:
                                                    _cubit.incSelectedExams,
                                                shareList: shareList,
                                                downloadPDF:
                                                    _cubit.loadPdfResult,
                                                listExam: state.data[state
                                                    .data.keys
                                                    .elementAt(index)],
                                                enableCheckBox: shareValue,
                                                execute:
                                                    _cubit.loadExamsDetails,
                                                loadExamEntity: LoadExamEntity(
                                                  lab: null,
                                                  passageId: null,
                                                  initialDate: state.data.keys
                                                      .elementAt(index),
                                                  finalDate: state.data.keys
                                                      .elementAt(index),
                                                  auxPrint: false,
                                                  chAuthentication: null,
                                                  medicalAppointment: null,
                                                  results: true,
                                                  numberOfRecords: null,
                                                  exams: null,
                                                  idItens: null,
                                                  filters: ExamFiltersEntity(),
                                                  externalFilters:
                                                      FiltersExternalEntity(
                                                    examName: null,
                                                    examType: null,
                                                    executionFinalDate: null,
                                                    executionInitialDate: null,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Visibility(
                                        visible: index == state.data.length - 1,
                                        child: const Divider(),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          ListLoadExamsButton(
                            text: LOAD_MORE_RESULTS.translate(),
                            enableButton: false,
                            onPressed: () async {},
                          ),
                        ]),
                      );
                    } else if (state is ExamDateLoadSuccessState) {
                      int? year;
                      bool visibleCard = false;
                      bool enableBorder = false;
                      return SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            BlocBuilder<ExamCubit, ExamState>(
                              bloc: _cubit,
                              buildWhen: (context, state) =>
                                  state is EmitVoiceState,
                              builder: (context, state) => ListSearchExam(
                                externalFilter: externalFilter,
                                examCode: examCode,
                                clearField: () async {
                                  examCode.value = null;
                                  internalFilter.examName = null;
                                  externalFilter.examName = null;

                                  if (dateCardInit != null &&
                                      dateCardFinal != null) {
                                    await loadDataCard(
                                      dateCardInit!,
                                      dateCardFinal!,
                                    );
                                  } else {
                                    await _cubit.loadExamDate(
                                      loadDataExamEntity: loadDateFilter,
                                    );
                                  }
                                },
                                actionVoice: () async {
                                  _controllerSearch.clear();
                                  _controllerSearch.clear();

                                  if (!_speech.isActive()) {
                                    await _speech.initSpeechState();
                                  }

                                  await _speech.startListening();
                                },
                                enabledCard: selectedYearCard != null,
                                cubit: _cubit,
                                filter: internalFilter,
                                loadDateFilter: loadDateFilter,
                                controller: _controllerSearch,
                                onTap: () {
                                  _showFilter(context);
                                },
                              ),
                            ),
                            Center(
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxWidth: 1200,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    left: context.isDevice() ? 16 : 0,
                                  ),
                                  child: Row(
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          await _showFilterExams(
                                            context: context,
                                            filterType: FilterType.all,
                                          );
                                        },
                                        child: SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: FittedBox(
                                            fit: BoxFit.contain,
                                            child: Image.asset(
                                              SLIDE_MENU_IMG,
                                              fit: BoxFit.contain,
                                              package: MICRO_APP_PACKAGE_NAME,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5.0,
                                      ),
                                      Expanded(
                                        child: SizedBox(
                                          height: 80,
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            padding: EdgeInsets.only(
                                              left: context.isDevice() ? 16 : 0,
                                              right:
                                                  context.isDevice() ? 16 : 0,
                                            ),
                                            child: Row(
                                              children: [
                                                ButtonFilter(
                                                  title: SELECT_COMPLETION_DATE
                                                      .translate(),
                                                  selectedCard: internalFilter
                                                              .executionInitialDate !=
                                                          null &&
                                                      internalFilter
                                                              .executionFinalDate !=
                                                          null,
                                                  action: () async {
                                                    await _showFilterExams(
                                                      context: context,
                                                      filterType:
                                                          FilterType.date,
                                                    );
                                                  },
                                                ),
                                                const SizedBox(
                                                  width: 8.0,
                                                ),
                                                ButtonFilter(
                                                  title: CATEGORY.translate(),
                                                  action: () async {
                                                    await _showFilterExams(
                                                      context: context,
                                                      filterType:
                                                          FilterType.category,
                                                    );
                                                  },
                                                  selectedCard:
                                                      internalFilter.examType !=
                                                              null &&
                                                          internalFilter
                                                              .examType!
                                                              .isNotEmpty,
                                                ),
                                                const SizedBox(
                                                  width: 8.0,
                                                ),
                                                ButtonFilter(
                                                  title: RESULTS_RELEASED
                                                      .translate(),
                                                  action: () async {
                                                    await _showFilterExams(
                                                      context: context,
                                                      filterType: FilterType
                                                          .released_results,
                                                    );
                                                  },
                                                  selectedCard: internalFilter
                                                              .statusResult !=
                                                          null &&
                                                      internalFilter
                                                          .statusResult!
                                                          .isNotEmpty,
                                                ),
                                                const SizedBox(
                                                  width: 8.0,
                                                ),
                                                ButtonFilter(
                                                  title: IMPORTED_EXAMS
                                                      .translate(),
                                                  action: () async {
                                                    await _showFilterExams(
                                                      context: context,
                                                      filterType:
                                                          FilterType.imported,
                                                    );
                                                  },
                                                  selectedCard: (localLab
                                                              .value ??
                                                          false) ||
                                                      (otherLab.value ?? false),
                                                ),
                                                const SizedBox(
                                                  width: 8.0,
                                                ),
                                                ButtonFilter(
                                                  title: EINSTEIN_UNIT,
                                                  action: () async {
                                                    await _showFilterExams(
                                                      context: context,
                                                      filterType: FilterType
                                                          .einstein_unity,
                                                    );
                                                  },
                                                  selectedCard:
                                                      internalFilter.unity !=
                                                              null &&
                                                          internalFilter.unity!
                                                              .isNotEmpty,
                                                ),
                                                const SizedBox(
                                                  width: 8.0,
                                                ),
                                                ButtonFilter(
                                                  title: PASSAGE.translate(),
                                                  action: () async {
                                                    await _showFilterExams(
                                                      context: context,
                                                      filterType:
                                                          FilterType.passage,
                                                    );
                                                  },
                                                  selectedCard:
                                                      internalFilter.passType !=
                                                              null &&
                                                          internalFilter
                                                              .passType!
                                                              .isNotEmpty,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount:
                                  loadCountList > _cubit.listDateExams.length
                                      ? _cubit.listDateExams.length
                                      : loadCountList,
                              itemBuilder: (
                                BuildContext context,
                                int index,
                              ) {
                                if (year == null) {
                                  year = _cubit
                                      .listDateExams[index].dtExecution.year;
                                  visibleCard = true;
                                } else {
                                  enableBorder = true;
                                  visibleCard = year !=
                                      _cubit.listDateExams[index].dtExecution
                                          .year;

                                  year = _cubit
                                      .listDateExams[index].dtExecution.year;
                                }

                                return Center(
                                  child: ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      maxWidth: 1200,
                                    ),
                                    child: Column(
                                      children: [
                                        Visibility(
                                          visible: visibleCard,
                                          child: HeaderGroupYear(
                                            enableBorder: enableBorder,
                                            year: year,
                                          ),
                                        ),
                                        const Divider(),
                                        HeaderExpansionTile(
                                          fontSize: 16.0,
                                          showIconTrailing: true,
                                          initiallyExpanded: index == 0,
                                          title: _cubit
                                              .listDateExams[index].dtExecution
                                              .dateInFull(),
                                          body: [
                                            Container(
                                              constraints: const BoxConstraints(
                                                maxWidth: 1200,
                                              ),
                                              width: double.infinity,
                                              child:
                                                  ValueListenableBuilder<bool>(
                                                valueListenable: shareExamState,
                                                builder:
                                                    (context, shareValue, _) =>
                                                        LoadExamsDetails(
                                                  multipleShareExams: () {
                                                    if (!shareExamState.value) {
                                                      shareExamState.value =
                                                          true;
                                                      setState(() {});
                                                    }
                                                    shareList.clear();
                                                  },
                                                  refreshAfterDelete: () {
                                                    _cubit.listDateExams
                                                        .removeWhere(
                                                      (element) =>
                                                          element.dtExecution ==
                                                          _cubit
                                                              .listDateExams[
                                                                  index]
                                                              .dtExecution,
                                                    );
                                                    setState(() {});
                                                  },
                                                  removeExternalExam: _cubit
                                                      .removeExternalExams,
                                                  downloadExternalPDF:
                                                      _cubit.getExternalExam,
                                                  updateCount:
                                                      _cubit.incSelectedExams,
                                                  shareList: shareList,
                                                  downloadPDF:
                                                      _cubit.downloadsExamsPdf,
                                                  listExam: null,
                                                  enableCheckBox: shareValue,
                                                  execute:
                                                      _cubit.loadExamsDetails,
                                                  loadExamEntity:
                                                      LoadExamEntity(
                                                    lab: null,
                                                    passageId: null,
                                                    initialDate: _cubit
                                                        .listDateExams[index]
                                                        .dtExecution,
                                                    finalDate: _cubit
                                                        .listDateExams[index]
                                                        .dtExecution,
                                                    auxPrint: false,
                                                    chAuthentication: null,
                                                    medicalAppointment: null,
                                                    results: true,
                                                    numberOfRecords: null,
                                                    exams: null,
                                                    idItens: null,
                                                    filters:
                                                        ExamFiltersEntity(),
                                                    externalFilters:
                                                        FiltersExternalEntity(
                                                      examName: null,
                                                      examType: null,
                                                      executionFinalDate: null,
                                                      executionInitialDate:
                                                          null,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Visibility(
                                          visible: index == loadCountList - 1,
                                          child: const Divider(),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                            ListLoadExamsButton(
                              text: LOAD_MORE_RESULTS.translate(),
                              enableButton: !_cubit.isLoadedAllDates ||
                                  _cubit.listDateExams.length > loadCountList,
                              onPressed: () async {
                                loadCountList += 20;

                                if (selectedMonthCard == null ||
                                    selectedYearCard == null) {
                                  DateTime lastDateList =
                                      _cubit.listDateExams.last.dtExecution;

                                  DateTime initialDate = lastDateList.subtract(
                                    Duration(
                                      days: fiveYearsInDays,
                                    ),
                                  );

                                  DateTime finalDate = lastDateList.subtract(
                                    const Duration(days: 1),
                                  );

                                  loadDateFilter.initialDate = initialDate;
                                  loadDateFilter.finalDate = finalDate;
                                  loadDateFilter.numberOfRecords = 20;
                                } else {
                                  loadDateFilter.numberOfRecords = 0;
                                }

                                if (loadCountList >
                                    _cubit.listDateExams.length) {
                                  await _cubit.loadExamDate(
                                    loadDataExamEntity: loadDateFilter,
                                  );
                                } else {
                                  setState(() {});
                                }
                              },
                            ),
                          ],
                        ),
                      );
                    } else {
                      return SliverList(
                        delegate: SliverChildListDelegate([
                          Container(),
                        ]),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      );
}
