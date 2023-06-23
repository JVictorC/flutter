library micro_exam_consumption;

import 'package:base_dependencies/dependencies.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/constants/routes.dart';
import 'core/di/initInjector.dart';
import 'core/entities/user_auth_info.dart';
import 'core/navigator/navigator_observer.dart';
import 'core/pages/failed_connection_internet_page.dart';
import 'core/pages/failed_page.dart';
import 'core/singletons/context_key.dart';
import 'core/utils/local_storage_utils.dart';
import 'core/widgets/error_page.dart';
import 'modules/exams/presenter/pages/doctor_exam_details_page.dart';
import 'modules/exams/presenter/pages/doctor_list_exams_page.dart';
import 'modules/exams/presenter/pages/doctor_radiation_exposure_history_page.dart';
import 'modules/exams/presenter/pages/doctor_result_exams_page.dart';
import 'modules/exams/presenter/pages/downloads_exam_page.dart';
import 'modules/exams/presenter/pages/empty_filter_page.dart';
import 'modules/exams/presenter/pages/evolutionary_report_groups_exams_page.dart';
import 'modules/exams/presenter/pages/evolutionary_report_result_patient.dart';
import 'modules/exams/presenter/pages/exam_details_page.dart';
import 'modules/exams/presenter/pages/filter_doctor_exam_page.dart';
import 'modules/exams/presenter/pages/filter_exam_page.dart';
import 'modules/exams/presenter/pages/list_exams_page.dart';
import 'modules/exams/presenter/pages/onboarding_page.dart';
import 'modules/exams/presenter/pages/radiation_exposure_history_page.dart';
import 'modules/exams/presenter/pages/result_exams_page.dart';
import 'modules/exams/presenter/pages/upload_exams_page.dart';
import 'modules/exams/presenter/pages/upload_steps_page.dart';
import 'modules/exams/presenter/pages/upload_terms_page.dart';
import 'modules/exams/presenter/widgets/evolutionary_report_home_patient.dart';
import 'modules/home/presenter/pages/micro_app_home.dart';
import 'modules/home/presenter/pages/v2_exam_home_page.dart';

final Map<String, WidgetBuilder> publicRoutes = {
  Routes.examConsumption: (BuildContext context) =>
      const MicroExamConsumptionPage(),
};

final Map<String, WidgetBuilder> privateRoutes = {
  Routes.microAppHomePage: (BuildContext context) => const MicroAppHomePage(),
  Routes.onboarding: (BuildContext context) => const OnBoardingPage(),
  Routes.home: (BuildContext context) => const V2ExamHomePage(),
  Routes.downloadsExamPage: (BuildContext context) => const DownloadsExamPage(),
  Routes.listExamsPage: (BuildContext context) => const ListExamsPage(),
  Routes.filterExamPage: (BuildContext context) => const FilterExamPage(),
  Routes.filterExamDoctorPage: (BuildContext context) =>
      const FilterDoctorExamPage(),
  Routes.examResultPage: (BuildContext context) => const ResultExamsPage(),
  Routes.examDetailsPage: (BuildContext context) => const ExamDetailsPage(),
  Routes.uploadExamsPage: (BuildContext context) => const UploadExamsPage(),
  Routes.uploadTermsPage: (BuildContext context) => const UploadTermsPage(),
  Routes.uploadStepsPage: (BuildContext context) => const UploadStepsPage(),
  Routes.radiationExposureHistoryPage: (BuildContext context) =>
      const RadiationExposureHistoryPage(),

  Routes.emptyFilterPage: (BuildContext context) => const EmptyFilterPage(),
  Routes.errorPage: (BuildContext context) => const ErrorPage(),

  Routes.evolutionaryReportResultPatient: (BuildContext context) =>
      const EvolutionaryReportResultPatient(),

  //doctor
  Routes.listExamsDoctorPage: (BuildContext context) =>
      const DoctorListExamsPage(),

  Routes.examResultDoctorPage: (BuildContext context) =>
      const DoctorResultExamsPage(),
  Routes.doctorExamDetailsPage: (BuildContext context) =>
      const DoctorExamDetailsPage(),
  Routes.doctorRadiationExposureHistoryPage: (BuildContext context) =>
      const DoctorRadiationExposureHistoryPage(),

  Routes.evolutionaryReportGroupsExams: (BuildContext context) =>
      const EvolutionaryReportGroupsExamsPage(),

  Routes.evolutionaryReportHome: (BuildContext context) =>
      const EvolutionaryReportHomePatient(),
  Routes.failedConnectionPage: (BuildContext context) =>
      const FailedConnectionInternetPage(),

  Routes.errorPage: (BuildContext context) => const FailedPage(),
};

class MicroExamConsumption extends MicroApp {
  static GlobalKey<NavigatorState>? globalNavigatorKey;
  static ApplicationServices? tagger;
  static GlobalKey<NavigatorState>? localNavigatorKey;

  @override
  Widget builder(BuildContext context) => const MicroExamConsumptionPage();

  @override
  void initialize(MicroAppInitializationParameters parameters) {
    initializeDateFormatting('pt_BR');
    globalNavigatorKey = parameters.globalNavigatorKey;
    localNavigatorKey = GlobalKey<NavigatorState>();
    tagger = parameters.globalTagger;

    initInjector();
  }

  @override
  MicroAppRegistration register() => MicroAppRegistration(
        'micro_app_consumo_exame',
        'Exam Consumption',
        publicRoutes,
      );
}

class MicroExamConsumptionPage extends StatefulWidget {
  final String initialRoute;

  const MicroExamConsumptionPage({
    Key? key,
    this.initialRoute = '/exam_consumption/micro-app-home-page',
  }) : super(key: key);

  @override
  State<MicroExamConsumptionPage> createState() =>
      _MicroExamConsumptionPageState();
}

class _MicroExamConsumptionPageState extends State<MicroExamConsumptionPage> {
  bool loadData = false;
  late final UserAuthInfoEntity user;
  late final Map<String, String> mapData;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    if (!loadData) {
      final mapData =
          ModalRoute.of(context)?.settings.arguments as Map<String, String>;

      if ((mapData.containsKey('rootNavigator') &&
              mapData['rootNavigator'] == null) ||
          (!mapData.containsKey('rootNavigator'))) {
        mapData['rootNavigator'] = 'S';
      }

      await setDataLoginParams(mapData);

      loadData = true;
    }
  }

  @override
  void initState() {
    loadData = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        scaffoldMessengerKey: ContextUtil().globalKey,
        navigatorKey: MicroExamConsumption.localNavigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'Exames',
        initialRoute: widget.initialRoute,
        routes: privateRoutes,
        navigatorObservers: [
          AppNavigatorObserver(),
        ],
      );
}
