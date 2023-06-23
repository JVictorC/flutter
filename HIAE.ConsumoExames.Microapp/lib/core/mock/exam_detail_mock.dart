import 'dart:convert';

import '../../modules/exams/data/models/medical_appointment_list_result_exams_model.dart';
import '../../modules/exams/domain/entities/medical_appointment_list_result_exams_entity.dart';

const String jsonData = '''
{
   "status":0,
   "occurrences":0,
   "passages":{
      "medicalAppointmentListResultExams":[
         {
            "status":0,
            "ocorrencies":0,
            "passage":{
               "id":"string",
               "passageNumber":"string",
               "passageDate":"2022-06-30T16:30:04.677Z",
               "type":"string",
               "place":"string",
               "medicalRecords":0,
               "patientName":"string",
               "patientGender":"string",
               "patientDob":"2022-06-30T16:30:04.677Z",
               "doctorAdmName":"string",
               "doctorAdmIdentity":"string",
               "room":"string",
               "passport":"string",
               "identity":"string"
            },
            "exams":[
               {
                  "examId":"string",
                  "passageId":"string",
                  "examName":"string",
                  "examCode":"string",
                  "labCode":"string",
                  "examType":0,
                  "executionDate":"2022-06-30T16:30:04.677Z",
                  "available":true,
                  "security":true,
                  "doctorName":"string",
                  "doctorIdentity":"string",
                  "place":"string",
                  "accessNumber":"string",
                  "result":"string",
                  "position":0,
                  "statusResult":0,
                  "linesQuantity":"string",
                  "idmedicalRecords":"string",
                  "itemCategory":"string",
                  "executionDate2":"2022-06-30T16:30:04.677Z"
               }
            ]
         }
      ]
   }
}

''';

List<MedicalAppointmentListResultExamsEntity> mockExamDetail() =>
    List<MedicalAppointmentListResultExamsEntity>.from(
      json
          .decode(jsonData)['passages']['medicalAppointmentListResultExams']
          .map(
            (e) => MedicalAppointmentListResultExamsModel.fromMap(e),
          ),
    );
