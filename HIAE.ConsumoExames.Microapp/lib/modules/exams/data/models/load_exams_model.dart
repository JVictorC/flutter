import '../../../../core/extensions/date_time_extension.dart';
import '../../domain/entities/exams_filters_entity.dart';
import '../../domain/entities/exams_filters_external_entity.dart';
import '../../domain/entities/load_exams_entity.dart';
import 'exams_filters_model.dart';
import 'filters_external_model.dart';

// ignore: must_be_immutable
class LoadExamsModel extends LoadExamEntity {
  LoadExamsModel({
    required DateTime initialDate,
    required DateTime finalDate,
    required bool results,
    required String? chAuthentication,
    required String? medicalAppointment,
    required bool? auxPrint,
    required String? numberOfRecords,
    required String? passageId,
    required String? exams,
    required String? idItens,
    required String? lab,
    required ExamFiltersEntity filters,
    required FiltersExternalEntity externalFilters,
  }) : super(
          filters: filters,
          chAuthentication: chAuthentication,
          medicalAppointment: medicalAppointment,
          results: results,
          initialDate: initialDate,
          finalDate: finalDate,
          auxPrint: auxPrint,
          numberOfRecords: numberOfRecords,
          passageId: passageId,
          exams: exams,
          idItens: idItens,
          lab: lab,
          externalFilters: externalFilters,
        );

  Map<String, dynamic> toMap() => {
        'lab': lab,
        'chAuthentication': chAuthentication,
        'medicalAppointment': medicalAppointment,
        'results': results,
        'initialDate': initialDate.toJson(),
        'finalDate': finalDate.toJson(),
        'print': auxPrint,
        'numberOfRecords': numberOfRecords,
        'passageId': passageId,
        'exams': exams,
        'idItens': idItens,
        'filters': ExamFiltersModel.fromEntity(filters).toMap(),
        'filtersExternal':
            FiltersExternalModel.fromEntity(externalFilters).toMap(),
      };

  factory LoadExamsModel.fromEntity(LoadExamEntity entity) => LoadExamsModel(
        lab: entity.lab,
        filters: entity.filters,
        externalFilters: entity.externalFilters,
        chAuthentication: entity.chAuthentication,
        exams: entity.exams,
        initialDate: entity.initialDate,
        finalDate: entity.finalDate,
        idItens: entity.idItens,
        medicalAppointment: entity.medicalAppointment,
        numberOfRecords: entity.numberOfRecords,
        passageId: entity.passageId,
        auxPrint: entity.auxPrint,
        results: entity.results,
      );
}
