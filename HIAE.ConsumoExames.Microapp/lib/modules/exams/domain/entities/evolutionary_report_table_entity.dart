class EvolutionaryReportTableEntity {
  final String name;
  late final List<String> headers;
  late final List<String> referencesValue;
  late final List<String> data;
  late final List<String> valueExam;

  EvolutionaryReportTableEntity({
    required this.name,
  }) {
    headers = [];
    referencesValue = [];
    data = [];
    valueExam = [];
  }
}
