import '../../domain/entities/radiation_history_entity.dart';

class RadiationHistoryModel extends RadiationHistoryEntity {
  const RadiationHistoryModel({
    required int examRadiationId,
    required String? examDescription,
    required int medicalAppointment,
    required DateTime itemLaunchDate,
    required int groupRadiationId,
    required String? groupDescriptionExam,
    required int unityId,
    required String? examCod,
    required String? radiationUnity,
  }) : super(
          examRadiationId: examRadiationId,
          examDescription: examDescription ?? '',
          medicalAppointment: medicalAppointment,
          itemLaunchDate: itemLaunchDate,
          groupRadiationId: groupRadiationId,
          groupDescriptionExam: groupDescriptionExam ?? '',
          unityId: unityId,
          examCod: examCod,
          radiationUnity: radiationUnity ?? '',
        );

  factory RadiationHistoryModel.fromMap(Map<String, dynamic> map) =>
      RadiationHistoryModel(
        examRadiationId: map['examRadiationId'],
        examDescription: map['examDescription'],
        medicalAppointment: map['medicalAppointment'],
        itemLaunchDate: DateTime.parse(map['itemLaunchDate']),
        groupRadiationId: map['groupRadiationId'],
        groupDescriptionExam: map['groupDescriptionExam'],
        unityId: map['unityId'],
        examCod: map['examCod'],
        radiationUnity: map['radiationUnity'],
      );
}
