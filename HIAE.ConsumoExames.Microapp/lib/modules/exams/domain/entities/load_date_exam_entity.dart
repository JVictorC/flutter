// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:equatable/equatable.dart';

//ignore: must_be_immutable
class LoadDateExamEntity extends Equatable {
  final String? passageType;
  final String? chAuthentication;

  String? exams;
  DateTime initialDate;
  DateTime finalDate;
  String? medicalAppointment;
  int numberOfRecords;

  LoadDateExamEntity({
    required this.initialDate,
    required this.finalDate,
    required this.numberOfRecords,
    this.chAuthentication,
    this.medicalAppointment,
    this.exams,
    this.passageType,
  });

  @override
  List<Object?> get props => [
        initialDate,
        finalDate,
        numberOfRecords,
        chAuthentication,
        medicalAppointment,
        exams,
        passageType,
      ];
}
