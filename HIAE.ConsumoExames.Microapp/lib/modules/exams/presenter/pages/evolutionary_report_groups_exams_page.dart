import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:base_dependencies/dependencies.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/assets_constants.dart';
import '../../../../core/constants/parameters_constants.dart';
import '../../../../core/constants/routes.dart';
import '../../../../core/constants/strings.dart';
import '../../../../core/di/initInjector.dart';
import '../../../../core/exceptions/exceptions.dart';
import '../../../../core/extensions/mobile_size_extension.dart';
import '../../../../core/extensions/translate_extension.dart';
import '../../../../core/utils/show_loading_dialog.dart';
import '../../../../core/widgets/bread_crumbs.dart';
import '../../../../core/widgets/header_expansion_tile.dart';
import '../../../../core/widgets/responsive_app_bar.dart';
import '../../domain/entities/exams_medical_records_entity.dart';
import '../cubits/exam_cubit.dart';
import '../cubits/exam_state_cubit.dart';
import '../widgets/card_patient.dart';
import '../widgets/selected_list_exams_report_group.dart';

class EvolutionaryReportGroupsExamsPage extends StatefulWidget {
  const EvolutionaryReportGroupsExamsPage({Key? key}) : super(key: key);

  @override
  State<EvolutionaryReportGroupsExamsPage> createState() =>
      _EvolutionaryReportGroupsExamsPageState();
}

class _EvolutionaryReportGroupsExamsPageState
    extends State<EvolutionaryReportGroupsExamsPage> {
  late final ExamCubit _cubit;
  late Future getExams;
  final Map<String, List<String>> mapExamCode = {};
  late final Map<String, List<ExamsMedicalRecordsEntity>> dataExams = {};
  late final TextEditingController _controller;

  String? filter;

  Future<void> loadData() async {
    await _cubit.getExamsGroup();
  }

  @override
  void initState() {
    _cubit = I.getDependency<ExamCubit>();
    _controller = TextEditingController();
    loadData();
    super.initState();
  }

  @override
  void dispose() {
    _cubit.close();
    _controller.dispose();
    super.dispose();
  }

  double _getPadding(BuildContext context) {
    final size = MediaQuery.of(context).size.width;

    double value = 0;
    if (kIsWeb) {
      if (size <= 800) {
        value = 10;
      } else if (size >= 1000) {
        if (size >= 1700) {
          value = 750;
        } else if (size < 1500) {
          value = 400;
        } else {
          value = 550;
        }
      } else {
        value = 200;
      }
    } else if (context.isTablet()) {
      value = 150;
    } else {
      value = 30;
    }

    if (value <= 0) {
      value = 10;
    }

    return value;
  }

  Widget _buttonEvolutionary() => BlocBuilder<ExamCubit, ExamState>(
        bloc: _cubit,
        buildWhen: (context, state) => state is StatusButton,
        builder: (context, state) => Padding(
          padding: EdgeInsets.only(
            bottom: 20,
            left: _getPadding(context),
            right: _getPadding(context),
          ),
          child: ZeraButton(
            enabled: state is StatusButton ? state.status : false,
            text: SEE_EVOLUTIONARY_REPORT.translate(),
            onPressed: () async {
              await showLoadingDialog(
                title: LOADING_THE_EVOLUTIONARY_REPORT.translate(),
                context: context,
                action: () async {
                  await _cubit.getMapEvolutionaryReportExams(
                    mapExams: mapExamCode,
                  );
                },
              );
            },
          ),
        ),
      );

  @override
  Widget build(BuildContext context) => SafeArea(
        child: ZeraScaffold(
          bottomNavigationBar: _buttonEvolutionary(),
          body: BlocConsumer<ExamCubit, ExamState>(
            bloc: _cubit,
            buildWhen: (context, state) =>
                state is ExamLoadState ||
                state is ExamGroup ||
                state is ExamFailureEmptyGroupExam,
            listenWhen: (context, state) =>
                state is GetEvolutionaryReportExamsState ||
                state is ExamFailureState,
            listener: (context, state) async {
              if (state is GetEvolutionaryReportExamsState) {
                final data = state.evolutionaryReportExams;
                Navigator.of(context).pushNamed(
                  Routes.evolutionaryReportResultPatient,
                  arguments: data,
                );
              } else if (state is ExamFailureState) {
                if (state.failure is HttpNoContent) {
                  await showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: Text(WARNING.translate()),
                      content: Text(
                        state.failure.message,
                      ),
                      actions: <Widget>[
                        ZeraButton(
                          text: CLOSE.translate(),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  );
                } else if (state.failure is NoInternetConnectionFailure) {
                  final refresh = await Navigator.of(context).pushNamed(
                    Routes.failedConnectionPage,
                    arguments: EVOLUTIONARY_REPORT2.translate(),
                  ) as bool?;

                  if (refresh == true) {
                    await loadData();
                    //Navigator.of(context).pop();
                  } else {
                    Navigator.of(context).pop();
                  }
                } else {
                  await Navigator.of(context).popAndPushNamed(
                    Routes.errorPage,
                    arguments: EVOLUTIONARY_REPORT2.translate(),
                  );
                }
              }
            },
            builder: (context, state) {
              if (state is ExamLoadState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is ExamGroup) {
                if (dataExams.isEmpty) {
                  dataExams.addAll(state.examData);
                }

                return Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 1200,
                    ),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 16,
                          right: 16,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
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
                            CardPatient(
                              onTap: () => Navigator.of(
                                context,
                                rootNavigator: true,
                              ).pop(),
                              paddingTop: 40,
                            ),
                            const SizedBox(
                              height: 36,
                            ),
                            ZeraText(
                              SELECT_EXAMS.translate(),
                              color: ZeraColors.neutralDark01,
                              theme: const ZeraTextTheme(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 40,
                                    child: TextField(
                                      controller: _controller,
                                      onChanged: (value) {
                                        _cubit.filterExamsEvolutionaryReport(
                                          filter: value.trim(),
                                          data: dataExams,
                                        );
                                      },
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.left,
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          ZeraIcons.search,
                                          color: ZeraColors.primaryMedium,
                                          size: 19.0,
                                        ),
                                        contentPadding: const EdgeInsets.all(0),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(48.0),
                                          borderSide: BorderSide(
                                            width: 1,
                                            color: ZeraColors.neutralLight02,
                                          ),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(48.0),
                                          borderSide: BorderSide(
                                            width: 1,
                                            color: ZeraColors.neutralLight02,
                                          ),
                                        ),
                                        // filled: true,
                                        hintStyle: TextStyle(
                                          color: ZeraColors.neutralDark02,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: fontFamilyName,
                                        ),
                                        hintText: SEARCH_EXAMS.translate(),
                                        fillColor: ZeraColors.neutralLight,
                                      ),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: _controller.text.trim().isNotEmpty,
                                  child: IconButton(
                                    onPressed: () {
                                      _controller.clear();
                                      _cubit.filterExamsEvolutionaryReport(
                                        filter: null,
                                        data: dataExams,
                                      );
                                    },
                                    icon: const Icon(
                                      ZeraIcons.remove_circle,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            Visibility(
                              visible: _controller.text.trim().isNotEmpty &&
                                  dataExams.isNotEmpty &&
                                  state.examData.isEmpty,
                              child: SizedBox(
                                height: MediaQuery.of(context).size.height / 2 +
                                    100,
                                child: Center(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      FittedBox(
                                        fit: BoxFit.cover,
                                        child: Image.asset(
                                          FEEDBACK_IMG,
                                          package: MICRO_APP_PACKAGE_NAME,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 24,
                                      ),
                                      SizedBox(
                                        width: 350,
                                        child: ZeraText(
                                          EMPTY_PAGE_MSG.translate(),
                                          theme: const ZeraTextTheme(
                                            textAlign: TextAlign.center,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 30),
                                        child: ZeraText(
                                          TRY_AGAIN_USING_OTHERS_TERMS
                                              .translate(),
                                          theme: const ZeraTextTheme(
                                            textAlign: TextAlign.center,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: state.examData.isNotEmpty,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  ZeraDivider(),
                                  ListView.separated(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    separatorBuilder: (context, index) =>
                                        ZeraDivider(),
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount: state.examData.length,
                                    itemBuilder:
                                        (BuildContext context, int index) =>
                                            HeaderExpansionTile(
                                      maintainState: true,
                                      showIconTrailing: true,
                                      title:
                                          state.examData.keys.elementAt(index),
                                      body: [
                                        SelectedListExamsReportGroup(
                                          groupName: state.examData.keys
                                              .elementAt(index),
                                          cubit: _cubit,
                                          mapExamCode: mapExamCode,
                                          listExams: state.examData.values
                                              .elementAt(index),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ZeraDivider(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              } else if (state is ExamFailureEmptyGroupExam) {
                return Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 1200,
                    ),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 16,
                          right: 16,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
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
                            CardPatient(
                              onTap: () => Navigator.of(
                                context,
                                rootNavigator: true,
                              ).pop(),
                              paddingTop: 40,
                            ),
                            const SizedBox(
                              height: 36,
                            ),
                            ZeraText(
                              SELECT_EXAMS.translate(),
                              color: ZeraColors.neutralDark01,
                              theme: const ZeraTextTheme(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 40,
                                    child: TextField(
                                      controller: _controller,
                                      onChanged: (value) {
                                        _cubit.filterExamsEvolutionaryReport(
                                          filter: value.trim(),
                                          data: dataExams,
                                        );
                                      },
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.left,
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          ZeraIcons.search,
                                          color: ZeraColors.primaryMedium,
                                          size: 19.0,
                                        ),
                                        contentPadding: const EdgeInsets.all(0),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(48.0),
                                          borderSide: BorderSide(
                                            width: 1,
                                            color: ZeraColors.neutralLight02,
                                          ),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(48.0),
                                          borderSide: BorderSide(
                                            width: 1,
                                            color: ZeraColors.neutralLight02,
                                          ),
                                        ),
                                        // filled: true,
                                        hintStyle: TextStyle(
                                          color: ZeraColors.neutralDark02,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: fontFamilyName,
                                        ),
                                        hintText: SEARCH_EXAMS.translate(),
                                        fillColor: ZeraColors.neutralLight,
                                      ),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: _controller.text.trim().isNotEmpty,
                                  child: IconButton(
                                    onPressed: () {
                                      _controller.clear();
                                      _cubit.filterExamsEvolutionaryReport(
                                        filter: null,
                                        data: dataExams,
                                      );
                                    },
                                    icon: const Icon(
                                      ZeraIcons.remove_circle,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
        ),
      );
}
