import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:base_dependencies/dependencies.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/assets_constants.dart';
import '../../../../core/constants/strings.dart';
import '../../../../core/di/initInjector.dart';
import '../../../../core/extensions/date_time_extension.dart';
import '../../../../core/extensions/string_extension.dart';
import '../../../../core/extensions/translate_extension.dart';
import '../../../../core/mock/note_radiological_record_mock.dart';
import '../../../../core/mock/radiology_2008_metter_mock.dart';
import '../../../../core/utils/download_mobile_utils.dart';
import '../../../../core/utils/download_web_utils.dart';
import '../../../../core/utils/local_storage_utils.dart';
import '../../../../core/utils/open_url.dart';
import '../../../../core/widgets/bread_crumbs.dart';
import '../../../../core/widgets/responsive_app_bar.dart';
import '../../domain/entities/radiation_history_entity.dart';
import '../../domain/entities/radiation_history_param_entity.dart';
import '../cubits/exam_cubit.dart';
import '../cubits/exam_state_cubit.dart';
import '../widgets/card_bottom_information_widget.dart';
import '../widgets/card_patient.dart';
import '../widgets/header_expansion_tile_widget.dart';
import '../widgets/radiology_information_widget.dart';

class DoctorRadiationExposureHistoryPage extends StatefulWidget {
  const DoctorRadiationExposureHistoryPage({Key? key}) : super(key: key);

  @override
  State<DoctorRadiationExposureHistoryPage> createState() =>
      _DoctorRadiationExposureHistoryPageState();
}

class _DoctorRadiationExposureHistoryPageState
    extends State<DoctorRadiationExposureHistoryPage> {
  late bool loaded;
  late ExamCubit _cubit;

  @override
  void initState() {
    super.initState();
    loaded = false;
    _cubit = I.getDependency<ExamCubit>();
  }

  Map<String, List<RadiationHistoryEntity>> radiationHistoryMap = {};
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (!loaded) {
      loaded = true;
      final radiationHistoryParam = RadiationHistoryParamEntity(
        examCode: null,
        medicalAppointment: int.tryParse(getIdPatient()) ?? 0,
        examGroup: null,
      );
      final radiationHistoryList = await _cubit.getRadiationHistory(
        radiationHistoryParamEntity: radiationHistoryParam,
      );
      for (int i = 0; i < ((radiationHistoryList?.length ?? 0)); i++) {
        final RadiationHistoryEntity e = radiationHistoryList![i];

        radiationHistoryMap[e.groupDescriptionExam] = [
          ...?radiationHistoryMap[e.groupDescriptionExam],
          e,
        ];
      }
    }
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
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
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                fillOverscroll: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
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
                                    EXAM_DETAILS.translate(),
                                    RADIATION_EXPOSURE_HISTORY.translate(),
                                  ],
                                )
                              : null,
                          iconColor: ZeraColors.primaryMedium,
                          bottomChild: [
                            ZeraText(
                              RADIATION_EXPOSURE_HISTORY.translate(),
                              type: ZeraTextType.BOLD_24_NEUTRAL_DARK_BASE,
                            ),
                            const SizedBox(height: 12),
                            const CardPatient(),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Expanded(
                      child: BlocConsumer<ExamCubit, ExamState>(
                        bloc: _cubit,
                        listenWhen: (context, state) =>
                            state is ExamFailureState,
                        listener: (context, state) async {
                          if (state is ExamFailureState) {}
                        },
                        buildWhen: (context, state) =>
                            state is ExamLoadState ||
                            state is RadiationHistorySuccessState ||
                            state is ExamFailureState,
                        builder: (context, state) {
                          if (state is ExamLoadState) {
                            return const Center(
                              child: Center(child: CircularProgressIndicator()),
                            );
                          } else if (state is RadiationHistorySuccessState) {
                            return Column(
                              children: [
                                Center(
                                  child: Container(
                                    constraints:
                                        const BoxConstraints(maxWidth: 1232),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    alignment: Alignment.centerLeft,
                                    child: ZeraText(
                                      TRACK_THE_HISTORY_OF_IMAGING_TESTS_RADIATION
                                          .translate(),
                                      color: ZeraColors.neutralDark01,
                                      theme: const ZeraTextTheme(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        lineHeight: 1.5,
                                      ),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Container(
                                    constraints:
                                        const BoxConstraints(maxWidth: 1200),
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 40),
                                        ZeraDivider(),
                                        ...radiationHistoryMap.entries.map(
                                          (e) {
                                            if (true) {
                                              print('teste');
                                              // e.examCod
                                            }
                                            return Column(
                                              children: [
                                                HeaderExpansionTileWidget(
                                                  iconPadding:
                                                      const EdgeInsets.only(
                                                    right: 16,
                                                  ),
                                                  titlePadding:
                                                      const EdgeInsets.only(
                                                    left: 16,
                                                  ),
                                                  childrenPadding:
                                                      const EdgeInsets.only(
                                                    top: 8,
                                                    bottom: 20,
                                                    left: 16,
                                                    right: 16,
                                                  ),
                                                  fontSize: 16.0,
                                                  showIconTrailing: true,
                                                  initiallyExpanded: false,
                                                  // title: RADIOLOGY + ' (1)',
                                                  title: e.key +
                                                      ' (${e.value[0].examCod == null ? 0 : e.value.length})',
                                                  body: e.value
                                                      .map<Widget>(
                                                        (e) => Column(
                                                          children: [
                                                            RadiologyInformationWidget(
                                                              hasInformation:
                                                                  e.examCod !=
                                                                      null,
                                                              title: e.examDescription +
                                                                  ' (${e.examCod})',
                                                              description:
                                                                  'Realizado em ${e.itemLaunchDate.toPtDate()} • Quantidade: 1 • Exp. à radiação ${e.radiationUnity}',
                                                            ),
                                                            const SizedBox(
                                                              height: 20,
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                      .toList(),
                                                ),
                                                ZeraDivider(),
                                              ],
                                            );
                                          },
                                        ),
                                        const SizedBox(height: 40),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                          return const EmptyPage();
                        },
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      color: ZeraColors.neutralLight01,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.only(
                            left: 16,
                            right: 16,
                            bottom: 40,
                          ),
                          constraints: const BoxConstraints(maxWidth: 1232),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 40),
                              ZeraText(
                                'Saiba mais',
                                color: ZeraColors.neutralDark,
                                theme: const ZeraTextTheme(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  lineHeight: 1.5,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Builder(
                                builder: (context) {
                                  final List<Widget> children = [
                                    CardBottomInformationWidget(
                                      description: 'Radiology 2008 Metter',
                                      onTap: () async {
                                        await downloadBase64(
                                          fileBase64:
                                              RADIOLOGY_2008_METTER_MOCK,
                                          fileName: 'Radiology2008Metter.pdf',
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 8, width: 16),
                                    CardBottomInformationWidget(
                                      description:
                                          'Nota unidades de dose registradas no prontuário eletrônico radiológico',
                                      onTap: () async {
                                        await downloadBase64(
                                          fileBase64:
                                              NOTE_RADIOLOGICAL_RECORD_PDF_MOCK,
                                          fileName: 'NotaUnidades.pdf',
                                        );
                                      },
                                    ),
                                  ];
                                  return MediaQuery.of(context).size.width > 750
                                      ? SizedBox(
                                          height: 102,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: children,
                                          ),
                                        )
                                      : Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            ...children,
                                          ],
                                        );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
  Future<void> downloadBase64({
    required String fileBase64,
    required String fileName,
  }) async {
    if (kIsWeb) {
      // web download
      DownloadWebUtils().download(
        fileBase64.toUint8List(),
        downloadName: fileName,
      );
      return;
    }
    // mobile download
    await DownloadMobileUtils().downloadFile(
      file64: fileBase64.toUint8List(),
      fileName: fileName,
    );
  }
}

class EmptyPage extends StatelessWidget {
  const EmptyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              ERROR_IMG,
              package: MICRO_APP_PACKAGE_NAME,
            ),
            const SizedBox(
              height: 44,
            ),
            SizedBox(
              child: ZeraText(
                ERROR_MSG_HEADER.translate(),
                color: ZeraColors.neutralDark01,
                theme: const ZeraTextTheme(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(
              child: ZeraText(
                ERROR_MSG_DETAILS.translate(),
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
      );
}
