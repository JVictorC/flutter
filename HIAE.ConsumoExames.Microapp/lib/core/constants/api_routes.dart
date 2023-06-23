import 'package:base_dependencies/dependencies.dart';

abstract class ApiRoutes {
  static final String baseUrl = HiaeFlavors.instance.configs['baseUrl'];

  static const String _apiVersion = '/api/1';

  static const String _examResults = '$_apiVersion/ExamResults';
  static const String _appBaseResults = '$_apiVersion/AppBaseResults';

  //endPoints
  static const String validateApp = '$_examResults/ValidateApp';
  static const String openScreen = '$_examResults/OpenScreen';
  static const String dateExam = '$_examResults/GetExamDate';
  static const String examDetail = '$_examResults/GetExamResults';
  static const String examPdf = '$_examResults/GetPdfResult';
  static const String examImage = '$_examResults/GetImageExamResult';
  static const String examEvolutive = '$_examResults/GetEvolutiveResult';
  static const String listAllExamMedicalRecords =
      '$_examResults/GetListExamMedicalRecordsResult';
  static const String externalExam = '$_examResults/ExternalExam';
  static const String uploadFile = '$_examResults/UploadFile';
  static const String downloadFile = '$_examResults/DownloadFile';
  static const String radiationExposure = '$_examResults/GetRadiationExposure';

  static const String tokenDoctor =
      '$_appBaseResults/GenerateTokenEinsteinMedicos';

  static const String evolutionaryReport =
      '$_examResults/GetConsultationEvolutionaryExamsResult';

  static const String tokenPatient = '$_appBaseResults/GenerateTokenMyEinstein';
  static const String examsResultsRemove = '$_examResults/DeleteFile';
  static const String examsResultsRemoveExternalExam =
      '$_examResults/ExternalExam';
}
