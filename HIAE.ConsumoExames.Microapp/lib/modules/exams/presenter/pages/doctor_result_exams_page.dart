import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:base_dependencies/dependencies.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdfx/pdfx.dart';

import '../../../../core/adapters/html/iframe_html_adapter.dart';
import '../../../../core/constants/assets_constants.dart';
import '../../../../core/constants/routes.dart';
import '../../../../core/constants/strings.dart';
import '../../../../core/di/initInjector.dart';
import '../../../../core/extensions/date_time_extension.dart';
import '../../../../core/extensions/mobile_size_extension.dart';
import '../../../../core/extensions/string_extension.dart';
import '../../../../core/extensions/translate_extension.dart';
import '../../../../core/utils/download_mobile_utils.dart';
import '../../../../core/utils/download_web_utils.dart';
import '../../../../core/utils/local_storage_utils.dart';
import '../../../../core/utils/open_url.dart';
import '../../../../core/utils/share_mobile_utils.dart';
import '../../../../core/web_view/web_view_ui_stub.dart';
import '../../../../core/widgets/bread_crumbs.dart';
import '../../../../core/widgets/responsive_app_bar.dart';
import '../../domain/entities/date_exam_entity.dart';
import '../../domain/entities/evolutionary_report_response_entity.dart';
import '../../domain/entities/exam_entity.dart';
import '../../domain/entities/exam_image_result_entity.dart';
import '../../domain/entities/exam_pdf_result_entity.dart';
import '../../domain/entities/exams_filters_entity.dart';
import '../../domain/entities/exams_filters_external_entity.dart';
import '../../domain/entities/external_exam_file_entity.dart';
import '../../domain/entities/external_exam_file_req_entity.dart';
import '../../domain/entities/load_exams_entity.dart';
import '../../domain/entities/medical_appointment_list_result_exams_entity.dart';
import '../../domain/usecases/get_image_result_usecase.dart';
import '../../domain/usecases/get_pdf_result_usecase.dart';
import '../cubits/exam_cubit.dart';
import '../cubits/exam_state_cubit.dart';
import '../widgets/button_footer_widget.dart';
import '../widgets/card_patient.dart';
import '../widgets/evolution_body_widget.dart';
import '../widgets/pdf_page.dart';
import 'doctor_exam_details_page.dart';

class DoctorResultExamsPage extends StatefulWidget {
  const DoctorResultExamsPage({Key? key}) : super(key: key);

  @override
  State<DoctorResultExamsPage> createState() => _DoctorResultExamsPageState();
}

class _DoctorResultExamsPageState extends State<DoctorResultExamsPage>
    with TickerProviderStateMixin {
  List<ZeraTab> tabs = [];
  List<Widget> body = [];
  TabController? _tabController;
  PdfControllerPinch? _pdfController;
  late final ExamCubit _cubit;
  late ExamEntity examEntityParam;
  late ExamEntity examEntity;
  List<ExamEntity> listExamEntity = [];
  late bool loaded;
  late DateExamEntity dateExamEntity;
  final pdfBase64 = ValueNotifier<String?>(null);
  late List<Widget> _zeraTabBar;
  late ScrollController _scrollController;
  String imageUrl = '';
  Timer? imageTime;
  int? imageIndex;
  int? laudoIndex;
  int? evolutiveIndex;
  String? fileName;
  final indexListener = ValueNotifier<int?>(null);
  final isLoadingExamEntityListener = ValueNotifier<bool>(true);
  bool isValidBottomNavigation = false;
  int currentExamIndexSelected = 0;

  void _openEndDrawer(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }

  Future<EvolutionaryReportExamsEntity?> getEvolutionary() async {
    final evolutionResult = await _cubit.getEvolutionaryReportExams(
      examsCodes: [examEntity.examCode ?? ''],
    );

    return evolutionResult != null &&
            evolutionResult.examsConsultation.isNotEmpty
        ? evolutionResult
        : null;
  }

  Future<ExamPdfResultEntity?> getResultPdfResult() async {
    if (examEntity.result != null &&
        examEntity.result!.isNotEmpty &&
        laudoIndex == null) {
      return await _cubit.downloadsExamsPdf(
        PdfResultParam(
          medicalAppointment: getIdPatient(),
          examCode: examEntity.examCode,
          passage: examEntity.passageId,
          executionDateBegin: examEntity.executionDate,
          executionDateEnd: examEntity.executionDate,
          itensIdList: [
            examEntity.examId ?? '',
          ],
          userType: 0,
          examBreak: true,
        ),
      );
    }
  }

  Future<ExamImageResultEntity?> getImageResult() async =>
      await _cubit.loadImageResult(
        ExamImageParam(
          accessionNumber: examEntity.accessNumber,
          patientId: getIdPatient(),
        ),
      );

  Future<ExternalExamFileEntity?> getExternalExams() async {
    if (examEntity.path != null && examEntity.fileId != null) {
      final ExternalExamFileEntity? externalExamFile =
          await _cubit.getExternalExam(
        ExternalExamFileReqEntity(
          file: examEntity.fileId!,
          path: examEntity.path!,
        ),
      );

      return externalExamFile;
    }
  }

  void createTabPdf(ExamPdfResultEntity? pdfResult) {
    if (pdfResult != null) {
      tabs.add(ZeraTab(tabText: RESULT.translate()));
      _pdfController = PdfControllerPinch(
        document: PdfDocument.openData(pdfResult.pdfResult.toUint8List()),
      );
      body.add(
        PDFBodyPage(
          baseString: pdfResult.pdfResult,
          pdfController: _pdfController!,
        ),
      );
      pdfBase64.value = pdfResult.pdfResult;
      laudoIndex = body.length - 1;
    } else if (laudoIndex == null &&
        !examEntity.available &&
        examEntity.statusResult == 4) {
      tabs.add(ZeraTab(tabText: RESULT.translate()));
      body.add(const _EmptyPage());
    }
  }

  void createTabImg(ExamImageResultEntity? imageResult) {
    if (imageResult != null && imageResult.getUserTokenResult.isNotEmpty) {
      imageUrl = imageResult.getUserTokenResult;
      if (Uri.parse(imageUrl).isAbsolute) {
        tabs.add(ZeraTab(tabText: IMAGE.translate()));
        body.add(
          LayoutBuilder(
            builder: (context, constraints) => Scrollbar(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Center(
                  child: Container(
                    color: ZeraColors.neutralLight01,
                    constraints: const BoxConstraints(
                      maxWidth: 1200,
                    ),
                    width: constraints.maxWidth,
                    height: constraints.maxHeight,
                    child: AnimatedBuilder(
                      animation: _refreshImageNotifier,
                      builder: (context, child) => kIsWeb
                          ? Center(
                              child: InkWell(
                                onTap: () {
                                  newWebTab('${Uri.tryParse(imageUrl)}');
                                },
                                child: ZeraText(
                                  CLICK_HERE_TO_VIEW_YOUR_EXAM.translate(),
                                  type: ZeraTextType
                                      .BOLD_20_NEUTRAL_LIGHT_TEXT_ALIGN_CENTER,
                                  color: ZeraColors.primaryMedium,
                                ),
                              ),
                            )
                          : _getImagePage(
                              html:
                                  '<iframe src="${Uri.tryParse(imageUrl)}"></iframe>',
                              url: imageUrl,
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        imageIndex = body.length - 1;
        imageTime = Timer.periodic(
          const Duration(minutes: 4),
          (timer) async {
            final imageResult = await _cubit.refreshImageResult(
              ExamImageParam(
                accessionNumber: examEntity.accessNumber,
                patientId: getIdPatient(),
              ),
            );
            imageUrl = imageResult!.getUserTokenResult;
            if (Uri.parse(imageUrl).isAbsolute) {
              _refreshImageNotifier.value++;
            }
          },
        );
      }
    }
  }

  void createTabExternalExam(ExternalExamFileEntity? externalExamFile) {
    if (externalExamFile?.path != null && externalExamFile?.file != null) {
      tabs.add(ZeraTab(tabText: RESULT.translate()));
      fileName = externalExamFile!.path.split('/').last;
      final extensionFile = fileName?.split('.').last.toLowerCase();
      Widget externalBody;

      if (extensionFile == 'pdf') {
        _pdfController = PdfControllerPinch(
          document: PdfDocument.openData(
            base64.normalize(externalExamFile.file).toUint8List(),
          ),
        );
        externalBody = PDFBodyPage(
          baseString: base64.normalize(externalExamFile.file),
          pdfController: _pdfController!,
        );
      } else {
        externalBody = Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: PhotoView(
              backgroundDecoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              enablePanAlways: true,
              imageProvider: Image.memory(
                base64.normalize(externalExamFile.file).toUint8List(),
              ).image,
            ),
          ),
        );
      }
      body.add(externalBody);
      pdfBase64.value = base64.normalize(externalExamFile.file);
      laudoIndex = body.length - 1;
    }
  }

  createPageEvolutionaryReport(EvolutionaryReportExamsEntity? evolutionResult) {
    if (evolutionResult != null &&
        evolutionResult.examsConsultation.isNotEmpty) {
      tabs.add(ZeraTab(tabText: EVOLUTION.translate()));
      body.add(
        EvolutionBodyWidget(
          evolutionEntity: evolutionResult,
        ),
      );
      evolutiveIndex = body.length - 1;
    }
  }

  Future<void> createPageTabs() async {
    await Future.wait([
      getResultPdfResult(),
      getImageResult(),
      getExternalExams(),
      getEvolutionary(),
    ]).then((result) {
      if (result.isNotEmpty) {
        createTabPdf(result[0] as ExamPdfResultEntity?);
        createTabImg(result[1] as ExamImageResultEntity?);
        createTabExternalExam(result[2] as ExternalExamFileEntity?);
        createPageEvolutionaryReport(
          result[3] as EvolutionaryReportExamsEntity?,
        );
      }
    });
  }

  Future<MedicalAppointmentListResultExamsEntity?> loadResultsOfDate(
          DateTime date) async =>
      await _cubit.loadExamsDetails(
        loadExamEntity: LoadExamEntity(
          lab: null,
          passageId: null,
          initialDate: date,
          finalDate: date,
          auxPrint: false,
          chAuthentication: null,
          medicalAppointment: getIdPatient(),
          results: true,
          numberOfRecords: null,
          exams: null,
          idItens: null,
          filters: ExamFiltersEntity(),
          externalFilters: FiltersExternalEntity(
            examName: null,
            examType: null,
            executionFinalDate: null,
            executionInitialDate: null,
          ),
        ),
      );

  Future<void> loadExamBodyContent() async {
    tabs.clear();
    body.clear();
    isLoadingExamEntityListener.value = true;
    examEntity = listExamEntity[currentExamIndexSelected];

    if (examEntity.laudo) {
      final pdfResult = await _cubit.downloadsExamsPdf(
        PdfResultParam(
          medicalAppointment: getIdPatient(),
          examCode: examEntity.examCode,
          passage: examEntity.passageId,
          executionDateBegin: examEntity.executionDate,
          executionDateEnd: examEntity.executionDate,
          itensIdList: [
            examEntity.examId ?? '',
          ],
          userType: 0,
          examBreak: true,
        ),
      );
      if (pdfResult != null) {
        tabs.add(ZeraTab(tabText: 'Laudo'));
        _pdfController = PdfControllerPinch(
          document: PdfDocument.openData(pdfResult.pdfResult.toUint8List()),
        );
        body.add(
          PDFBodyPage(
            baseString: pdfResult.pdfResult,
            pdfController: _pdfController!,
          ),
        );
        pdfBase64.value = pdfResult.pdfResult;
        laudoIndex = body.length - 1;
      }
    }

    if (examEntity.examId != null) {
      removeExternalIdStorage(id: examEntity.examId!);
    }

    await createPageTabs();

    void onTapTab() {
      if (laudoIndex is int && _tabController?.index == laudoIndex) {
        _pdfController!.loadDocument(
          PdfDocument.openData(
            pdfBase64.value!.toUint8List(),
          ),
        );
      }
      indexListener.value = _tabController?.index;
    }

    _tabController = TabController(
      length: tabs.length,
      vsync: this,
    );
    _zeraTabBar = [
      ZeraDivider(),
      !context.isMobile()
          ? Center(
              child: Container(
                constraints: const BoxConstraints(
                  maxWidth: 1200,
                ),
                alignment: Alignment.centerLeft,
                width: double.infinity,
                child: SizedBox(
                  width: tabs.length * 188,
                  child: ZeraTabBar(
                    style: ZeraTabBarStyle.VARIANT,
                    tabs: tabs,
                    onTabTap: onTapTab,
                    controller: _tabController,
                  ),
                ),
              ),
            )
          : ZeraTabBar(
              style: ZeraTabBarStyle.VARIANT,
              tabs: tabs,
              onTabTap: onTapTab,
              controller: _tabController,
            ),
    ];
    _cubit.emitAllExamsLoaded();
    indexListener.value = 0;
    isLoadingExamEntityListener.value = false;
    setState(() {});
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (!loaded) {
      loaded = true;
      examEntityParam =
          ModalRoute.of(context)?.settings.arguments as ExamEntity;
      examEntityParam = examEntityParam.copyWith(position: 0);
      examEntity = examEntityParam;
      listExamEntity.add(examEntity);
      final MedicalAppointmentListResultExamsEntity? resultExamsResponse =
          await loadResultsOfDate(examEntity.executionDate);
      final List<ExamEntity> auxListResult = [];
      if (resultExamsResponse != null) {
        for (var resultItem in resultExamsResponse.resultInternalExam) {
          resultItem = resultItem.copyWith(
            listExam: resultItem.listExam
                .map((e) => e.copyWith(position: 0))
                .toList(),
          );
          auxListResult.addAll(resultItem.listExam);
        }
        if (resultExamsResponse.resultExternalExam.isNotEmpty) {
          // int position = resultExamsResponse.resultExternalExam.length + 1;
          for (var element in resultExamsResponse.resultExternalExam) {
            final exam = ExamEntity(
              fileId: element.fileId,
              path: element.path,
              examType: element.examType,
              executionDate: element.executionDate,
              executionDate2: element.executionDate,
              uploadDate: element.uploadDate,
              labName: element.labName,
              examId: element.id,
              examName: element.examName,
              laudoFile: element.path,
              url1: element.url,
              idMedicalRecords: element.medicalRecords,
              // position: position,
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
            );
            auxListResult.add(exam);
          }
        }
      }

      // auxListResult.removeWhere((e) => e == examEntity);

      if (auxListResult.contains(examEntity)) {
        listExamEntity.clear();
        currentExamIndexSelected = auxListResult.indexOf(examEntity);
      }

      listExamEntity.addAll(auxListResult);

      if (listExamEntity.length > 1) {
        isValidBottomNavigation = true;
      }

      loadExamBodyContent();
    }
  }

  final _refreshImageNotifier = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    loaded = false;
    _cubit = I.getDependency<ExamCubit>();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tabController?.dispose();
    _cubit.close();
    _pdfController?.dispose();
    imageTime?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ZeraScaffold(
        bottomNavigationBar: AnimatedBuilder(
          animation: isLoadingExamEntityListener,
          builder: (context, widget) => Visibility(
            visible:
                !isLoadingExamEntityListener.value && isValidBottomNavigation,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom:
                      BorderSide(width: 1.0, color: ZeraColors.neutralLight02),
                ),
                boxShadow: const [
                  BoxShadow(
                    offset: Offset(0, -4),
                    blurRadius: 8,
                    color: Color.fromRGBO(27, 28, 29, 0.15),
                  ),
                ],
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ButtonFooterWidget(
                        onTap: () async {
                          if (currentExamIndexSelected > 0) {
                            currentExamIndexSelected--;
                            await loadExamBodyContent();
                          }
                        },
                        text: PREVIOUS.translate(),
                        textColor: currentExamIndexSelected == 0
                            ? ZeraColors.neutralDark03
                            : ZeraColors.neutralDark01,
                        buttonType: ButtonType.iconLeft,
                      ),
                      InkWell(
                        onTap: () {
                          kIsWeb ? showPopupNavigationWeb() : openBottomSheet();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border:
                                Border.all(color: ZeraColors.neutralLight04),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ZeraText(
                            GO_TO_EXAM.translate(),
                            color: ZeraColors.neutralDark01,
                            type: ZeraTextType.SEMIBOLD_TIGHT_12_DARK_01,
                            theme: const ZeraTextTheme(
                                fontSize: 12, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      ButtonFooterWidget(
                        onTap: () async {
                          if (currentExamIndexSelected <
                              (listExamEntity.length - 1)) {
                            currentExamIndexSelected++;
                            await loadExamBodyContent();
                          }
                        },
                        text: NEXT.translate(),
                        textColor: currentExamIndexSelected <
                                (listExamEntity.length - 1)
                            ? ZeraColors.neutralDark01
                            : ZeraColors.neutralDark03,
                        buttonType: ButtonType.iconRight,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        endDrawerEnableOpenDragGesture: false,
        endDrawer: SafeArea(
          child: Container(
            constraints: const BoxConstraints(
              maxWidth: 572,
            ),
            width: double.infinity,
            child: const Drawer(
              child: DoctorExamDetailsPage(),
            ),
          ),
        ),
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: Listenable.merge(
                  [indexListener, isLoadingExamEntityListener]),
              builder: (context, child) {
                if (isLoadingExamEntityListener.value) {
                  return const SizedBox();
                }
                if (((_tabController?.index == evolutiveIndex) &&
                        (evolutiveIndex != null)) &&
                    !kIsWeb) {
                  return SizedBox(
                    height: 64,
                    width: 64,
                    child: FloatingActionButton(
                      backgroundColor: ZeraColors.primaryDarkest,
                      onPressed: () {
                        final List<DeviceOrientation> enumScreen =
                            MediaQuery.of(context).orientation ==
                                    Orientation.landscape
                                ? [DeviceOrientation.portraitUp]
                                : [
                                    DeviceOrientation.landscapeRight,
                                    DeviceOrientation.landscapeLeft,
                                  ];
                        SystemChrome.setPreferredOrientations(enumScreen);
                      },
                      child: Image.asset(
                        PHONE_ROTATE,
                        package: MICRO_APP_PACKAGE_NAME,
                      ),
                    ),
                  );
                }
                if ((_tabController?.index != laudoIndex) ||
                    (laudoIndex == null)) {
                  return const SizedBox();
                }
                return SizedBox(
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
                );
              },
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ResponsiveAppBar(
                    breadCrumbs: kIsWeb
                        ? BreadCrumbs(
                            listBreadCrumbs: [
                              RESULTS_OF_EXAMS.translate(),
                              EXAMS_EINSTEIN.translate(),
                              EXAM_RESULT.translate(),
                            ],
                          )
                        : null,
                    iconColor: ZeraColors.primaryMedium,
                    trailing: [
                      Builder(
                        builder: (context) => InkWell(
                          onTap: () {
                            if (MediaQuery.of(context).size.width < 600) {
                              Navigator.of(context).pushNamed(
                                Routes.doctorExamDetailsPage,
                                arguments: examEntity,
                              );
                            } else {
                              _openEndDrawer(context);
                            }
                          },
                          child: Icon(
                            ZeraIcons.information_circle,
                            color: ZeraColors.primaryMedium,
                          ),
                        ),
                      ),
                      AnimatedBuilder(
                        animation: pdfBase64,
                        builder: (context, child) {
                          if (pdfBase64.value == null) {
                            return const SizedBox();
                          }
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(width: 16),
                              InkWell(
                                onTap: () async {
                                  if (kIsWeb) {
                                    DownloadWebUtils().download(
                                      pdfBase64.value!.toUint8List(),
                                      downloadName: fileName ?? 'laudo.pdf',
                                    );
                                    return;
                                  }

                                  await DownloadMobileUtils().downloadFile(
                                    file64: pdfBase64.value!.toUint8List(),
                                    fileName: fileName,
                                  );
                                },
                                child: Icon(
                                  ZeraIcons.move_down_1,
                                  color: ZeraColors.primaryMedium,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      if (!kIsWeb)
                        AnimatedBuilder(
                          animation: pdfBase64,
                          builder: (context, child) {
                            if (pdfBase64.value == null) {
                              return const SizedBox();
                            }
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(width: 16),
                                InkWell(
                                  onTap: () {
                                    if (kIsWeb) {
                                      return;
                                    }
                                    if (pdfBase64.value == null) {
                                      return;
                                    }
                                    ShareMobileUtils().shareBase64File(
                                      data: pdfBase64.value!.toUint8List(),
                                      fileName: fileName,
                                    );
                                  },
                                  child: Icon(
                                    ZeraIcons.share_1,
                                    color: ZeraColors.primaryMedium,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                    ],
                    bottomChild: [
                      ZeraText(
                        examEntity.examName ?? '',
                        type: ZeraTextType.BOLD_24_NEUTRAL_DARK_BASE,
                      ),
                      const SizedBox(height: 8),
                      ZeraText(
                        examEntity.executionDate.dateInFull(),
                        theme: ZeraTextTheme(
                          fontSize: 12,
                          textColor: ZeraColors.neutralDark02,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const CardPatient(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: BlocConsumer<ExamCubit, ExamState>(
                  bloc: _cubit,
                  listenWhen: (context, state) => state is ExamFailureState,
                  listener: (context, state) async {
                    if (state is ExamFailureState) {}
                  },
                  buildWhen: (context, state) =>
                      state is ExamLoadState ||
                      state is ExamPdfSuccessState ||
                      state is ExamImageSuccessState ||
                      state is ExamFailureState ||
                      state is AllResultExamLoadedState,
                  builder: (context, state) =>
                      state is! AllResultExamLoadedState
                          ? SizedBox(
                              height: MediaQuery.of(context).size.height / 2,
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (tabs.length >= 2) ..._zeraTabBar,
                                (tabs.length >= 2)
                                    ? Expanded(
                                        child: Container(
                                          constraints:
                                              const BoxConstraints.expand(),
                                          color: ZeraColors.neutralLight01,
                                          child: TabBarView(
                                            controller: _tabController,
                                            children: body,
                                          ),
                                        ),
                                      )
                                    : body.isEmpty
                                        ? const Expanded(child: _EmptyPage())
                                        : Expanded(
                                            child: Container(
                                              constraints:
                                                  const BoxConstraints.expand(),
                                              color: ZeraColors.neutralLight02,
                                              child: body[0],
                                            ),
                                          ),
                              ],
                            ),
                ),
              ),
            ],
          ),
        ),
      );
  Widget _getImagePage({
    required String html,
    required String url,
  }) =>
      IFRAMEAdapter().html(
        html: html,
        url: url,
      );

  void showPopupNavigationWeb() {
    showDialog(
      context: context, // ContextUtil().context!
      useSafeArea: true,
      builder: (_) => StatefulBuilder(
        builder: (context, StateSetter setStateModal) => AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          backgroundColor: Colors.white,
          titlePadding: EdgeInsets.zero,
          title: Container(
            constraints: const BoxConstraints(
              maxWidth: 400,
            ),
            width: double.infinity,
            padding:
                const EdgeInsets.only(left: 24, right: 24, top: 32, bottom: 16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: ZeraColors.neutralLight02,
                ),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: ZeraText(
                    OTHER_EXAMS_PERFORMED_ON_THIS_DATE.translate(),
                    type: ZeraTextType.MEDIUM_20_NEUTRAL_DARK,
                    theme: const ZeraTextTheme(
                      fontWeight: FontWeight.w700,
                      fontSize: 20.0,
                      fontStyle: FontStyle.normal,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: InkWell(
                    splashColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const Icon(
                      ZeraIcons.close,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          content: Container(
            constraints: const BoxConstraints(
              maxWidth: 400,
            ),
            width: double.infinity,
            color: Colors.white,
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: listExamEntity.length,
              primary: false,
              itemBuilder: (ctx, index) {
                final currentExamEntity = listExamEntity[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    if (currentExamIndexSelected != index) {
                      currentExamIndexSelected = index;
                      loadExamBodyContent();
                    }
                  },
                  child: ListTile(
                    title: ZeraText(
                      currentExamEntity.examName,
                      color: ZeraColors.neutralDark01,
                      type: ZeraTextType.REGULAR_TIGHT_16_DARK,
                    ),
                    trailing: Icon(
                      ZeraIcons.arrow_right_1,
                      size: 14,
                      color: ZeraColors.neutralDark01,
                    ),
                  ),
                );
              },
              separatorBuilder: (_, __) => ZeraDivider(),
            ),
          ),
          actionsPadding: EdgeInsets.zero,
        ),
      ),
    );
  }

  void openBottomSheet() {
    Navigator.of(context).push<void>(
      ZeraBottomSheet<void>(
        color: Colors.white,
        tittle: ZeraText(
          OTHER_EXAMS_PERFORMED_ON_THIS_DATE.translate(),
          type: ZeraTextType.BOLD_MEDIUM_16_DARK_01,
          textAlign: TextAlign.center,
        ),
        bodyPadding: const EdgeInsets.fromLTRB(30, 16, 30, 16),
        // bodyMargin: const EdgeInsets.only(bottom: 16),
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: listExamEntity.length,
          primary: false,
          itemBuilder: (ctx, index) {
            final currentExamEntity = listExamEntity[index];
            return GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
                if (currentExamIndexSelected != index) {
                  currentExamIndexSelected = index;
                  loadExamBodyContent();
                }
              },
              child: ListTile(
                title: ZeraText(
                  currentExamEntity.examName,
                  color: ZeraColors.neutralDark01,
                  type: ZeraTextType.REGULAR_TIGHT_16_DARK,
                ),
                trailing: Icon(
                  ZeraIcons.arrow_right_1,
                  size: 14,
                  color: ZeraColors.neutralDark01,
                ),
              ),
            );
          },
          separatorBuilder: (_, __) => ZeraDivider(),
        ),
      ),
    );
  }
}

class _EmptyPage extends StatelessWidget {
  const _EmptyPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        color: ZeraColors.neutralLight02,
        child: Center(
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(height: 40),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            FEEDBACK_IMG,
                            package: MICRO_APP_PACKAGE_NAME,
                            height: context.isMobile() ? 160 : 240,
                          ),
                          SizedBox(
                            height: context.isMobile() ? 24 : 40,
                          ),
                          ZeraText(
                            WAITING_FOR_THE_RESULT_TO_BE_RELEASED.translate(),
                            type: ZeraTextType.BOLD_MEDIUM_16_DARK_01,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                          left: 16,
                          right: 16,
                          bottom: 40,
                        ),
                        constraints: const BoxConstraints(
                          maxWidth: 343,
                        ),
                        height: 48,
                        child: ZeraButton(
                          onPressed: () {
                            Navigator.of(
                              context,
                            ).pop();
                          },
                          text: COME_BACK.translate(),
                          style: ZeraButtonStyle.PRIMARY_DARK,
                          theme: ZeraButtonTheme(
                            fontSize: 16,
                            minWidth: 300,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
