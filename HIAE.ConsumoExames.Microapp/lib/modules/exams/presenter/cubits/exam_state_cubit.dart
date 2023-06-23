import 'package:equatable/equatable.dart';

import '../../../../core/exceptions/exceptions.dart';
import '../../domain/entities/date_exam_entity.dart';
import '../../domain/entities/evolutionary_report_response_entity.dart';
import '../../domain/entities/exam_entity.dart';
import '../../domain/entities/exam_evolutive_result_entity.dart';
import '../../domain/entities/exam_image_result_entity.dart';
import '../../domain/entities/exam_pdf_result_entity.dart';
import '../../domain/entities/exams_medical_records_entity.dart';
import '../../domain/entities/medical_appointment_list_result_exams_entity.dart';
import '../../domain/entities/radiation_history_entity.dart';
import '../../domain/entities/upload_file_response_entity.dart';

abstract class ExamState extends Equatable {}

class ExamInitialState implements ExamState {
  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => true;
}

class ExamFilterEmptyState implements ExamState {
  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => true;
}

class ExamGroup implements ExamState {
  final Map<String, List<ExamsMedicalRecordsEntity>> examData;

  ExamGroup({required this.examData});

  @override
  List<Object?> get props => [examData];

  @override
  bool? get stringify => true;
}

class IncSelectedExamState implements ExamState {
  final int count;

  IncSelectedExamState({required this.count});

  @override
  List<Object?> get props => [count];

  @override
  bool? get stringify => true;
}

class ExamLoadState implements ExamState {
  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => true;
}

class ExamSuccessNewExamState implements ExamState {
  final ExamEntity examEntity;

  ExamSuccessNewExamState({required this.examEntity});

  @override
  List<Object?> get props => [examEntity];

  @override
  bool? get stringify => true;
}

class ExpandedAllButtonState extends ExamState {
  final bool open;

  ExpandedAllButtonState({required this.open});

  @override
  List<Object?> get props => [open];
}

class GetEvolutionaryReportExamsState extends ExamState {
  final EvolutionaryReportExamsEntity evolutionaryReportExams;

  GetEvolutionaryReportExamsState({required this.evolutionaryReportExams});

  @override
  List<Object?> get props => [evolutionaryReportExams];
}

class FilterExamState implements ExamState {
  final List<ExamsMedicalRecordsEntity> data;

  FilterExamState(this.data);

  @override
  List<Object?> get props => [data];

  @override
  bool? get stringify => true;
}

class StatusLoadMoreExams implements ExamState {
  final int examsCount;

  StatusLoadMoreExams(this.examsCount);

  @override
  List<Object?> get props => [examsCount];

  @override
  bool? get stringify => true;
}

class StatusButton implements ExamState {
  final bool status;

  StatusButton(this.status);

  @override
  List<Object?> get props => [status];

  @override
  bool? get stringify => true;
}

class EmitVoiceState implements ExamState {
  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => true;
}

class ExamFailureEmptyGroupExam implements ExamState {
  final Failure failure;

  ExamFailureEmptyGroupExam({required this.failure});

  @override
  List<Object?> get props => [failure];

  @override
  bool? get stringify => true;
}

class ExamFailureState implements ExamState {
  final Failure failure;

  ExamFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];

  @override
  bool? get stringify => true;
}

class ExamLoadFilter implements ExamState {
  final Map<DateTime, List<ExamEntity>> data;
  final int examsAccount;

  ExamLoadFilter({
    required this.data,
    required this.examsAccount,
  });

  @override
  List<Object?> get props => [data];

  @override
  bool? get stringify => true;
}

class ExamsAllRecordsStatus implements ExamState {
  final List<ExamsMedicalRecordsEntity> data;

  ExamsAllRecordsStatus({required this.data});

  @override
  List<Object?> get props => [data];

  @override
  bool? get stringify => true;
}

class ExamSuccessState implements ExamState {
  final DataExamResponseEntity data;

  ExamSuccessState({required this.data});

  @override
  List<Object?> get props => [data];

  @override
  bool? get stringify => true;
}

class ExamDetailsSuccessState implements ExamState {
  final List<MedicalAppointmentListResultExamsEntity> data;

  ExamDetailsSuccessState({required this.data});

  @override
  List<Object?> get props => [data];

  @override
  bool? get stringify => true;
}

class ExamPdfSuccessState implements ExamState {
  final ExamPdfResultEntity data;

  ExamPdfSuccessState({required this.data});

  @override
  List<Object?> get props => [data];

  @override
  bool? get stringify => true;
}

class ExamImageSuccessState implements ExamState {
  final ExamImageResultEntity data;

  ExamImageSuccessState({required this.data});

  @override
  List<Object?> get props => [data];

  @override
  bool? get stringify => true;
}

class ExamDateLoadSuccessState implements ExamState {
  ExamDateLoadSuccessState();

  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => true;
}

class ExamEvolutiveSuccessState implements ExamState {
  final ExamEvolutiveResultEntity data;

  ExamEvolutiveSuccessState({required this.data});

  @override
  List<Object?> get props => [data];

  @override
  bool? get stringify => true;
}

class RadiationHistorySuccessState implements ExamState {
  final List<RadiationHistoryEntity> data;

  RadiationHistorySuccessState({required this.data});

  @override
  List<Object?> get props => [data];

  @override
  bool? get stringify => true;
}

class UploadFileSuccessState implements ExamState {
  final UploadFileResponseEntity data;

  UploadFileSuccessState({required this.data});

  @override
  List<Object?> get props => [data];

  @override
  bool? get stringify => true;
}

class AllResultExamLoadedState implements ExamState {
  AllResultExamLoadedState();

  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => true;
}

class ExamEmptyState implements ExamState {
  ExamEmptyState();

  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => true;
}
