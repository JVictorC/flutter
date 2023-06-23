import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:base_dependencies/dependencies.dart';

import '../../../../core/constants/assets_constants.dart';
import '../../../../core/constants/strings.dart';
import '../../../../core/di/initInjector.dart';
import '../../../../core/entities/user_auth_info.dart';
import '../../../../core/extensions/mobile_size_extension.dart';
import '../../../../core/extensions/translate_extension.dart';
import '../../../../core/widgets/bread_crumbs.dart';
import '../../../../core/widgets/header_expansion_tile.dart';
import '../../../../core/widgets/responsive_app_bar.dart';
import '../../domain/entities/evolutionary_report_response_entity.dart';
import '../cubits/exam_cubit.dart';
import '../widgets/card_patient.dart';
import '../widgets/evolutionary_report_table.dart';

class EvolutionaryReportResultPatient extends StatefulWidget {
  const EvolutionaryReportResultPatient({
    Key? key,
  }) : super(key: key);

  @override
  State<EvolutionaryReportResultPatient> createState() =>
      _EvolutionaryReportResultPatientState();
}

class _EvolutionaryReportResultPatientState
    extends State<EvolutionaryReportResultPatient> {
  late final ExamCubit _cubit;
  bool loaded = false;
  late final EvolutionaryReportExamsEntity _evolutionaryReports;
  bool expanded = false;
  int selectedIndex = -1;
  late bool ambientDoctor;

  @override
  void initState() {
    _cubit = I.getDependency<ExamCubit>();
    ambientDoctor = I.getDependency<UserAuthInfoEntity>().userType == 'Doctor';

    super.initState();
  }

  @override
  void dispose() {
    _cubit.close();
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ],
    );
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (!loaded) {
      loaded = true;

      setState(() {
        _evolutionaryReports = ModalRoute.of(context)?.settings.arguments
            as EvolutionaryReportExamsEntity;
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) => ZeraScaffold(
        floatingActionButton: Visibility(
          visible: !kIsWeb,
          child: FloatingActionButton(
            onPressed: () {
              var isPortrait =
                  MediaQuery.of(context).orientation == Orientation.portrait;

              if (isPortrait) {
                SystemChrome.setPreferredOrientations(
                  [DeviceOrientation.landscapeLeft],
                );
              } else {
                SystemChrome.setPreferredOrientations(
                  [
                    DeviceOrientation.portraitUp,
                  ],
                );
              }
            },
            child: Image.asset(
              ROTATE_PHONE,
              package: MICRO_APP_PACKAGE_NAME,
            ),
            backgroundColor: ZeraColors.primaryDarkest,
          ),
        ),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 1200,
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 21.31,
                  right: 21.31,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: context.isTablet() ? 16 : 0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Visibility(
                            visible: kIsWeb,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 16,
                                bottom: 2,
                              ),
                              child: BreadCrumbs(
                                listBreadCrumbs: [
                                  EXAM_RESULTS.translate(),
                                  MY_EXAMS.translate(),
                                  EVOLUTIONARY_REPORT2.translate(),
                                ],
                              ),
                            ),
                          ),
                          const ResponsiveAppBar(),
                          const SizedBox(
                            height: 16.75,
                          ),
                          ZeraText(
                            EVOLUTIONARY_REPORT2.translate(),
                            color: ZeraColors.neutralDark,
                            theme: const ZeraTextTheme(
                              fontSize: 24.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const CardPatient(
                      paddingTop: 40,
                    ),
                    const SizedBox(
                      height: 28.0,
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                        top: 11,
                        bottom: 11,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: ZeraColors.neutralLight03,
                        ),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ZeraText(
                              '${SUBTITLE.translate()}:',
                              color: ZeraColors.neutralDark01,
                              theme: const ZeraTextTheme(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 8, left: 16),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: ZeraColors.criticalColorDark,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                width: 8,
                                height: 8,
                              ),
                            ),
                            ZeraText(
                              OUT_OF_REFERENCE_VALUE.translate(),
                              color: ZeraColors.criticalColorDark,
                              theme: const ZeraTextTheme(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.only(bottom: 10),
                        physics: const ScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () {
                                  expanded = !expanded;
                                  setState(() {});
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      expanded
                                          ? ZeraIcons.view_off
                                          : ZeraIcons.view_1,
                                      color: ZeraColors.primaryDark,
                                      size: 18,
                                    ),
                                    const SizedBox(
                                      width: 8.5,
                                    ),
                                    ZeraText(
                                      expanded
                                          ? CLOSE_ALL_TABLES.translate()
                                          : VIEW_ALL_TABLES.translate(),
                                      color: ZeraColors.primaryDark,
                                      theme: const ZeraTextTheme(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            ZeraDivider(),
                            ListView.builder(
                              key: const Key('selected'),
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount:
                                  _evolutionaryReports.examsConsultation.length,
                              itemBuilder: (context, index) => Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: ZeraColors.neutralLight03,
                                    ),
                                  ),
                                ),
                                child: HeaderExpansionTile(
                                  subTitleTop: true,
                                  subTitle: _evolutionaryReports
                                      .examsConsultation[index].groupName,
                                  maintainState: true,
                                  showIconTrailing: true,
                                  initiallyExpanded: expanded,
                                  globalKey: GlobalKey(
                                    debugLabel: index.toString(),
                                  ),
                                  title: _evolutionaryReports
                                      .examsConsultation[index].description,
                                  body: [
                                    Visibility(
                                      visible: _evolutionaryReports
                                          .examsConsultation[index]
                                          .itensConsultation
                                          .isEmpty,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          top: 10,
                                          bottom: 10,
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              ZeraIcons.information_circle,
                                              color:
                                                  ZeraColors.criticalColorDark,
                                            ),
                                            const SizedBox(
                                              width: 8.5,
                                            ),
                                            Expanded(
                                              child: ZeraText(
                                                EVOLUTIONARY_TABLE_EMPTY
                                                    .translate(),
                                                color: ZeraColors
                                                    .criticalColorDark,
                                                theme: const ZeraTextTheme(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: _evolutionaryReports
                                          .examsConsultation[index]
                                          .itensConsultation
                                          .isNotEmpty,
                                      child: Container(
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.only(
                                          left: 20,
                                          top: 40,
                                          right: 5,
                                        ),
                                        color: ZeraColors.neutralLight02,
                                        child: EvolutionaryReportTable(
                                          examsConsultation:
                                              _evolutionaryReports
                                                  .examsConsultation[index],
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
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
