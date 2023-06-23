// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:equatable/equatable.dart';

class RadiationHistoryParamEntity extends Equatable {
  final int medicalAppointment;
  final String? examCode;
  final String? examGroup;
  const RadiationHistoryParamEntity({
    required this.medicalAppointment,
    this.examCode,
    this.examGroup,
  });

  @override
  List<Object?> get props => [
        medicalAppointment,
        examCode,
        examGroup,
      ];
}
