class EvolutionaryReportRequestEntity {
  final String? chAuthentication;
  final DateTime? initialDate;
  final DateTime? finalDate;
  final String examCode;
  final int numberOfRecords;
  String medicalAppointment;

  EvolutionaryReportRequestEntity({
    required this.chAuthentication,
    required this.examCode,
    required this.finalDate,
    required this.initialDate,
    required this.medicalAppointment,
    required this.numberOfRecords,
  });
}
