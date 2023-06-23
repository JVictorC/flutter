import 'exams_medical_records_entity.dart';

class LoadEvolutionaryReportEntity {
  final DateTime dateInitial;
  final DateTime dateFinal;
  final List<ExamsMedicalRecordsEntity> selectedExams;
  final List<int> selectedPassageType;
  final String? dateDescription;

  LoadEvolutionaryReportEntity({
    required this.dateDescription,
    required this.dateInitial,
    required this.dateFinal,
    required this.selectedExams,
    required this.selectedPassageType,
  });
}
