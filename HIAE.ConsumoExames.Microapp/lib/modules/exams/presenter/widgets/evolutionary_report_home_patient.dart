import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:base_dependencies/dependencies.dart';

import '../../../../core/constants/assets_constants.dart';
import '../../../../core/constants/routes.dart';
import '../../../../core/constants/strings.dart';
import '../../../../core/di/initInjector.dart';
import '../../../../core/extensions/mobile_size_extension.dart';
import '../../../../core/extensions/translate_extension.dart';
import '../../../../core/widgets/bread_crumbs.dart';
import '../../../../core/widgets/responsive_app_bar.dart';
import '../cubits/exam_cubit.dart';

class EvolutionaryReportHomePatient extends StatelessWidget {
  const EvolutionaryReportHomePatient({Key? key}) : super(key: key);

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

  @override
  Widget build(BuildContext context) => SafeArea(
        child: ZeraScaffold(
          bottomNavigationBar: Padding(
            padding: EdgeInsets.only(
              top: 30,
              bottom: 30,
              left: _getPadding(context),
              right: _getPadding(context),
            ),
            child: ZeraButton(
              onPressed: () {
                final ExamCubit cubit = I.getDependency<ExamCubit>();

                cubit.setFirstOpenEvolutionaryReport();

                Navigator.of(context).pushReplacementNamed(
                  Routes.evolutionaryReportGroupsExams,
                );
              },
              text: START.translate(),
            ),
          ),
          body: Center(
            child: Container(
              constraints: const BoxConstraints(
                maxWidth: 1200,
              ),
              padding: EdgeInsets.only(
                left: context.isDevice() ? 16 : 0,
                right: context.isDevice() ? 16 : 0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Visibility(
                    visible: kIsWeb,
                    child: Align(
                      alignment: Alignment.centerLeft,
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
                  ),
                  const ResponsiveAppBar(),
                  const SizedBox(
                    height: 16.75,
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: ZeraText(
                        EVOLUTIONARY_REPORT2.translate(),
                        color: ZeraColors.neutralDark,
                        theme: const ZeraTextTheme(
                          fontSize: 24.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            EVOLUTIONARY_REPORT_IMG,
                            package: MICRO_APP_PACKAGE_NAME,
                          ),
                          const SizedBox(
                            height: 44,
                          ),
                          SizedBox(
                            width: 240,
                            child: ZeraText(
                              KEEP_TRACK_OF_YOUR_HISTORY_LAB_EXAMS.translate(),
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
                            width: 360,
                            child: ZeraText(
                              EASILY_VIEW_EXAM_HISTORY_SHARE_RESULTS
                                  .translate(),
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
                ],
              ),
            ),
          ),
        ),
      );
}
