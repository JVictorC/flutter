import '../../domain/entities/exams_medical_records_entity.dart';

class ExamsMedicalRecordsModel extends ExamsMedicalRecordsEntity {
  ExamsMedicalRecordsModel({
    required String examName,
    required String examCode,
    required String itemCategory,
  }) : super(
          examName: examName,
          examCode: examCode,
          itemCategory: itemCategory,
        );

  factory ExamsMedicalRecordsModel.fromMap(Map<String, dynamic> map) =>
      ExamsMedicalRecordsModel(
        examCode: map['examCode'],
        examName: map['examName'],
        itemCategory: map['itemCategory'],
      );
}
