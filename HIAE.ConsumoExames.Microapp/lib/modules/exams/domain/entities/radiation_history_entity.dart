import 'package:equatable/equatable.dart';

class RadiationHistoryEntity extends Equatable {
  final int examRadiationId;
  final String examDescription;
  final int medicalAppointment;
  final DateTime itemLaunchDate;
  final int groupRadiationId;
  final String groupDescriptionExam;
  final int unityId;
  final String? examCod;
  final String radiationUnity;

  const RadiationHistoryEntity({
    required this.examRadiationId,
    required this.examDescription,
    required this.medicalAppointment,
    required this.itemLaunchDate,
    required this.groupRadiationId,
    required this.groupDescriptionExam,
    required this.unityId,
    required this.examCod,
    required this.radiationUnity,
  });

  @override
  List<Object?> get props => [
        examRadiationId,
        examDescription,
        medicalAppointment,
        itemLaunchDate,
        groupRadiationId,
        groupDescriptionExam,
        unityId,
        examCod,
        radiationUnity,
      ];
}
