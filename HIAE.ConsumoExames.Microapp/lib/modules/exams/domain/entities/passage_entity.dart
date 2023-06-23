import 'package:equatable/equatable.dart';

class PassageEntity extends Equatable {
  final DateTime passageDate;
  final int medicalRecords;
  final String patientGender;
  final DateTime patientDob;
  final bool blocked;
  final bool medicalRecordsBlocked;
  final String? id;
  final String? passageNumber;
  final String? type;
  final String? place;
  final String? patientName;
  final String? doctorAdmName;
  final String? doctorAdmIdentity;
  final String? room;
  final String? passport;
  final String? identity;

  const PassageEntity({
    required this.id,
    required this.passageNumber,
    required this.passageDate,
    required this.type,
    required this.place,
    required this.medicalRecords,
    required this.patientName,
    required this.patientGender,
    required this.patientDob,
    required this.doctorAdmName,
    required this.doctorAdmIdentity,
    required this.room,
    required this.passport,
    required this.identity,
    required this.blocked,
    required this.medicalRecordsBlocked,
  });

  @override
  List<Object?> get props => [
        id,
        passageNumber,
        passageDate,
        type,
        place,
        medicalRecords,
        patientName,
        patientGender,
        patientDob,
        doctorAdmName,
        doctorAdmIdentity,
        room,
        passport,
        identity,
        medicalRecordsBlocked,
        blocked,
      ];
}
