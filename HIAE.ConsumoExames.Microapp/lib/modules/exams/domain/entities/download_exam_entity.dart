import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class DownloadExamEntity extends Equatable {
  final DateTime executionDateBegin;
  final DateTime executionDateEnd;
  final List<String> itensIdList;
  final int userType;
  final bool examBreak;
  final String? passage;
  final String? examCode;
  String? medicalAppointment;

  DownloadExamEntity({
    required this.medicalAppointment,
    required this.passage,
    required this.itensIdList,
    required this.examBreak,
    required this.executionDateBegin,
    required this.executionDateEnd,
    required this.examCode,
    required this.userType,
  });

  @override
  List<Object?> get props => [
        medicalAppointment,
        passage,
        itensIdList,
        examBreak,
        executionDateBegin,
        executionDateEnd,
        examCode,
        userType,
      ];
}
