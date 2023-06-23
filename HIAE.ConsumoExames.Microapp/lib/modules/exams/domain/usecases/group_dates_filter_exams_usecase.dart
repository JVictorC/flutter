import '../../../../core/utils/primitive_wrapper.dart';
import '../entities/exam_entity.dart';
import '../entities/result_external_exam_entity.dart';
import '../entities/result_internal_exam_entity.dart';

abstract class IGroupDatesFilterExamsUseCase {
  Map<DateTime, List<ExamEntity>> call({
    required List<ResultInternalExamEntity> resultInternalExam,
    required List<ResultExternalExamEntity> resultExternalExam,
    required PrimitiveWrapper account,
  });
}

class GroupDatesFilterExamsUseCase implements IGroupDatesFilterExamsUseCase {
  @override
  Map<DateTime, List<ExamEntity>> call({
    required List<ResultInternalExamEntity> resultInternalExam,
    required List<ResultExternalExamEntity> resultExternalExam,
    required PrimitiveWrapper account,
  }) {
    final copyInternalList = [...resultInternalExam];
    final copyExternalList = [...resultExternalExam];
    final List<ExamEntity> listExam = [];

    Map<DateTime, List<ExamEntity>> dataMap = {};
    account.value = 0;

    copyInternalList.where((element) => element.listExam.isNotEmpty).forEach(
      (element) {
        element.listExam
            .sort((a, b) => b.executionDate.compareTo(a.executionDate));

        account.value += element.listExam.length;

        listExam.addAll(element.listExam);
      },
    );

    if (copyExternalList.isNotEmpty) {
      copyExternalList.sort(
        (a, b) => b.executionDate.compareTo(a.executionDate),
      );

      account.value += copyExternalList.length;
      int position = account.value;

      for (var value in copyExternalList) {
        ExamEntity exam = ExamEntity(
          fileId: value.fileId,
          path: value.path,
          examType: value.examType,
          executionDate: value.executionDate,
          executionDate2: value.executionDate,
          uploadDate: value.uploadDate,
          labName: value.labName,
          examId: value.id,
          examName: value.examName,
          laudoFile: value.path,
          url1: value.url,
          idMedicalRecords: value.medicalRecords,
          position: position,
          statusResult: 0,
          passType: null,
          available: true,
          security: true,
          laudo: false,
          passageId: null,
          examCode: null,
          labCode: null,
          doctorName: null,
          doctorIdentity: null,
          place: null,
          url2: null,
          accessNumber: null,
          result: null,
          linesQuantity: null,
          itemCategory: null,
        );

        exam.externalExam = true;

        listExam.add(exam);

        position++;
      }
    }

    listExam.sort((a, b) => b.executionDate.compareTo(a.executionDate));

    if (listExam.isNotEmpty) {
      final auxListExam = [...listExam];

      for (var value in listExam) {
        if (!dataMap.containsKey(value.executionDate)) {
          dataMap[value.executionDate] = auxListExam
              .where((element) => value.executionDate == element.executionDate)
              .toList();
        }
      }
    }

    return dataMap;
  }
}

class DataExam {
  final DateTime date;
  List<ExamEntity> listExam;

  DataExam({
    required this.date,
    required this.listExam,
  });
}
