import 'dart:convert';

import 'package:base_dependencies/dependencies.dart';
import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../core/constants/strings.dart';
import '../../../../core/di/initInjector.dart';
import '../../../../core/entities/user_auth_info.dart';
import '../../../../core/extensions/string_extension.dart';
import '../../../../core/extensions/translate_extension.dart';
import '../../../../core/singletons/context_key.dart';
import '../../../../core/utils/handler_files_picker.dart';
import '../../../../core/utils/local_storage_utils.dart';
import '../../../../core/utils/show_loading_dialog.dart';
import '../../../../core/utils/step_upload_file_provider.dart';
import '../../../../core/widgets/bread_crumbs.dart';
import '../../domain/entities/external_exam_entity.dart';
import '../../domain/entities/upload_file_entity.dart';
import '../../domain/entities/upload_file_response_entity.dart';
import '../cubits/exam_cubit.dart';
import '../widgets/error_upload_bottom_sheet.dart';
import '../widgets/file_progress_widget.dart';
import '../widgets/input_exam_text_field_widget.dart';
import '../widgets/list_tile_check_widget.dart';
import '../widgets/search_text_field_widget.dart';

class UploadStepsPage extends StatefulWidget {
  const UploadStepsPage({Key? key}) : super(key: key);

  @override
  State<UploadStepsPage> createState() => _UploadStepsPageState();
}

class Step1Model {
  final String title;
  final String subTitle;
  final int value;

  Step1Model({
    required this.title,
    required this.subTitle,
    required this.value,
  });
}

class _UploadStepsPageState extends State<UploadStepsPage> {
  final ValueNotifier<bool> _isValidPage = ValueNotifier<bool>(false);
  final ValueNotifier<int> _currentStep = ValueNotifier<int>(0);
  final List<Widget> bodyWidgets = [];
  late String localization;
  late ExternalExamEntity externalExamEntity = ExternalExamEntity(
    examType: 0,
    executionDate: DateTime.now(),
    uploadDate: DateTime.now(),
  );
  late ExamCubit _cubit;
  late FileEntity fileEntity;
  late StepUploadFileProvider _serviceProgress;

  Future<UploadFileResponseEntity?> _sendFile() async => await _cubit.uploadExternalFile(
        uploadFileEntity: UploadFileEntity(
          file: base64.encode(fileEntity.bytes!),
          fileName: fileEntity.fileName,
        ),
      );
  //! tela 1
  final ValueNotifier<int?> selectedStep1 = ValueNotifier<int?>(null);

  final List<Step1Model> step1 = [
    Step1Model(
      title: LABORATORY_EXAM.translate(),
      subTitle: LABORATORY_EXAM_TYPE.translate(),
      value: 1,
    ),
    Step1Model(
      title: DIAGNOSTIC_IMAGE.translate(),
      subTitle: DIAGNOSTIC_IMAGE_TYPE.translate(),
      value: 2,
    ),
  ];

  //! tela 2
  late TextEditingController _examController;
  //! tela 3
  late TextEditingController _searchController;
  final List<String> step3 = [
    'A+ Medicina Diagnóstica',
    'ACHL Serviços Médicos Ltda.',
    'AFIP - Associação Fundo de Incentivo à Pesquisa',
    'Aliance Medical',
    'Alta Excelência Diagnóstica',
    'Álvaro Apoio',
    'ANATOMED',
    'Antonello',
    'Atalaia',
    'Audibel',
    'Audiomed Clínica Médica',
    'Bem Estar Diagnósticos',
    'Beneficiência Nipo Brasileira de São Paulo',
    'BIESP',
    'Bioanálise',
    'Bioclínico',
    'BIOLAB - Laboratório de Análises Clínicas',
    'Biolabor - Medicina Diagnóstica',
    'Bronstein Medicina Diagnóstica',
    'CAFT - Centro de Avaliação Física',
    'Campana',
    'CAP Centro Diagnóstico',
    'Cardiocalil Medicina Diagnóstica',
    'Cardiofitness',
    'Cardiolab',
    'CDB - Centro de Diagnósticos Brasil',
    'CDE Diagnóstico por Imagem',
    'CDL Laboratório Santos e Vidal',
    'CDPI Diagnóstico por Imagem',
    'CECAM - Centro de Cardiologia Morumbi',
    'CEDAP',
    'Cedic Cedilab',
    'CEDIRP Tecnologia a Serviço da Vida',
    'CEGED Centro de Gastroenterologia',
    'Célula Mater',
    'CEMOI Centro Médico Ltda',
    'Centro de Diagnose em Otorrinolaringologia Unidade Santo Amaro',
    'Centro de Diagnósticco de Anatomia Patológica Dr. Gilles Landman S/C Ltda',
    'Centro de Diagnóstico Artur Parada',
    'Centro de Diagnóstico em Cardiologia',
    'Centro de Endocrinologia',
    'Centro Diagnóstico Poços de Caldas',
    'Centro Integrado de Anatomia Patológica Brasília',
    'Centro Lab Indaiatuba',
    'Centro Médico Docent La Trinidad',
    'Centro Paulista de Endoscopia',
    'CentroCard Bauru',
    'CEOG',
    'CEOL Otorrino',
    'Cerpe',
    'Cerpe Prime',
    'CETAC',
    'CETAM',
    'Check-up Qual Vida',
    'ChromaTox',
    'CICAP',
    'CientíficaLab Tecnologia em Diagnósticos',
    'CIESDI',
    'CIM',
    'CINCOR - Centro Integrado do Coração',
    'CIPAX',
    'Citoprev',
    'Clínica Antonaccio Vascular',
    'Clínica ARO',
    'Clínica Asayama Rossini',
    'Clínica Cor & Ar',
    'Clínica de Aparelho Digestivo',
    'Clínica de Diagnóstico por Imagem',
    'Clínica de Ecografia de Avaliação Fetal de Brasília',
    'Clínica de Otorrino e Otoneuro',
    'Clínica de Radiologia Beroaldo Jurema',
    'Clínica de Radiologia e Ultra',
    'Clínica Dr. Sérgio Szklarz',
    'Clínica e Cirurgia Otoneurologia',
    'Clínica Fares',
    'Clínica Gobbo',
    'Clínica Guerini',
    'Clínica Lobo',
    'Clínica Luiz Felippe Mattoso',
    'Clínica Médica Lapin',
    'Clínica Medicina da Mulher ',
    'Clínica Neurológica Prof. Dr. Jorge Pagura',
    'Clínica Orel',
    'Clínica OtoPlus',
    'Clínica Prof. J. A. Pinotti',
    'Clínica Santa Maria',
    'Clínica Schmillevitch',
    'Clínica SER Diagnóstico por Imagem',
    'Clínica Sherrington',
    'Clínica Trajano',
    'Clínica Zenntai',
    'CMDI – Centro Médico Diagnósticos por Imagem',
    'CML Medicina Laboratorial',
    'Competition',
    'Consultoria em Dermatologia',
    'Contexto Consultoria e Clínica',
    'COPASTAR',
    'CPClin - Centro de Pesquisas Clínicas',
    'CPGH - Centro Paulista de Gastroenterologia e Hepatologia',
    'CPR - Centro Paulista de Recuperação',
    'CRYA Medicina Diagnóstica',
    'CURA Medicina Diagnóstica',
    'Cytolab Medicina Diagnóstica',
    'Delboni Auriemo',
    'Delfin Imagem',
    'Deliberato Análises Clínicas',
    'Dermatologia Dr. Aldo Toschi',
    'Diagmed Medicina Diagnóstica',
    'Diagnose',
    'Diagnosis',
    'Diagnóstica Patologia Cirúrgica e Citologia',
    'Diagnóstika',
    'Digimagem',
    'DNA Life',
    'Dr. Alfredo Augusto Eyer Rodrigues',
    'Dr. Ghelfond Diagnóstico Médico',
    'Dr. Jota Rodrigues',
    'Dr. Ricardo João Wetphaf',
    'Dr. Sang Cha',
    'Dra. Denise Marta',
    'Elkis e Furlanetto Laboratório Médico S/C Ltda',
    'Embrio Consult',
    'Endoclínica',
    'Eucor Centro Cardiológico e Diagnósticos',
    'Exame - Imagem e Laboratório',
    'Eye Clinic',
    'FEMME Laboratório da Mulher',
    'Filomena M. Carvalho Anatomia Patológica',
    'Fischi e Silva Biodiagnósticos',
    'Fitcor Diagnóstico Cardiológicos',
    'Fleming',
    'Fleming Medicina Diagnóstica',
    'Fleury',
    'Foccus Medicina Diagnóstica',
    'Fort-Imagem Diagnóstico por imagem',
    'Franceschi',
    'Frischmann Aisengart',
    'Gastromed Instituto Ziberstein',
    'GeneOne Genômica e Testes Genéticos',
    'Genera',
    'Genoa Biotecnologia',
    'Ghanem',
    'Gilson Cidrim',
    'Grupo Ana Rosa Saúde',
    'Grupo Carmo',
    'Grupo LCA',
    'Grupo São Camilo',
    'Grupobiofast',
    'GSB Lab',
    'Gui de Chauliac Hôpital',
    'Hcor',
    'Helion Povoa Medicina Diagnóstica',
    'Hemat',
    'Hermes Pardini',
    'HN: Complexo Hospitalar de Niterói',
    'Hospital A.C. Camargo',
    'Hospital Adventista de Manaus',
    'Hospital Alemão Oswaldo Cruz',
    'Hospital Bandeirantes',
    'Hospital Beneficiência Portuguesa',
    'Hospital Carlos Fernando Malzoni',
    'Hospital CUF',
    'Hospital da Luz',
    'Hospital das Clínicas',
    'Hospital do Coração do Brasil',
    'Hospital do Rim e Hipertensão',
    'Hospital e Maternidade Bartira',
    'Hospital e Maternidade Brasil',
    'Hospital e Maternidade Brasília',
    'Hospital e Maternidade Christóvão da Gama',
    'Hospital e Maternidade Femina',
    'Hospital e Maternidade Santa Joana',
    'Hospital e Maternidade Santo Alberto',
    'Hospital e Maternidade São Carlos',
    'Hospital Edmund Vasconcellos',
    'Hospital Leforte',
    'Hospital Nove de Julho',
    'Hospital Paulista',
    'Hospital Português',
    'Hospital Procor',
    'Hospital Samaritano',
    'Hospital Sancta Maggiore',
    'Hospital Santa Catarina',
    'Hospital Santa Cruz',
    'Hospital Santa Helena',
    'Hospital Santa Ignes',
    'Hospital Santa Isabel',
    'Hospital Santa Júlia',
    'Hospital Santa Luiza',
    'Hospital Santa Marcelina',
    'Hospital Santa Paula',
    'Hospital São Caetano',
    'Hospital São Camilo',
    'Hospital São Domingos',
    'Hospital São José',
    'Hospital São Luiz',
    'Hospital Sírio-Libanês',
    'Hospital Unimed',
    'Hospital Universitário da USP',
    'IAFE - Instituto de Avaliação Física do Esporte',
    'ICP',
    'IGCC - Insituto de Gastroenterologia e Cirurgia de Campinas',
    'InBody',
    'inSitus Genética',
    'Insituto do Coração',
    'Instituto Avançado de Imagem',
    'Instituto de Diagnósticos',
    'Instituto do Sono',
    'Instituto Domingo Braile',
    'Instituto Educacional Criesp',
    'Instituto Procardíaco',
    'IRO',
    'ItuLab',
    'Kyoei S/A',
    'Lab Hormon',
    'Labcenter',
    'Labchecap',
    'Labclin',
    'Labi Exames',
    'LABO',
    'Laboratório Álvaro',
    'Laboratório Álvaro',
    'Laboratório Amaral Costa',
    'Laboratório Analys Patologia',
    'Laboratório Becker',
    'Laboratório Behring',
    'Laboratório Bellato',
    'Laboratório Bioclínico',
    'Laboratório Dairton Miranda',
    'Laboratório de Imunopatologia de Brasília',
    'Laboratório Dr. Coutinho',
    'Laboratório Dra. Darcy Monteiro',
    'Laboratório Ferdinando Costa',
    'Laboratório Gaspar',
    'Laboratório Hemato',
    'Laboratório Incor',
    'Laboratório Koch',
    'Laboratório Lab',
    'Laboratório Laborcont',
    'Laboratório Locus',
    'Laboratório Oswaldo Cruz',
    'Laboratório Paulista de Dermatologia',
    'Laboratório Prolab',
    'Laboratório Richet',
    'Laboratório São Francisco',
    'Laboratório Senhor dos Passos',
    'Laboratório Vera Cruz',
    'Laborfase Padrão',
    'Laborlider Laboratório',
    'LABPAC',
    'Labs Cardiolab',
    "Labs D'Or",
    'Labs Maracanã',
    'LabSim',
    'Lâmina',
    'LAPAC',
    'Lavoisier',
    'Lego Laboratório',
    'Leme Image',
    'LGED',
    'LGEDSP',
    'Linhas Aéreas Tam',
    'Lunav Análises Clínicas',
    'Magscan',
    'Malva Valeria Fonoaudiologia',
    'Martins & Godoy',
    'Mater Dei',
    'Mattosinho',
    'Medceu',
    'Medcor - Centro Médico Cardiológico',
    'Medical',
    'Medison do Brasil',
    'Medradius',
    'Megaimagem',
    'Middle East Institute of Health',
    'MKP Atendimento Médico',
    'Multimagem Clínica de Imagem',
    'Multipat Anatomia Patológica',
    'NotreLabs',
    'Nova Medicina Diagnóstica',
    'Núcleo de Análises Clínicas Ltda',
    'Nucleomed Medicina Nuclear ',
    'OMNI-CCNI Medicina Diagnóstica',
    'Otoclínica',
    'Padrão Ribeirão Medicina Diagnóstica ',
    'Paraná Clínicas',
    'Pasteur',
    'Paulo C. Azevedo',
    'PEC - Patologia Especializada e Citologia Ltda.',
    'Phatos',
    'PhD Laboratório de Patologia Cirúrgica e Molecular',
    'Plani',
    'PMSP Lapa',
    'Prando',
    'Prevcor',
    'Previlab',
    'Previlab',
    'Pro AR',
    'Pro Echo Diagnósticos',
    'Prócoração',
    'Procto Brasília',
    'ProctoGastro Clínica',
    'Prod Imagem – Clínicas de Radiologia e Diagnóstico',
    'Prof. Dr. Faluze Maluf Filho',
    'PROFERT Produção Assistida',
    'Promed Medicina Diagnóstica',
    'Provato Diagnóstico',
    'Quaglia',
    'Quality Lab',
    'RCC - Radiologia Clínica de Campinas Ltda.',
    'RDO Diagnósticos Médicos',
    'Renacor',
    'Rhesus Medicina Auxiliar',
    'Richet',
    'RitmoLab',
    'RMC',
    'Rocha Lima',
    'Sabin Laboratório Clínico',
    'SAD Laboratório',
    'Salomão Zoppi',
    'Sancet',
    'Santa Casa de Misericórdia',
    'Santa Luzia',
    'São Camilo Medicina Diagnóstica',
    'São Carlos Imagem',
    'São Lucas Hospital Copacabana',
    'São Marcos',
    'SB Clinical Laboratories',
    'Sérgio Franco Medicina Diagnóstica',
    'Sigma',
    'Slab',
    'Spamed',
    'Spectra',
    'SUS - Sistema Único de Saúde',
    'SYNLAB',
    'TEB',
    'Tecnolab',
    'Tomo Med Centro de Diagnóstico e Tratamento S/C Ltda',
    'Total Care',
    'Total Laboratórios',
    'Transduson',
    'Trianálises',
    'Ultraimagem',
    'Ultramed',
    'Unidade Ambolatorial',
    'Unidade de Fígado de Brasília',
    'Unidade Ecográfica Paulista',
    'Unilab',
    'Unimagem',
    'Unitha Diagnósticos e Saúde',
    'URO Centro de Excelência em Urologia',
    'Urocons',
    'URP',
    'ValeClin',
    'Vila Rica Medicina Diagnóstica',
    'Viva Medicina Diagnóstica',
    'Weinmann',
    'Wiermann & Miranda',
    'Outros',
  ];
  // 'A+',
  // 'Alta Diagnósticos',
  // 'CDB',
  // 'Delboni',
  // 'Fleury',
  // 'Hermes Pardini',
  // 'Lavoisier',
  // 'Oswaldo Cruz',
  // 'Salomão Zoppi',
  final ValueNotifier<String?> selectedStep3 = ValueNotifier<String?>(null);
  final filter = ValueNotifier<List<String>>([]);

  //! tela 4
  final RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.disabled;
  final DateTime _focusedDay = DateTime.now();
  final _selectedDay = ValueNotifier<DateTime?>(null);
  late TextEditingController _dateExamController;
  final _formKeyDate = GlobalKey<FormState>();
  void _filterList(String search) {
    List<String> result = [];
    result = search.isEmpty
        ? step3
        : step3
            .where(
              (e) => e.toLowerCase().contains(search.toLowerCase()),
            )
            .toList();
    filter.value = result;
  }

  @override
  void initState() {
    super.initState();
    filter.value = step3;
    _examController = TextEditingController();
    _searchController = TextEditingController();
    _dateExamController = TextEditingController();
    _serviceProgress = I.getDependency<StepUploadFileProvider>()..updateProgress(sent: null, total: null);

    _cubit = I.getDependency<ExamCubit>();
    _initBodyList();
    final user = I.getDependency<UserAuthInfoEntity>();
    localization = user.localization;
  }

  bool loadedData = false;

  UploadFileResponseEntity? fileResultPath;
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (!loadedData) {
      loadedData = true;
      fileEntity = ModalRoute.of(context)?.settings.arguments as FileEntity;

      fileResultPath = await _sendFile();

      if (fileResultPath == null) {
        Navigator.of(context).pop();

        return erroUploadBottomSheet(
          ContextUtil().context!,
          ERROR_MSG_UPLOAD.translate(),
          onButtonPressed: () {
            Navigator.pop(ContextUtil().context!);
          },
        );
      } else {
        externalExamEntity = externalExamEntity.copyWith(
          fileId: fileResultPath?.id,
          // examName: //! Tela 2 - o usuario digita
          // medicalRecords: //! pegar do localStorage
          medicalRecords: getUserIdentifier(),
          path: fileResultPath?.path,
          // labName: //! Tela 3 - passar o nome que está na listagem de checkbox
          // examType: //! Tela 1 - o mesmo q o filtro - valores de 1 ou 2
          // executionDate:
          url: fileResultPath?.urlFile,
          uploadDate: DateTime.now(),
        );
      }
    }
  }

  @override
  void dispose() {
    // _serviceProgress.dispose();
    _searchController.dispose();
    _examController.dispose();
    _dateExamController.dispose();
    super.dispose();
  }

  InputBorder border = OutlineInputBorder(
    borderSide: BorderSide(
      color: ZeraColors.neutralLight03,
      width: 1,
    ),
    borderRadius: BorderRadius.circular(4.0),
  );
  void _initBodyList() {
    bodyWidgets.addAll(
      [
        // PAGE 1
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            ZeraText(
              SELECT_EXAM_CATEGORY.translate(),
              type: ZeraTextType.BOLD_MEDIUM_16_DARK_01,
            ),
            const SizedBox(height: 16),
            ZeraDivider(),
            AnimatedBuilder(
              animation: selectedStep1,
              builder: (context, widget) => ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) => ListTileCheckWidget(
                  title: step1[index].title,
                  subTitle: step1[index].subTitle,
                  targetValue: step1[index].value,
                  value: selectedStep1.value,
                  onTap: () {
                    selectedStep1.value = step1[index].value;
                    externalExamEntity = externalExamEntity.copyWith(
                      examType: step1[index].value,
                    );
                    _isValidPage.value = true;
                  },
                ),
                separatorBuilder: (context, index) => ZeraDivider(),
                itemCount: step1.length,
              ),
            ),
            ZeraDivider(),
          ],
        ),
        // PAGE 2
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            ZeraText(
              ENTER_EXAM_TITLE.translate(),
              type: ZeraTextType.BOLD_MEDIUM_16_DARK_01,
            ),
            const SizedBox(height: 16),
            InputExamTextFieldWidget(
              key: const Key('exam_name'),
              controller: _examController,
              hintText: ENTER_THE_EXAM_NAME.translate(),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  _isValidPage.value = true;
                  externalExamEntity = externalExamEntity.copyWith(
                    examName: value,
                  );
                } else {
                  _isValidPage.value = false;
                }
              },
            ),
          ],
        ),
        // PAGE 3
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              ZeraText(
                SELECT_THE_RESPONSIBLE_LABORATORY.translate(),
                type: ZeraTextType.BOLD_MEDIUM_16_DARK_01,
              ),
              const SizedBox(height: 16),
              SearchTextFieldWidget(
                key: const Key('search_lab'),
                controller: null,
                hintText: SEARCH_LAB.translate(),
                onChanged: (value) {
                  _filterList(value);
                },
              ),
              const SizedBox(height: 16),
              ZeraDivider(),
              AnimatedBuilder(
                animation: Listenable.merge([selectedStep3, filter]),
                builder: (context, widget) => Expanded(
                  child: ListView.separated(
                    key: const Key('uploadSteps_labName'),
                    physics: const NeverScrollableScrollPhysics(),
                    // shrinkWrap: true,
                    // primary: false,
                    addAutomaticKeepAlives: false,
                    addRepaintBoundaries: false,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) => ListTileCheckWidget(
                      title: filter.value[index],
                      targetValue: filter.value[index],
                      value: selectedStep3.value,
                      onTap: () {
                        selectedStep3.value = filter.value[index];
                        externalExamEntity = externalExamEntity.copyWith(
                          labName: filter.value[index],
                        );
                        _isValidPage.value = true;
                      },
                    ),
                    separatorBuilder: (context, index) => ZeraDivider(),
                    itemCount: filter.value.length,
                  ),
                ),
              ),
            ],
          ),
        ),
        // PAGE 4
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            ZeraText(
              ENTER_THE_COMPLETION_DATE.translate(),
              type: ZeraTextType.BOLD_MEDIUM_16_DARK_01,
            ),
            const SizedBox(height: 16),
            Form(
              key: _formKeyDate,
              // child: ZeraTextFieldWidget(
              child: ZeraTextField(
                controller: _dateExamController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                inputFormatter: [
                  TextInputMask(mask: '99/99/9999'),
                ],
                keyboardType: TextInputType.datetime,
                autovalidate: false,
                validator: (String? value) {
                  if ((value?.length ?? 0) < 10) {
                    return null;
                  }
                  if (value?.validStringToDateTime() ?? false) {
                    // deixa adicionar data de agora e datas passada;
                    if (DateTime.now().compareTo(value!.stringDatePtBrToDateTime()) <= 0) {
                      return THE_DATE_ENTERED_CANNOT_BE_IN_THE_FUTURE.translate();
                    }
                    // sucesso
                    externalExamEntity = externalExamEntity.copyWith(
                      executionDate: value.stringDatePtBrToDateTime(),
                    );
                    _isValidPage.value = true;
                    return null;
                  } else {
                    return THE_DATE_ENTERED_IS_NOT_VALID.translate();
                  }
                },
                // labelText: 'dd/mm/aaa',
                placeholder: 'dd/mm/aaa',
                onChanged: (value) {
                  _isValidPage.value = false;
                  _formKeyDate.currentState?.validate();
                },
                suffixIcon: const Icon(
                  ZeraIcons.calendar,
                  color: Color(0xFF1B1C1D),
                  size: 24.0,
                ),
              ),
            ),

            // TextFormField(
            //   inputFormatters: [
            //     TextInputMask(mask: '99/99/9999'),
            //   ],
            //   onChanged: (value) {
            //     _isValidPage.value = false;
            //     _formKeyDate.currentState?.validate();
            //   },
            //   validator: (value) {
            //     if ((value?.length ?? 0) < 10) {
            //       return null;
            //     }
            //     if (value?.validStringToDateTime() ?? false) {
            //       // deixa adicionar data de agora e datas passada;
            //       if (DateTime.now().compareTo(value!.stringDatePtBrToDateTime()) <= 0) {
            //         return 'Não adicione datas futuras';
            //       }
            //       // sucesso
            //       externalExamEntity = externalExamEntity.copyWith(
            //         executionDate: value.stringDatePtBrToDateTime(),
            //       );
            //       _isValidPage.value = true;
            //       return null;
            //     } else {
            //       return 'Data inválida';
            //     }
            //   },
            //   controller: _dateExamController,
            //   readOnly: false,
            //   keyboardType: TextInputType.datetime,
            //   decoration: InputDecoration(
            //     counterText: '',
            //     border: border,
            //     focusedBorder: border,
            //     enabledBorder: border,
            //     errorBorder: border,
            //     focusedErrorBorder: border,
            //     fillColor: ZeraColors.neutralLight,
            //     filled: true,
            //     hintText: 'dd/mm/aaaa',
            //     hintStyle: TextStyle(
            //       color: ZeraColors.neutralDark03,
            //       fontSize: 16.0,
            //       fontWeight: FontWeight.w400,
            //     ),
            //     contentPadding: const EdgeInsets.only(
            //       top: 8.0,
            //       bottom: 8.0,
            //       left: 16,
            //     ),
            //     suffixIcon: Icon(
            //       ZeraIcons.calendar,
            //       color: ZeraColors.primaryMedium,
            //       size: 24.0,
            //     ),
            //   ),
            // ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) => ZeraScaffold(
        extendBody: true,
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(
            bottom: 24,
            left: 16,
            right: 16,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 343),
                // constraints: const BoxConstraints(maxWidth: 143),
                child: AnimatedBuilder(
                  animation: _isValidPage,
                  builder: (context, widget) => ZeraButton(
                    onPressed: _isValidPage.value
                        ? () async {
                            if (bodyWidgets.length > (_currentStep.value + 1)) {
                              _currentStep.value++;
                              _isValidPage.value = false;
                            } else if (fileResultPath != null) {
                              ExternalExamEntity? externalExam;
                              await showLoadingDialog(
                                context: context,
                                action: () async {
                                  externalExam = await _cubit.saveExternalFile(
                                    externalExamEntity: externalExamEntity,
                                  );
                                },
                              );
                              Navigator.of(context).pop(externalExam);
                            }
                          }
                        : null,
                    text: _currentStep.value < 3 ? CONTINUE.translate() : SAVE.translate(),
                    style: _isValidPage.value ? ZeraButtonStyle.PRIMARY_DARK : ZeraButtonStyle.PRIMARY_DISABLE,
                    theme: ZeraButtonTheme(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Center(
          child: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) => [
              SliverOverlapAbsorber(
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverToBoxAdapter(
                  child: Center(
                    child: Container(
                      constraints: const BoxConstraints(
                        maxWidth: 1200,
                      ),
                      width: double.infinity,
                      padding: const EdgeInsets.only(
                          // bottom: 80,
                          ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (kIsWeb)
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 16,
                                right: 16,
                                top: 16,
                              ),
                              child: BreadCrumbs(
                                listBreadCrumbs: fileEntity.showMyExamsStep
                                    ? [
                                        EXAM_RESULTS.translate(),
                                        MY_EXAMS.translate(),
                                        IMPORT_EXAMS.translate(),
                                      ]
                                    : [
                                        EXAM_RESULTS.translate(),
                                        IMPORT_EXAMS.translate(),
                                      ],
                              ),
                            ),
                          SizedBox(
                            height: kIsWeb ? kNavBarHeight : kNavBarHeight + 20,
                            child: AppBar(
                              elevation: 0,
                              automaticallyImplyLeading: false,
                              backgroundColor: Colors.transparent,
                              leading: ZeraIconButton(
                                onPressed: () {
                                  if (_currentStep.value > 0) {
                                    --_currentStep.value;
                                    _isValidPage.value = true;
                                  } else {
                                    Navigator.of(context).pop();
                                  }
                                },
                                icon: ZeraIcons.arrow_left_1,
                                // iconColor: iconColor,
                                style: ZeraIconButtonStyle.ICON_CLOSE,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(left: 16),
                            child: ZeraText(
                              IMPORT_EXAMS.translate(),
                              type: ZeraTextType.MEDIUM_20_NEUTRAL_DARK,
                              theme: const ZeraTextTheme(
                                fontWeight: FontWeight.w700,
                                fontSize: 20.0,
                                fontStyle: FontStyle.normal,
                                fontFamily: 'Montserrat',
                                lineHeight: 1.5,
                              ),
                            ),
                          ),
                          Center(
                            child: Container(
                              constraints: const BoxConstraints(maxWidth: 688),
                              // padding: const EdgeInsets.all(16),
                              padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 36),
                                  FileProgressWidget(
                                    fileEntity: fileEntity,
                                    service: _serviceProgress,
                                  ),
                                  const SizedBox(height: 40),
                                  AnimatedBuilder(
                                    animation: _currentStep,
                                    builder: (context, widget) => ZeraText(
                                      '${STEP.translate()} ${_currentStep.value + 1} ${OF.translate()} ${bodyWidgets.length}',
                                      color: ZeraColors.neutralDark01,
                                      theme: const ZeraTextTheme(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14.0,
                                        fontStyle: FontStyle.normal,
                                        fontFamily: 'Montserrat',
                                        lineHeight: 1.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
            // floatHeaderSlivers: true,
            body: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 688),
                // padding: const EdgeInsets.all(16),
                padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    AnimatedBuilder(
                      animation: _currentStep,
                      builder: (context, widget) => bodyWidgets[_currentStep.value],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
