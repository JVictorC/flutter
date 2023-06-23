const jsonGetExams = """
{       
  "status": "0",
  "occurrences": "4",
  "passages": {
    "medicalAppointmentListResultExams": [
      {
        "status": "0",
        "passage": {
          "id": "20351262",
          "passageNumber": "29276142",
          "passageDate": "2020-08-17",
          "type": "1",
          "place": "morumbi",
          "medicalRecords": "1035361",
          "patientName": "teste renato batista campos",
          "patientGender": "masculino",
          "patientDob": "1969-08-15",
          "doctorAdmName": "medico teste crm",
          "doctorAdmIdentity": "888888889",
          "room": "a0986",
          "passport": "123456ab",
          "identity": "13687480828"
        },
        "ocorrencies": "2",
        "exams": {
          "exame": [
            {
              "examId": "18531872||1",
              "passageId": "20351262",
              "examName": "creatinina",
              "examCode": "lcre",
              "labCode": "29276143",
              "examType": "1",
              "executionDate": "2020-08-17",
              "available": "true",
              "security": "false",
              "doctorName": "riguel jun inaoka teste",
              "doctorIdentity": "109647crmsp",
              "place": "morumbi",
              "accessNumber": "2023000276a",
              "result": "<div style='font-family:verdana;width:99%;'><hr><table style='width:100%;'><tr><td colspan=2><b><font size=3>creatinina</font></b>, <font size=2>soro</font></td></tr><tr><td colspan=3><font size=1>coletado em: 17/08/2020 14:39:00</font></td><td align='right' colspan=2><font size=1>liberado em: 17/08/2020 17:24:46</font></td></tr><tr><td colspan=2><font size=1>médico solicitante:&nbsp;<b>riguel jun inaoka teste 109647crmsp</b></td></tr></table><table style='width:100%;font-family:verdana;' border=0><tr><td></td><td align='center' style='width:20%;'><font size=1><b>result</b></font></td><td style='padding-left:25px;'><font size=1><b>valores de referência</b></font></td></tr><tr><td style='width:1%;'></td><td style='background-color:rgb(180,180,180);padding:5px 0px 5px;' align='center'><font size=2><b>1,00&nbsp;&nbsp;mg/dl</b></font></td><td style='width:20%;padding-left:25px;'><font size=1>0,60 - 1,20</font></td><tr><td colspan=20><font size=2></font></td></tr></table><table style='width:100%;'><tr><td><font size=1>número do laboratório: <b>2023000276a</b></font></td></tr><tr><td><font size=1>liberado por: <b>integracaomill</b></font></td></tr></table><hr></div>",
              "position": "1",
              "statusResult": "1",
              "linesQuantity": "14",
              "idmedicalRecords": "900909",
              "itemCategory": "laboratorio analises clinicas",
              "executionDate2": "2020-08-17"
            },
            {
              "examId": "18531872||2",
              "passageId": "20351262",
              "examName": "calcio",
              "examCode": "lcal",
              "labCode": "29276164",
              "examType": "1",
              "executionDate": "2020-08-17",
              "available": "true",
              "security": "false",
              "doctorName": "riguel jun inaoka teste",
              "doctorIdentity": "109647crmsp",
              "place": "morumbi",
              "accessNumber": "2023000279a",
              "result": "<div style='font-family:verdana;width:99%;'><hr><table style='width:100%;'><tr><td colspan=2><b><font size=3>calcio</font></b>, <font size=2>soro</font></td></tr><tr><td colspan=3><font size=1>coletado em: 17/08/2020 17:58:00</font></td><td align='right' colspan=2><font size=1>liberado em: 18/08/2020 10:02:19</font></td></tr><tr><td colspan=2><font size=1>médico solicitante:&nbsp;<b>riguel jun inaoka teste 109647crmsp</b></td></tr></table><table style='width:100%;font-family:verdana;' border=0><tr><td></td><td align='center' style='width:20%;'><font size=1><b>result</b></font></td><td style='padding-left:25px;'><font size=1><b>valores de referência</b></font></td></tr><tr><td style='width:1%;'></td><td style='background-color:rgb(180,180,180);padding:5px 0px 5px;' align='center'><font size=2><b>1</b></font></td><td style='width:20%;padding-left:25px;'><font size=1>0 - 1</font></td><tr><td colspan=20><font size=2></font></td></tr></table><table style='width:100%;'><tr><td><font size=1>número do laboratório: <b>2023000279a</b></font></td></tr><tr><td><font size=1>liberado por: <b>integracaomill</b></font></td></tr></table><hr></div>",
              "position": "2",
              "statusResult": "1",
              "linesQuantity": "14",
              "idmedicalRecords": "900909",
              "itemCategory": "laboratorio analises clinicas",
              "executionDate2": "2020-08-17"
            }
          ]
        }
      },
      {
        "status": "0",
        "passagem": {
          "id": "20351263",
          "passageNumber": "e15577982",
          "passageDate": "2020-08-17",
          "type": "2",
          "place": "morumbi",
          "medicalRecords": "1035361",
          "patientName": "teste renato batista campos",
          "patientGender": "masculino",
          "patientDob": "1969-08-15",
          "passaporte": "123456ab",
          "cpf": "13687480828"
        },
        "ocorrencias": "1",
        "exames": {
          "exame": {
            "examId": "18531873||2",
            "passageId": "20351263",
            "examName": "potassio",
            "examCode": "lpot",
            "labCode": "29276146",
            "examType": "1",
            "executionDate": "2020-08-17",
            "available": "true",
            "security": "false",
            "doctorName": "thiago fazani duarte",
            "doctorIdentity": "343434crmsp",
            "place": "morumbi",
            "accessNumber": "2023000277a",
            "result": "<div style='font-family:verdana;width:99%;'><hr><table style='width:100%;'><tr><td colspan=2><b><font size=3>potassio</font></b>, <font size=2>soro</font></td></tr><tr><td colspan=3><font size=1>coletado em: 17/08/2020 15:39:00</font></td><td align='right' colspan=2><font size=1>liberado em: 17/08/2020 17:24:23</font></td></tr><tr><td colspan=2><font size=1>médico solicitante:&nbsp;<b>thiago fazani duarte 343434crmsp</b></td></tr></table><table style='width:100%;font-family:verdana;' border=0><tr><td></td><td align='center' style='width:20%;'><font size=1><b>result</b></font></td><td style='padding-left:25px;'><font size=1><b>valores de referência</b></font></td></tr><tr><td style='width:1%;'></td><td style='background-color:rgb(180,180,180);padding:5px 0px 5px;' align='center'><font size=2><b>4,0&nbsp;&nbsp;meq/l</b></font></td><td style='width:20%;padding-left:25px;'><font size=1>3,5 - 5,0</font></td><tr><td colspan=20><font size=2></font></td></tr></table><table style='width:100%;'><tr><td><font size=1>número do laboratório: <b>2023000277a</b></font></td></tr><tr><td><font size=1>liberado por: <b>integracaomill</b></font></td></tr></table><hr></div>",
            "position": "1",
            "statusResult": "1",
            "linesQuantity": "14",
            "idmedicalRecords": "900909",
            "itemCategory": "laboratorio analises clinicas",
            "executionDate2": "2020-08-17"
          }
        }
      },
      {
        "status": "0",
        "passagem": {
          "id": "17616838",
          "passageNumber": "e13493169",
          "passageDate": "2017-09-24",
          "type": "2",
          "place": "morumbi",
          "medicalRecords": "1035361",
          "patientName": "teste renato batista campos",
          "patientGender": "masculino",
          "patientDob": "1969-08-15",
          "passaporte": "123456ab",
          "cpf": "13687480828"
        },
        "ocorrencias": "1",
        "exames": {
          "exame": {
            "examId": "15797179||5",
            "passageId": "17616838",
            "examName": "rx coluna lombar",
            "examCode": "sr0b",
            "examType": "2",
            "executionDate": "2017-09-24",
            "available": "true",
            "security": "false",
            "doctorName": "digitado no ris",
            "laudo": "true",
            "laudoarquivo": "\\20170925\\15797179-51.pdf",
            "place": "rad1-radiologia - bloco a1",
            "accessNumber": "15797179/51",
            "url1": "http://pacsportal3.einstein.br/?server_name=portal&user_name=user_vuemotion&password=vue0vp!2015&accession_number=15797179/51",
            "url2": "http://pacsportal3.einstein.br/?server_name=portal&user_name=user_vuemotion&password=vue0vp!2015&accession_number=15797179/51",
            "position": "1",
            "statusResult": "3",
            "idmedicalRecords": "900909",
            "itemCategory": "radiologia",
            "executionDate2": "2017-09-25"
          }
        }
      },
      {
        "status": "0",
        "passagem": {
          "id": "17161016",
          "passageNumber": "e13149461",
          "passageDate": "2017-06-09",
          "type": "2",
          "place": "morumbi",
          "medicalRecords": "1035361",
          "patientName": "teste renato batista campos",
          "patientGender": "masculino",
          "patientDob": "1969-08-15",
          "passaporte": "123456ab",
          "cpf": "13687480828"
        },
        "ocorrencias": "3",
        "exames": {
          "exame": [
            {
              "examId": "15341314||1",
              "passageId": "17161016",
              "examName": "psa total-livre - ag prost especifico",
              "examCode": "ln141",
              "labCode": "23279996",
              "examType": "1",
              "executionDate": "2017-06-09",
              "available": "false",
              "security": "false",
              "doctorName": "simone ramos de miranda",
              "doctorIdentity": "69585crmsp",
              "place": "morumbi",
              "accessNumber": "15341314/19",
              "position": "1",
              "statusResult": "4",
              "idmedicalRecords": "900909",
              "itemCategory": "laboratorio analises clinicas",
              "executionDate2": "2017-06-09"
            },
            {
              "examId": "15341314||2",
              "passageId": "17161016",
              "examName": "colesterol total e fracoes",
              "examCode": "lctf",
              "labCode": "23279996",
              "examType": "1",
              "executionDate": "2017-06-09",
              "available": "false",
              "security": "false",
              "doctorName": "simone ramos de miranda",
              "doctorIdentity": "69585crmsp",
              "place": "morumbi",
              "accessNumber": "15341314/29",
              "position": "2",
              "statusResult": "4",
              "idmedicalRecords": "900909",
              "itemCategory": "laboratorio analises clinicas",
              "executionDate2": "2017-06-09"
            },
            {
              "examId": "15341314||3",
              "passageId": "17161016",
              "examName": "hemoglobina glicada",
              "examCode": "lpgl",
              "labCode": "23279996",
              "examType": "1",
              "executionDate": "2017-06-09",
              "available": "false",
              "security": "false",
              "doctorName": "simone ramos de miranda",
              "doctorIdentity": "69585crmsp",
              "place": "morumbi",
              "accessNumber": "15341314/39",
              "position": "3",
              "statusResult": "4",
              "idmedicalRecords": "900909",
              "itemCategory": "laboratorio analises clinicas",
              "executionDate2": "2017-06-09"
            }
          ]
        }
      }
    ]
  }
}""";
