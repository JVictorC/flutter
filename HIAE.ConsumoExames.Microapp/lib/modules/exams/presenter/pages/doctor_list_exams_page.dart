import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:base_dependencies/dependencies.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
import '../../../../core/extensions/translate_extension.dart';
import '../../../../core/utils/open_url.dart';
import '../../../../core/widgets/bread_crumbs.dart';
import '../../../../core/widgets/default_app_bar.dart';
import '../../../../core/widgets/default_header_title.dart';
import '../../../../core/widgets/header_expansion_tile.dart';
import '../../domain/entities/exams_doctor_entity.dart';
import '../../domain/entities/exams_filters_entity.dart';
import '../../domain/entities/exams_filters_external_entity.dart';
import '../../domain/entities/load_date_exam_entity.dart';
import '../../domain/entities/load_exams_entity.dart';
import '../../domain/entities/patient_target_entity.dart';
import '../cubits/exam_cubit.dart';
import '../cubits/exam_state_cubit.dart';
import '../widgets/button_clear_list_exam.dart';
import '../widgets/card_patient.dart';
import '../widgets/filter_doctor_body_widget.dart';
import '../widgets/header_filter_doctor.dart';
import '../widgets/label_count_exams.dart';
import '../widgets/list_date_cards.dart';
import '../widgets/list_load_exams_button.dart';
import '../widgets/load_exams_details.dart';
import '../widgets/search_list_exam_doctor.dart';

class DoctorListExamsPage extends StatefulWidget {
  const DoctorListExamsPage({Key? key}) : super(key: key);

  @override
  State<DoctorListExamsPage> createState() => _DoctorListExamsPageState();
}

class _DoctorListExamsPageState extends State<DoctorListExamsPage> {
  int loadCountList = 10;
  late final ISpeech _speech;
  late final ExamsDoctorEntity examsDoctor;
  final int fiveYearsInDays = 1825;
  late final ExamCubit _cubit;
  late final TextEditingController _controllerSearch;
  late final TextEditingController _controllerVoice;
  late ScrollController _scrollController;
  bool emptyExams = false;

  final double defaultLeftPaddingPage = DEFAULT_LEFT_PADDING + 4;

  double? positionScroll;
  int? selectedYearCard;
  int? selectedMonthCard;
  late final PatientTargetEntity patientData;

  Future<void> _loadData() async => await _cubit.loadExamDateAndMedicalRecords(
        loadDataExamEntity: examsDoctor.examsDate,
      );

  @override
  void initState() {
    _cubit = I.getDependency<ExamCubit>();
    _controllerSearch = TextEditingController();
    _controllerVoice = TextEditingController();
    _scrollController = ScrollController();

    final DateTime dateFinal = DateTime.now();
    final DateTime dateInitial =
        dateFinal.subtract(Duration(days: fiveYearsInDays));

    examsDoctor = ExamsDoctorEntity(
      enableCardFilters: false,
      dateInitial: dateInitial,
      dateFinal: dateFinal,
      dateCardFinal: null,
      dateCardInitial: null,
      searchExams: null,
      externalFilter: FiltersExternalEntity(),
      internalFilter: ExamFiltersEntity(),
      examsDate: LoadDateExamEntity(
        initialDate: dateInitial,
        finalDate: dateFinal,
        numberOfRecords: 0,
      ),
    );
    _speech = SpeechAdapter(controller: _controllerVoice);
    _loadData();

    patientData = _cubit.getPatientTarget();

    _controllerVoice.addListener(() async {
      _controllerSearch.text = _controllerVoice.text;
      _cubit.emitVoice();
    });

    super.initState();
  }

  @override
  void dispose() {
    _cubit.close();
    _scrollController.dispose();
    _controllerSearch.dispose();
    _controllerVoice.dispose();
    super.dispose();
  }

  Future<void> _clearFilters() async {
    _controllerSearch.clear();
    _controllerVoice.clear();

    examsDoctor.internalFilter?.examName = null;
    examsDoctor.internalFilter?.passType?.clear();
    examsDoctor.internalFilter?.examType?.clear();
    examsDoctor.internalFilter?.unity?.clear();
    examsDoctor.internalFilter?.executionInitialDate = null;
    examsDoctor.internalFilter?.executionFinalDate = null;

    examsDoctor.externalFilter?.examName = null;
    examsDoctor.externalFilter?.examType?.clear();
    examsDoctor.externalFilter?.executionInitialDate = null;
    examsDoctor.externalFilter?.executionFinalDate = null;

    examsDoctor.examCode = null;

    positionScroll = null;
    selectedMonthCard = null;
    selectedYearCard = null;
    examsDoctor.dateCardInitial = null;
    examsDoctor.dateCardFinal = null;
    examsDoctor.enableCardFilters = false;

    examsDoctor.examsDate.initialDate = examsDoctor.dateInitial;
    examsDoctor.examsDate.finalDate = examsDoctor.dateFinal;

    await _cubit.loadExamDate(
      loadDataExamEntity: examsDoctor.examsDate,
    );
  }

  Future<void> clearDataCard() async {
    positionScroll = null;
    selectedMonthCard = null;
    selectedYearCard = null;
    examsDoctor.enableCardFilters = false;

    examsDoctor.dateCardInitial = null;
    examsDoctor.dateCardFinal = null;

    examsDoctor.examsDate.initialDate = examsDoctor.dateInitial;
    examsDoctor.examsDate.finalDate = examsDoctor.dateFinal;

    if (examsDoctor.searchExams != null &&
        examsDoctor.searchExams!.trim().isNotEmpty) {
      examsDoctor.externalFilter!.examName = null;
      examsDoctor.externalFilter!.examType = null;
      examsDoctor.externalFilter!.executionFinalDate = null;
      examsDoctor.externalFilter!.executionInitialDate = null;

      final loadData = LoadExamEntity(
        lab: null,
        passageId: null,
        initialDate: examsDoctor.dateInitial,
        finalDate: examsDoctor.dateFinal,
        auxPrint: false,
        chAuthentication: null,
        medicalAppointment: null,
        results: true,
        numberOfRecords: null,
        exams: null,
        idItens: null,
        filters: examsDoctor.internalFilter!,
        externalFilters: examsDoctor.externalFilter!,
      );

      await _cubit.loadFilter(
        loadExamEntity: loadData,
      );
    } else {
      await _cubit.loadExamDate(
        loadDataExamEntity: examsDoctor.examsDate,
      );
    }
  }

  Future<void> loadDataCard(DateTime dateInit, DateTime dateFim) async {
    examsDoctor.enableCardFilters = false;
    examsDoctor.dateCardInitial = dateInit;
    examsDoctor.dateCardFinal = dateFim;
    selectedMonthCard = examsDoctor.dateCardInitial!.month;
    selectedYearCard = examsDoctor.dateCardInitial!.year;

    positionScroll = _scrollController.offset;

    if (positionScroll == _scrollController.position.maxScrollExtent) {
      positionScroll = _scrollController.offset + 50;
    }

    examsDoctor.examsDate.finalDate = dateFim;
    examsDoctor.examsDate.initialDate = dateInit;

    if (examsDoctor.searchExams == null ||
        examsDoctor.searchExams!.trim().isEmpty) {
      if (examsDoctor.internalFilter != null &&
          examsDoctor.internalFilter!.examName != null) {
        examsDoctor.internalFilter!.examName == null;
      }

      if (examsDoctor.externalFilter != null &&
          examsDoctor.externalFilter!.examName != null) {
        examsDoctor.externalFilter!.examName == null;
      }
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
      filters: examsDoctor.internalFilter!,
      externalFilters: examsDoctor.externalFilter!,
    );

    await _cubit.loadFilter(
      loadExamEntity: loadData,
    );
  }

  Future<void> loadFilter() async {
    DateTime dateFilterInitial =
        examsDoctor.internalFilter?.executionInitialDate ??
            examsDoctor.externalFilter?.executionFinalDate ??
            examsDoctor.dateInitial;

    DateTime dateFilterFinal = examsDoctor.internalFilter?.executionFinalDate ??
        examsDoctor.externalFilter?.executionFinalDate ??
        examsDoctor.dateFinal;

    if (_controllerSearch.text.isNotEmpty && examsDoctor.examCode == null) {
      examsDoctor.internalFilter?.examName = _controllerSearch.text.trim();
      examsDoctor.externalFilter?.examName = _controllerSearch.text.trim();
    } else {
      examsDoctor.internalFilter?.examName = null;
      examsDoctor.externalFilter?.examName = null;
    }

    examsDoctor.localLab ??= false;
    examsDoctor.otherLab ??= false;

    final loadData = LoadExamEntity(
      lab: ((examsDoctor.localLab! && examsDoctor.otherLab!) ||
              (!examsDoctor.localLab! && !examsDoctor.otherLab!))
          ? null
          : examsDoctor.localLab!
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
      exams: examsDoctor.examCode,
      idItens: null,
      filters: examsDoctor.internalFilter!,
      externalFilters: examsDoctor.externalFilter!,
    );

    positionScroll = null;
    selectedMonthCard = null;
    selectedYearCard = null;
    examsDoctor.enableCardFilters = true;

    await _cubit.loadFilter(loadExamEntity: loadData);
  }

  void _openEndDrawer(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }

  Future<dynamic> _showFilter(BuildContext context) async {
    if (!context.isMobile()) {
      _openEndDrawer(context);
    } else {
      final result = await Navigator.of(context).pushNamed(
        Routes.filterExamDoctorPage,
        arguments: examsDoctor,
      );
      if (result != null && result is ExamsDoctorEntity) {
        //examsDoctor.dateCardInitial = result.dateCardInitial;
        //examsDoctor.dateCardFinal = result.dateCardFinal;
        examsDoctor.internalFilter = result.internalFilter;
        examsDoctor.externalFilter = result.externalFilter;
        examsDoctor.localLab = result.localLab;
        examsDoctor.otherLab = result.otherLab;

        /*examsDoctor.copyWith(
          dateCardInitial: result.dateCardInitial,
          dateCardFinal: result.dateCardFinal,
          internalFilter: result.internalFilter,
          externalFilter: result.externalFilter,
          localLab: result.localLab,
          otherLab: result.otherLab,
        );*/
        await loadFilter();
      }
    }
  }

  double _getFloatPadding(BuildContext context) {
    double value = ((MediaQuery.of(context).size.width - 1200) / 2) - 6;

    return value < 0 ? 0.0 : value;
  }

  @override
  Widget build(BuildContext context) => ZeraScaffold(
        floatingActionButton: SizedBox(
          height: 64,
          width: 64,
          child: FloatingActionButton(
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
        endDrawerEnableOpenDragGesture: false,
        endDrawer: SafeArea(
          child: Container(
            constraints: const BoxConstraints(
              maxWidth: 572,
            ),
            width: double.infinity,
            child: Drawer(
              child: FilterDoctorBodyWidget(
                doctorFilter: examsDoctor,
                initialDateController:
                    TextEditingController(), //_startDateTimeController,
                finalDateController:
                    TextEditingController(), //_endDateTimeController,
                resultFilter: (result) async {
                  Navigator.of(context).pop();
                  examsDoctor.internalFilter = result.internalFilter;
                  examsDoctor.externalFilter = result.externalFilter;
                  examsDoctor.localLab = result.localLab;
                  examsDoctor.otherLab = result.otherLab;

                  await loadFilter();
                },
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: CustomScrollView(
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
                            SizedBox(
                              height: kNavBarHeight,
                              child: DefaultAppBar(
                                actionButton: null,
                                iconAppBar: ZeraIcons.arrow_left_1,
                                rootNavigator: true,
                                leftPaddingHeader:
                                    context.isDevice() ? 5.0 : 0.0,
                                trailing: null,
                              ),
                            ),
                            DefaultHeaderTitle(
                              leftPaddingHeader: context.isDevice() ? 5.0 : 0.0,
                              title: RESULTS_OF_EXAMS.translate(),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Visibility(
                              visible: !emptyExams,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: context.isDevice() ? 16 : 0,
                                      right: context.isDevice() ? 16 : 0,
                                    ),
                                    child: CardPatient(
                                      onTap: () => Navigator.of(
                                        context,
                                        rootNavigator: true,
                                      ).pop(),
                                      name: patientData.name,
                                      patientId: patientData.id,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 40.0,
                                  ),
                                ],
                              ),
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
                    state is ExamEmptyState,
                listener: (context, state) async {
                  if (state is ExamFailureState) {
                    if (state.failure is NoInternetConnectionFailure) {
                      final refresh = await Navigator.of(context).pushNamed(
                        Routes.failedConnectionPage,
                        arguments: MY_EXAMS.translate(),
                      ) as bool?;

                      if (refresh == true) {
                        _controllerSearch.clear();
                        _controllerVoice.clear();

                        examsDoctor.internalFilter?.examName = null;
                        examsDoctor.internalFilter?.passType?.clear();
                        examsDoctor.internalFilter?.examType?.clear();
                        examsDoctor.internalFilter?.unity?.clear();
                        examsDoctor.internalFilter?.executionInitialDate = null;
                        examsDoctor.internalFilter?.executionFinalDate = null;

                        examsDoctor.externalFilter?.examName = null;
                        examsDoctor.externalFilter?.examType?.clear();
                        examsDoctor.externalFilter?.executionInitialDate = null;
                        examsDoctor.externalFilter?.executionFinalDate = null;

                        examsDoctor.examCode = null;

                        positionScroll = null;
                        selectedMonthCard = null;
                        selectedYearCard = null;
                        examsDoctor.dateCardInitial = null;
                        examsDoctor.dateCardFinal = null;
                        examsDoctor.enableCardFilters = false;

                        examsDoctor.examsDate.initialDate =
                            examsDoctor.dateInitial;
                        examsDoctor.examsDate.initialDate =
                            examsDoctor.dateFinal;

                        final DateTime dateFinal = DateTime.now();
                        final DateTime dateInitial =
                            dateFinal.subtract(Duration(days: fiveYearsInDays));

                        examsDoctor.examsDate = LoadDateExamEntity(
                          initialDate: dateInitial,
                          finalDate: dateFinal,
                          numberOfRecords: 0,
                        );

                        await _loadData();
                      } else {
                        Navigator.of(context, rootNavigator: true).pop();
                      }
                    } else {
                      await Navigator.of(context).pushNamed(
                        Routes.errorPage,
                        arguments: RESULTS_OF_EXAMS.translate(),
                      );
                    }
                  } else if (state is ExamEmptyState && !emptyExams) {
                    emptyExams = true;
                    setState(() {});
                  }
                },
                builder: (context, state) {
                  if (state is ExamLoadState) {
                    return const SliverFillRemaining(
                      child: Center(
                        child: CircularProgressIndicator(),
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                              onPressed: () =>
                                  Navigator.of(context, rootNavigator: true)
                                      .pop(),
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
                              builder: (context, state) => SearchListExamDoctor(
                                cubit: _cubit,
                                enabledCard: selectedYearCard != null,
                                controller: _controllerSearch,
                                examsDoctor: examsDoctor,
                                openFilter: () {
                                  _showFilter(context);
                                },
                                clearField: () async {
                                  examsDoctor.examCode = null;
                                  examsDoctor.internalFilter?.examName = null;
                                  examsDoctor.externalFilter?.examName = null;

                                  if (examsDoctor.dateCardInitial != null &&
                                      examsDoctor.dateCardFinal != null) {
                                    await loadDataCard(
                                      examsDoctor.dateCardInitial!,
                                      examsDoctor.dateCardFinal!,
                                    );
                                  } else {
                                    await _cubit.loadExamDate(
                                      loadDataExamEntity: examsDoctor.examsDate,
                                    );
                                  }
                                },
                                actionVoice: () async {
                                  if (!_speech.isActive()) {
                                    await _speech.initSpeechState();
                                  }

                                  await _speech.startListening();
                                },
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.asset(
                                        EMPTY_PAGE,
                                        fit: BoxFit.contain,
                                        package: MICRO_APP_PACKAGE_NAME,
                                      ),
                                      const SizedBox(
                                        height: 30,
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
                                  ? 250
                                  : MediaQuery.of(context).size.height / 8,
                              child: ButtonClearListExam(
                                onPressed: _clearFilters,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else if (state is ExamDateLoadSuccessState) {
                    return SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          BlocBuilder<ExamCubit, ExamState>(
                            bloc: _cubit,
                            buildWhen: (context, state) =>
                                state is EmitVoiceState,
                            builder: (context, state) => SearchListExamDoctor(
                              cubit: _cubit,
                              enabledCard: selectedYearCard != null,
                              controller: _controllerSearch,
                              examsDoctor: examsDoctor,
                              openFilter: () {
                                _showFilter(context);
                              },
                              clearField: () async {
                                examsDoctor.examCode = null;
                                examsDoctor.internalFilter?.examName = null;
                                examsDoctor.externalFilter?.examName = null;

                                if (examsDoctor.dateCardInitial != null &&
                                    examsDoctor.dateCardFinal != null) {
                                  await loadDataCard(
                                    examsDoctor.dateCardInitial!,
                                    examsDoctor.dateCardFinal!,
                                  );
                                } else {
                                  await _cubit.loadExamDate(
                                    loadDataExamEntity: examsDoctor.examsDate,
                                  );
                                }
                              },
                              actionVoice: () async {
                                if (!_speech.isActive()) {
                                  await _speech.initSpeechState();
                                }

                                await _speech.startListening();
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
                              child: ListDateCards(
                                positionScroll: positionScroll,
                                scrollController: _scrollController,
                                defaultMonthCard: selectedMonthCard,
                                defaultYearCard: selectedYearCard,
                                clickedCard: loadDataCard,
                                clearField: clearDataCard,
                                cubit: _cubit,
                                loadCountList: loadCountList,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 30.0,
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
                            ) =>
                                Center(
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxWidth: 1200,
                                ),
                                child: Column(
                                  children: [
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
                                          child: LoadExamsDetails(
                                            multipleShareExams: null,
                                            refreshAfterDelete: null,
                                            removeExternalExam:
                                                _cubit.removeExternalExams,
                                            route: Routes.examResultDoctorPage,
                                            userDoctorType: true,
                                            downloadExternalPDF:
                                                _cubit.getExternalExam,
                                            updateCount:
                                                _cubit.incSelectedExams,
                                            shareList: const [],
                                            downloadPDF:
                                                _cubit.downloadsExamsPdf,
                                            listExam: null,
                                            enableCheckBox: false,
                                            execute: _cubit.loadExamsDetails,
                                            loadExamEntity: LoadExamEntity(
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
                                        Visibility(
                                          visible: index == loadCountList - 1,
                                          child: const Divider(),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          ListLoadExamsButton(
                            text: LOAD_MORE_RESULTS.translate(),
                            enableButton: !_cubit.isLoadedAllDates ||
                                _cubit.listDateExams.length >= loadCountList,
                            onPressed: () async {
                              loadCountList += 10;

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

                                examsDoctor.examsDate.initialDate = initialDate;

                                examsDoctor.examsDate.initialDate = finalDate;
                              }

                              examsDoctor.examsDate.numberOfRecords = 0;

                              if (loadCountList > _cubit.listDateExams.length) {
                                await _cubit.loadExamDate(
                                  loadDataExamEntity: examsDoctor.examsDate,
                                );
                              } else {
                                setState(() {});
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  } else if (state is ExamLoadFilter) {
                    return SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          BlocBuilder<ExamCubit, ExamState>(
                            bloc: _cubit,
                            buildWhen: (context, state) =>
                                state is EmitVoiceState,
                            builder: (context, state) => SearchListExamDoctor(
                              cubit: _cubit,
                              enabledCard: selectedYearCard != null,
                              controller: _controllerSearch,
                              examsDoctor: examsDoctor,
                              openFilter: () => _showFilter(context),
                              clearField: () async {
                                examsDoctor.examCode = null;
                                examsDoctor.internalFilter?.examName = null;
                                examsDoctor.externalFilter?.examName = null;

                                if (examsDoctor.dateCardInitial != null &&
                                    examsDoctor.dateCardFinal != null) {
                                  await loadDataCard(
                                    examsDoctor.dateCardInitial!,
                                    examsDoctor.dateCardFinal!,
                                  );
                                } else {
                                  await _cubit.loadExamDate(
                                    loadDataExamEntity: examsDoctor.examsDate,
                                  );
                                }
                              },
                              actionVoice: () async {
                                if (!_speech.isActive()) {
                                  await _speech.initSpeechState();
                                }

                                await _speech.startListening();
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Visibility(
                            visible: !examsDoctor.enableCardFilters,
                            child: Center(
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxWidth: 1200,
                                ),
                                child: ListDateCards(
                                  positionScroll: positionScroll,
                                  scrollController: _scrollController,
                                  defaultMonthCard: selectedMonthCard,
                                  defaultYearCard: selectedYearCard,
                                  clickedCard: loadDataCard,
                                  clearField: clearDataCard,
                                  cubit: _cubit,
                                  loadCountList: state.data.length,
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: examsDoctor.enableCardFilters,
                            child: Center(
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxWidth: 1200,
                                ),
                                child: HeaderFilterDoctor(
                                  cubit: _cubit,
                                  examsDoctor: examsDoctor,
                                  amount: state.examsAccount,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 24.0,
                          ),
                          Visibility(
                            visible: !examsDoctor.enableCardFilters,
                            child: LabelAccountExams(
                              action: () {},
                              monthLabel: selectedYearCard != null
                                  ? selectedMonthCard!.getMonth()
                                  : null,
                              yearLabel: selectedYearCard?.toString(),
                              filterCardMonth: selectedYearCard != null,
                              dateCount: state.data.entries.length,
                              countLabel: state.examsAccount,
                            ),
                          ),
                          const SizedBox(
                            height: 40.0,
                          ),
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: state.data.length,
                            itemBuilder: (
                              BuildContext context,
                              int index,
                            ) =>
                                Center(
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxWidth: 1200,
                                ),
                                child: Column(
                                  children: [
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
                                          child: LoadExamsDetails(
                                            multipleShareExams: null,
                                            refreshAfterDelete: null,
                                            removeExternalExam:
                                                _cubit.removeExternalExams,
                                            route: Routes.examResultDoctorPage,
                                            userDoctorType: true,
                                            downloadExternalPDF:
                                                _cubit.getExternalExam,
                                            updateCount:
                                                _cubit.incSelectedExams,
                                            shareList: const [],
                                            downloadPDF: _cubit.loadPdfResult,
                                            listExam: state.data[state.data.keys
                                                .elementAt(index)],
                                            enableCheckBox: false,
                                            execute: _cubit.loadExamsDetails,
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
                                      ],
                                    ),
                                    Visibility(
                                      visible: index == state.data.length - 1,
                                      child: const Divider(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          ListLoadExamsButton(
                            text: LOAD_MORE_RESULTS.translate(),
                            enableButton: false,
                            onPressed: () async {},
                          ),
                        ],
                      ),
                    );
                  } else {
                    return SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Container(),
                        ],
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      );
}
