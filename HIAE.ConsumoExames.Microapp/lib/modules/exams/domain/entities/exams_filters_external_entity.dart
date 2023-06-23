import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class FiltersExternalEntity extends Equatable {
  List<int>? examType;
  String? examName;
  DateTime? executionInitialDate;
  DateTime? executionFinalDate;

  FiltersExternalEntity({
    this.examType,
    this.examName,
    this.executionFinalDate,
    this.executionInitialDate,
  });

  FiltersExternalEntity copyWith({
    List<int>? examType,
    String? examName,
    DateTime? executionInitialDate,
    DateTime? executionFinalDate,
  }) =>
      FiltersExternalEntity(
        examType: examType ?? this.examType,
        examName: examName ?? this.examName,
        executionInitialDate: executionInitialDate ?? this.executionInitialDate,
        executionFinalDate: executionFinalDate ?? this.executionFinalDate,
      );

  @override
  List<Object?> get props => [
        examType,
        examName,
        executionInitialDate,
        executionFinalDate,
      ];
}
