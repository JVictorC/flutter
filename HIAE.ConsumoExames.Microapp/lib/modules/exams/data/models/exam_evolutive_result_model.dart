import '../../domain/usecases/get_evolutive_result_usecase.dart';

class ExamEvolutiveResultModel {
  int? status;
  PassageModel? passage;
  int? ocorrencias;
  List<HeadersModel>? headers;
  List<ExamResultsModel>? examResults;

  ExamEvolutiveResultModel({
    this.status,
    this.passage,
    this.ocorrencias,
    this.headers,
    this.examResults,
  });

  ExamEvolutiveResultModel.fromMap(Map<String, dynamic> map) {
    status = map['status'];
    passage =
        map['passage'] != null ? PassageModel.fromMap(map['passage']) : null;
    ocorrencias = map['ocorrencias'];
    if (map['headers'] != null) {
      headers = <HeadersModel>[];
      map['headers'].forEach((v) {
        headers?.add(HeadersModel.fromMap(v));
      });
    }
    if (map['examResults'] != null) {
      examResults = <ExamResultsModel>[];
      map['examResults'].forEach((v) {
        examResults?.add(ExamResultsModel.fromMap(v));
      });
    }
  }

  static Map<String, dynamic> toRequest(EvolutiveParam param) =>
      <String, dynamic>{
        'chAuthentication': param.chAuthentication,
        'idPassage': param.idPassage,
        'codExam': param.codExam,
        'qtdPassages': param.qtdPassages,
        'dtCut': param.dtCut,
      };
}

class PassageModel {
  int? id;
  String? passageNumber;
  String? passageDate;
  int? type;
  String? place;
  int? medicalRecords;
  String? patientName;
  String? patientGender;
  String? patientDOB;
  int? identity;

  PassageModel({
    this.id,
    this.passageNumber,
    this.passageDate,
    this.type,
    this.place,
    this.medicalRecords,
    this.patientName,
    this.patientGender,
    this.patientDOB,
    this.identity,
  });

  PassageModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    passageNumber = map['passageNumber'];
    passageDate = map['passageDate'];
    type = map['type'];
    place = map['place'];
    medicalRecords = map['medicalRecords'];
    patientName = map['patientName'];
    patientGender = map['patientGender'];
    patientDOB = map['patientDOB'];
    identity = map['identity'];
  }
}

class HeadersModel {
  String? examName;
  String? examCode;
  int? examType;
  int? itensQuantity;
  List<ExamItensHeader>? examItensHeader;

  HeadersModel({
    this.examName,
    this.examCode,
    this.examType,
    this.itensQuantity,
    this.examItensHeader,
  });

  HeadersModel.fromMap(Map<String, dynamic> map) {
    examName = map['examName'];
    examCode = map['examCode'];
    examType = map['examType'];
    itensQuantity = map['itensQuantity'];
    if (map['examItensHeader'] != null) {
      examItensHeader = <ExamItensHeader>[];
      map['examItensHeader'].forEach((v) {
        examItensHeader!.add(ExamItensHeader.fromMap(v));
      });
    }
  }
}

class ExamItensHeader {
  String? nameItem;
  String? codItem;
  String? unity;

  ExamItensHeader({
    this.nameItem,
    this.codItem,
    this.unity,
  });

  ExamItensHeader.fromMap(Map<String, dynamic> map) {
    nameItem = map['nameItem'];
    codItem = map['codItem'];
    unity = map['unity'];
  }
}

class ExamResultsModel {
  int? passageId;
  String? passageDate;
  int? passageIdLab;
  String? examCode;
  int? examType;
  String? executionDate;
  String? executionHour;
  List<LstExamResultItens>? lstExamResultItens;

  ExamResultsModel({
    this.passageId,
    this.passageDate,
    this.passageIdLab,
    this.examCode,
    this.examType,
    this.executionDate,
    this.executionHour,
    this.lstExamResultItens,
  });

  ExamResultsModel.fromMap(Map<String, dynamic> map) {
    passageId = map['passageId'];
    passageDate = map['passageDate'];
    passageIdLab = map['passageIdLab'];
    examCode = map['examCode'];
    examType = map['examType'];
    executionDate = map['executionDate'];
    executionHour = map['executionHour'];
    if (map['lstExamResultItens'] != null) {
      lstExamResultItens = <LstExamResultItens>[];
      map['lstExamResultItens'].forEach((v) {
        lstExamResultItens!.add(LstExamResultItens.fromMap(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['passageId'] = passageId;
    data['passageDate'] = passageDate;
    data['passageIdLab'] = passageIdLab;
    data['examCode'] = examCode;
    data['examType'] = examType;
    data['executionDate'] = executionDate;
    data['executionHour'] = executionHour;
    if (lstExamResultItens != null) {
      data['lstExamResultItens'] =
          lstExamResultItens!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LstExamResultItens {
  String? itemCod;
  int? examValue;
  int? updated;

  LstExamResultItens({
    this.itemCod,
    this.examValue,
    this.updated,
  });

  LstExamResultItens.fromMap(Map<String, dynamic> map) {
    itemCod = map['itemCod'];
    examValue = map['examValue'];
    updated = map['updated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['itemCod'] = itemCod;
    data['examValue'] = examValue;
    data['updated'] = updated;
    return data;
  }
}
