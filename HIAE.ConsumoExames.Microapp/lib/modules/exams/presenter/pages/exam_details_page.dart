import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:base_dependencies/dependencies.dart';

import '../../../../core/constants/parameters_constants.dart';
import '../../../../core/constants/routes.dart';
import '../../../../core/constants/strings.dart';
import '../../../../core/di/initInjector.dart';
import '../../../../core/extensions/mobile_size_extension.dart';
import '../../../../core/extensions/translate_extension.dart';
import '../../../../core/utils/functions_utils.dart';
import '../../../../core/utils/local_storage_utils.dart';
import '../../../../core/widgets/responsive_app_bar.dart';
import '../../domain/entities/exam_entity.dart';
import '../../domain/entities/radiation_history_param_entity.dart';
import '../cubits/exam_cubit.dart';

class ExamDetailsPage extends StatefulWidget {
  const ExamDetailsPage({Key? key}) : super(key: key);

  @override
  State<ExamDetailsPage> createState() => _ExamDetailsPageState();
}

class _ExamDetailsPageState extends State<ExamDetailsPage> {
  late bool loaded;
  late ExamEntity examEntity;
  late ExamCubit _cubit;
  final hasRadiationHistory = ValueNotifier<bool>(false);
  @override
  void initState() {
    super.initState();
    loaded = false;
    _cubit = I.getDependency<ExamCubit>();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (!loaded) {
      loaded = true;
      examEntity = ModalRoute.of(context)?.settings.arguments as ExamEntity;
      final radiationHistoryParam = RadiationHistoryParamEntity(
        examCode: examEntity.examCode ?? '',
        medicalAppointment: int.tryParse(getUserIdentifier()) ?? 0,
        examGroup: null,
      );
      final radiationHistoryList = await _cubit.getRadiationHistory(
        radiationHistoryParamEntity: radiationHistoryParam,
      );
      hasRadiationHistory.value = radiationHistoryList?.isNotEmpty ?? false;
    }
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ZeraScaffold(
        body: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverFillRemaining(
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
                          // breadCrumbs: kIsWeb
                          //     ? BreadCrumbs(
                          //         listBreadCrumbs: [
                          //           RESULTS_OF_EXAMS.translate(),
                          //           EXAMS_EINSTEIN.translate(),
                          //           EXAM_RESULT.translate(),
                          //           EXAM_DETAILS.translate(),
                          //         ],
                          //       )
                          //     : null,
                          iconColor: ZeraColors.primaryMedium,
                          bottomChild: [
                            ZeraText(
                              EXAM_DETAILS.translate(),
                              type: ZeraTextType.BOLD_24_NEUTRAL_DARK_BASE,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 36),
                    Center(
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: context.isMobile() ? 1200 : 1232,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ZeraDivider(),
                            _ExamItemDetailWidget(
                              title: PASSAGE.translate(),
                              description: getPassageById(examEntity.passType),
                              // INTERNAL.translate() =1
                              //  EXTERNAL.translate()= 2
                              //  EMERGENCY_SERVICE.translate() = 3
                            ),
                            ZeraDivider(),
                            _ExamItemDetailWidget(
                              title: CATEGORY.translate(),
                              description: examEntity.examType == 1
                                  ? LABORATORY_EXAM.translate()
                                  : DIAGNOSTIC_IMAGE.translate(),
                            ),
                            ZeraDivider(),
                            _ExamItemDetailWidget(
                              title: UNIT.translate(),
                              description: examEntity.place ?? '-',
                            ),
                            ZeraDivider(),
                          ],
                        ),
                      ),
                    ),
                    AnimatedBuilder(
                      animation: hasRadiationHistory,
                      builder: (context, child) {
                        if (!hasRadiationHistory.value) return const SizedBox();
                        return Expanded(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 40.0),
                              child: InkWell(
                                splashColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                    Routes.radiationExposureHistoryPage,
                                    arguments: examEntity,
                                  );
                                },
                                child: ZeraText(
                                  VIEW_RADIATION_EXPOSURE_HISTORY.translate(),
                                  theme: ZeraTextTheme(
                                    fontFamily: fontFamilyName,
                                    fontWeight: FontWeight.w700,
                                    textColor: ZeraColors.primaryDark,
                                    fontSize: 14,
                                    lineHeight: 1.5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}

class _ExamItemDetailWidget extends StatelessWidget {
  final String title;
  final String description;
  final bool hasRadiationHistory;
  const _ExamItemDetailWidget({
    Key? key,
    required this.title,
    required this.description,
    this.hasRadiationHistory = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ZeraText(
              title,
              theme: ZeraTextTheme(
                fontFamily: fontFamilyName,
                fontWeight: FontWeight.w600,
                textColor: ZeraColors.neutralDark02,
                fontSize: 12,
                lineHeight: 1.5,
              ),
            ),
            ZeraText(
              description,
              theme: ZeraTextTheme(
                fontFamily: fontFamilyName,
                fontWeight: FontWeight.w700,
                textColor: ZeraColors.neutralDark01,
                fontSize: 14,
                lineHeight: 1.5,
              ),
            ),
            if (hasRadiationHistory) const SizedBox(height: 8),
            if (hasRadiationHistory)
              InkWell(
                splashColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  Navigator.of(context).pushNamed(
                    Routes.radiationExposureHistoryPage,
                  );
                },
                child: ZeraText(
                  VIEW_RADIATION_EXPOSURE_HISTORY.translate(),
                  theme: ZeraTextTheme(
                    fontFamily: fontFamilyName,
                    fontWeight: FontWeight.w700,
                    textColor: ZeraColors.primaryMedium,
                    decoration: TextDecoration.underline,
                    fontSize: 14,
                    lineHeight: 1.5,
                  ),
                ),
              ),
          ],
        ),
      );
}
