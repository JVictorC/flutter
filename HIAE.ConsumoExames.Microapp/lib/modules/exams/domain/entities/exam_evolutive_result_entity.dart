class ExamEvolutiveResultEntity {
  final int status;
  final PassageEntity passage;
  final int ocorrencias;
  final List<HeadersEntity> headers;
  final List<ExamResultsEntity> examResults;

  ExamEvolutiveResultEntity({
    required this.status,
    required this.passage,
    required this.ocorrencias,
    required this.headers,
    required this.examResults,
  });
}

class PassageEntity {
  final int id;
  final String passageNumber;
  final String passageDate;
  final int type;
  final String place;
  final int medicalRecords;
  final String patientName;
  final String patientGender;
  final String patientDOB;
  final int identity;

  PassageEntity({
    required this.id,
    required this.passageNumber,
    required this.passageDate,
    required this.type,
    required this.place,
    required this.medicalRecords,
    required this.patientName,
    required this.patientGender,
    required this.patientDOB,
    required this.identity,
  });
}

class HeadersEntity {
  final String examName;
  final String examCode;
  final int examType;
  final int itensQuantity;
  final List<ExamItensHeaderEntity> examItensHeader;

  HeadersEntity({
    required this.examName,
    required this.examCode,
    required this.examType,
    required this.itensQuantity,
    required this.examItensHeader,
  });
}

class ExamItensHeaderEntity {
  final String nameItem;
  final String codItem;
  final String unity;

  ExamItensHeaderEntity({
    required this.nameItem,
    required this.codItem,
    required this.unity,
  });
}

class ExamResultsEntity {
  final int passageId;
  final String passageDate;
  final int passageIdLab;
  final String examCode;
  final int examType;
  final String executionDate;
  final String executionHour;
  final List<LstExamResultItensEntity> lstExamResultItens;

  ExamResultsEntity({
    required this.passageId,
    required this.passageDate,
    required this.passageIdLab,
    required this.examCode,
    required this.examType,
    required this.executionDate,
    required this.executionHour,
    required this.lstExamResultItens,
  });
}

class LstExamResultItensEntity {
  final String itemCod;
  final int examValue;
  final int updated;

  LstExamResultItensEntity({
    required this.itemCod,
    required this.examValue,
    required this.updated,
  });
}
