import 'dart:convert';

import '../../modules/exams/data/models/date_exam_model.dart';
import '../../modules/exams/domain/entities/date_exam_entity.dart';

const String jsonData = '''
{
   "status": 0,
   "occurrences": 0,
   "dates":[
      {
         "passageId":1,
         "dtExecution":"2022-03-02",
         "position":1,
         "passagePlace":"Morumbi",
         "passageType":"Passagem Externa"
      },
      {
         "passageId":2,
         "dtExecution":"2022-03-16",
         "position":2,
         "passagePlace":"Morumbi",
         "passageType":"Passagem Interna"
      },
      {
         "passageId":3,
         "dtExecution":"2022-02-12",
         "position":3,
         "passagePlace":"Morumbi",
         "passageType":"Pronto Atendimento"
      },
      {
         "passageId":4,
         "dtExecution":"2022-02-01",
         "position":4,
         "passagePlace":"Morumbi",
         "passageType":"Passagem Interna"
      },
      {
         "passageId":5,
         "dtExecution":"2021-11-24",
         "position":5,
         "passagePlace":"Morumbi",
         "passageType":"Passagem Interna"
      },
      {
         "passageId":6,
         "dtExecution":"2021-09-19",
         "position":6,
         "passagePlace":"Morumbi",
         "passageType":"Passagem Interna"
      },
      {
         "passageId":7,
         "dtExecution":"2021-08-17",
         "position":7,
         "passagePlace":"Morumbi",
         "passageType":"Passagem Externa"
      },
      {
         "passageId":8,
         "dtExecution":"2021-01-28",
         "position":8,
         "passagePlace":"Morumbi",
         "passageType":"Passagem Interna"
      },
      {
         "passageId":9,
         "dtExecution":"2020-10-24",
         "position":9,
         "passagePlace":"Morumbi",
         "passageType":"Passagem Interna"
      },
      {
         "passageId":10,
         "dtExecution":"2020-04-16",
         "position":10,
         "passagePlace":"Morumbi",
         "passageType":"Pronto Atendimento"
      }
   ],
   "messages": "string"
}
''';

Future<List<DateExamEntity>> mockExamDate() async {
  await Future.delayed(
    const Duration(seconds: 1),
  );
  return List<DataExamModel>.from(
    json.decode(jsonData)['dates'].map(
          (data) => DataExamModel.fromMap(data),
        ),
  );
}
