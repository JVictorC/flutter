abstract class Routes {
  static String examConsumption = '/exam_consumption';
  static String microAppHomePage = '/exam_consumption/micro-app-home-page';
  static String failedConnectionPage =
      '$examConsumption/failed-connection-page';
  static String listExamPatient = '$examConsumption/list-exam-patients';
  static String errorPage = '$examConsumption/error-page';
  static String examDoctor = '$examConsumption/exam-doctor';
  static String onboarding = '$examConsumption/onboarding';
  static String home = '$examConsumption/home';
  static String listExamsPage = '$examConsumption/list_exams_page';
  static String downloadsExamPage = '$examConsumption/downloads_exam_page';
  static String filterExamPage = '$examConsumption/filter_exam_page';
  static String examResultPage = '$examConsumption/exams';
  static String examDetailsPage = '$examConsumption/exams/details';
  static String uploadExamsPage = '$examConsumption/upload';
  static String uploadTermsPage = '$examConsumption/upload/terms';
  static String uploadStepsPage = '$examConsumption/upload/progress';
  static String examsEmptyPage = '$examConsumption/exams/exams_empty';
  static String emptyFilterPage = '$examConsumption/exams/exams_filter_empty';
  static String radiationExposureHistoryPage =
      '$examConsumption/radiation_exposure_history';
  //static String errorPage = '$examConsumption/exams/error_page';
  static String evolutionaryReportPatient =
      '$examConsumption/evolutionary_report/home';
  static String evolutionaryReportResultPatient =
      '$examConsumption/evolutionary_report_result_patient';

  static String examResultDoctorPage = '$examDoctor/exams';
  static String doctorExamDetailsPage = '$examDoctor/exams/details';
  static String doctorRadiationExposureHistoryPage =
      '$examDoctor/radiation_exposure_history';
  static String listExamsDoctorPage = '$examDoctor/list_exams_page';
  static String functionalGroupsListPage =
      '$examDoctor/functional_group_list_page';
  static String filterExamDoctorPage = '$examDoctor/filter_exam_page';
  static String evolutionaryReportGroupsExams =
      '$examConsumption/evolutionary_report_group_exams_page';

  static String evolutionaryReportHome =
      '$examConsumption/evolutionary_report_home_page';
}
