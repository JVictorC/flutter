import 'dart:async';
import 'dart:convert';

import 'package:base_dependencies/dependencies.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../core/adapters/priting/printing_adapter.dart';
import '../../../../core/adapters/share/share_adapter.dart';
import '../../../../core/adapters/share/share_interface.dart';
import '../../../../core/constants/assets_constants.dart';
import '../../../../core/constants/parameters_constants.dart';
import '../../../../core/constants/routes.dart';
import '../../../../core/constants/strings.dart';
import '../../../../core/extensions/mobile_size_extension.dart';
import '../../../../core/extensions/string_extension.dart';
import '../../../../core/extensions/translate_extension.dart';
import '../../../../core/utils/local_storage_utils.dart';
import '../../../../core/utils/micro_app_colors.dart';
import '../../../../core/utils/show_loading_dialog.dart';
import '../../../../core/widgets/card_detail_exam.dart';
import '../../domain/entities/exam_entity.dart';
import '../../domain/entities/exam_pdf_result_entity.dart';
import '../../domain/entities/external_exam_file_entity.dart';
import '../../domain/entities/external_exam_file_req_entity.dart';
import '../../domain/entities/load_exams_entity.dart';
import '../../domain/entities/medical_appointment_list_result_exams_entity.dart';
import '../../domain/usecases/get_pdf_result_usecase.dart';
import 'action_button_list_exam.dart';
import 'exam_check_box.dart';

const double defaultLeftPaddingPage = DEFAULT_LEFT_PADDING + 4;

// ignore: must_be_immutable
class LoadExamsDetails extends StatefulWidget {
  final Function? refreshAfterDelete;
  final Function? multipleShareExams;

  final String? route;
  final Future<MedicalAppointmentListResultExamsEntity?> Function({
    required LoadExamEntity loadExamEntity,
  }) execute;

  Future<void> Function({
    required String id,
  }) removeExternalExam;

  final void Function(int count) updateCount;

  Future<ExamPdfResultEntity?> Function(PdfResultParam param) downloadPDF;

  Future<ExternalExamFileEntity?> Function(
    ExternalExamFileReqEntity param,
  ) downloadExternalPDF;

  final LoadExamEntity loadExamEntity;
  final bool enableCheckBox;
  final List<ExamEntity>? listExam;
  final List<String> shareList;
  final bool userDoctorType;

  LoadExamsDetails({
    required this.removeExternalExam,
    required this.shareList,
    required this.execute,
    required this.downloadPDF,
    required this.downloadExternalPDF,
    required this.loadExamEntity,
    required this.enableCheckBox,
    required this.listExam,
    required this.updateCount,
    required this.refreshAfterDelete,
    required this.multipleShareExams,
    this.route,
    this.userDoctorType = false,
    Key? key,
  }) : super(key: key);

  @override
  State<LoadExamsDetails> createState() => _LoadExamsDetailsState();
}

class _LoadExamsDetailsState extends State<LoadExamsDetails> {
  int crossAxisCount = 3;
  double aspectRatioValue = 2;
  double mainAxisExtentValue = 188;
  final List<ExamEntity> _listExam = [];

  late final StreamController<bool> _streamController;

  late bool updateRemoveCard;

  bool? selectAll;

  @override
  void initState() {
    super.initState();
    updateRemoveCard = false;
    _streamController = StreamController<bool>.broadcast();
  }

  @override
  void dispose() {
    _streamController.close();

    super.dispose();
  }

  String getImageIcon(int examType) {
    Map<int, String> dataImage = {
      1: LAB_WHISK_CUP,
      2: RADIOLOGY_SCAN,
      3: EXAM_FILE,
    };

    return dataImage[examType]!;
  }

  Color getColorCard(int examType) {
    Map<int, Color> dataColor = {
      1: MicroAppColors.customGreenCardColor,
      2: MicroAppColors.customBlueCardColor,
      3: MicroAppColors.customYellowCardColor,
    };

    return dataColor[examType]!;
  }

  Future<List<ExamEntity>> _loadList() async {
    List<String>? listIdExternalExam = getExternalExamIdStorage();

    if (_listExam.isEmpty) {
      final exams = await widget.execute(loadExamEntity: widget.loadExamEntity);

      if (exams!.resultInternalExam.isNotEmpty) {
        for (var element in exams.resultInternalExam) {
          _listExam.addAll(element.listExam);
        }
      }

      if (exams.resultExternalExam.isNotEmpty) {
        int position = _listExam.length + 1;

        for (var element in exams.resultExternalExam) {
          bool newFirstViewExam = (listIdExternalExam != null &&
              listIdExternalExam.isNotEmpty &&
              listIdExternalExam.any((idExternal) => idExternal == element.id));

          final exam = ExamEntity(
            fileId: element.fileId,
            path: element.path,
            examType: element.examType,
            executionDate: element.executionDate,
            executionDate2: element.executionDate,
            uploadDate: element.uploadDate,
            labName: element.labName,
            examId: element.id,
            examName: element.examName,
            laudoFile: element.path,
            url1: element.url,
            idMedicalRecords: element.medicalRecords,
            position: position,
            passType: null,
            statusResult: 0,
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
          exam.newFirstViewExam = newFirstViewExam;

          _listExam.add(
            exam,
          );

          position++;
        }
      }
    } else if (listIdExternalExam != null &&
        listIdExternalExam.isNotEmpty &&
        _listExam.any((element) => element.newFirstViewExam == true)) {
      final copyListExamExternal = _listExam
          .where((element) => element.newFirstViewExam == true)
          .toList();

      _listExam.removeWhere((element) => element.newFirstViewExam == true);

      for (var element in copyListExamExternal) {
        if (element.newFirstViewExam == true &&
            !listIdExternalExam.contains(element.examId)) {
          element.newFirstViewExam = false;
        }
        _listExam.add(element);
      }
    } else if (_listExam.any((element) => element.newFirstViewExam == true)) {
      for (var element in _listExam) {
        element.newFirstViewExam = false;
      }
    }

    return _listExam;
  }

  Widget _examDetails({required List<ExamEntity>? data}) {
    if (context.isMobile() || MediaQuery.of(context).size.width <= 770) {
      crossAxisCount = 1;

      if (MediaQuery.of(context).size.width >= 690) {
        aspectRatioValue = 4;
        mainAxisExtentValue = 188;
      } else if (MediaQuery.of(context).size.width >= 610) {
        aspectRatioValue = 3.5;
        mainAxisExtentValue = 188;
      } else if (MediaQuery.of(context).size.width >= 520) {
        aspectRatioValue = 3;
        mainAxisExtentValue = 188;
      } else if (MediaQuery.of(context).size.width >= 370) {
        aspectRatioValue = 2.0;
        mainAxisExtentValue = 188;
      } else {
        aspectRatioValue = 2.6;
        mainAxisExtentValue = 188;
      }
    } else if (MediaQuery.of(context).size.width >= 1200) {
      crossAxisCount = 3;
      aspectRatioValue = 2;
      mainAxisExtentValue = 195;
    } else if (MediaQuery.of(context).size.width >= 1150) {
      crossAxisCount = 3;
      aspectRatioValue = 2;
      mainAxisExtentValue = 188;
    } else {
      crossAxisCount = 2;
      mainAxisExtentValue = 188;

      if (MediaQuery.of(context).size.width >= 1050) {
        aspectRatioValue = 3;
      } else if (MediaQuery.of(context).size.width >= 950) {
        aspectRatioValue = 2.5;
      }

      if (MediaQuery.of(context).size.width <= 800) {
        mainAxisExtentValue = 195;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: widget.enableCheckBox,
          child: Container(
            alignment: Alignment.centerRight,
            height: 30.0,
            padding: const EdgeInsets.only(bottom: 5.0),
            child: ExamCheckBox(
              defaultValue: null,
              title: SELECT_ALL.translate(),
              action: (value) {
                if (value) {
                  for (var element in data!
                      .where(
                        (element) => element.statusResult != 4,
                      )
                      .toList()) {
                    if (!widget.shareList.contains(element.examId!)) {
                      widget.shareList.add(element.examId!);
                    }
                  }
                } else {
                  for (var element in data!) {
                    widget.shareList
                        .removeWhere((value) => value == element.examId!);
                  }
                }
                widget.updateCount(widget.shareList.length);
                selectAll = value;
                _streamController.sink.add(value);
              },
            ),
          ),
        ),
        StreamBuilder<bool>(
          stream: _streamController.stream,
          initialData: false,
          builder: (context, snapshot) => GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: aspectRatioValue,
              mainAxisExtent: mainAxisExtentValue,
            ),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: data?.length ?? 0,
            itemBuilder: (context, index) => CardDetailExam(
              checkedCard: widget.shareList.contains(data![index].examId),

              visibleTargetNew: data[index].newFirstViewExam ?? false,
              actionIcon: widget.enableCheckBox && data[index].statusResult != 4
                  ? Padding(
                      padding: const EdgeInsets.only(
                        right: 5,
                      ),
                      child: ExamCheckBox(
                        defaultValue: selectAll ??
                            widget.shareList.contains(data[index].examId),
                        title: null,
                        action: (value) {
                          if (value) {
                            if (!widget.shareList
                                .contains(data[index].examId)) {
                              widget.shareList.add(data[index].examId!);
                            }
                          } else {
                            widget.shareList.removeWhere(
                              (element) => element == data[index].examId,
                            );
                          }
                          widget.updateCount(widget.shareList.length);
                          selectAll = null;
                          _streamController.sink.add(value);
                        },
                      ),
                    )
                  : data[index].statusResult == 4 // aguardando
                      ? SizedBox(
                          width: context.isMobile() ? 40 : 70.0,
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: context.isMobile() ? 5 : 0,
                              ),
                              child: Icon(
                                ZeraIcons.time_clock_circle,
                                size: 16.0,
                                color: ZeraColors.neutralDark02,
                              ),
                            ),
                          ),
                        )
                      : widget.userDoctorType
                          ? null
                          : ActionButtonListExam(
                              multipleShareExams: widget.multipleShareExams,
                              visibleRemoveExternalExam:
                                  data[index].externalExam ?? false,
                              remove: () async {
                                await showLoadingDialog(
                                  context: context,
                                  action: () async {
                                    final id = data[index].examId!;
                                    await widget.removeExternalExam(
                                      id: id,
                                    );

                                    data.removeWhere(
                                      (element) => element.examId == id,
                                    );
                                    //updateRemoveCard = !updateRemoveCard;
                                    _streamController.sink.add(true);
                                  },
                                );

                                if (widget.refreshAfterDelete != null &&
                                    data.isEmpty) {
                                  widget.refreshAfterDelete!();
                                }

                                if (context.isMobile()) {
                                  Navigator.of(context).pop();
                                }
                              },
                              share: () async {
                                showLoadingDialog(
                                  context: context,
                                  action: () async {
                                    if (data[index].fileId != null &&
                                        data[index].fileId!.trim().isNotEmpty) {
                                      final result =
                                          await widget.downloadExternalPDF(
                                        ExternalExamFileReqEntity(
                                          file: data[index].fileId!,
                                          path: data[index].path!,
                                        ),
                                      );

                                      if (result != null) {
                                        final file =
                                            await result.file.base64ToFile(
                                          fileName:
                                              'exam.${result.path.split('.').last.toUpperCase()}',
                                          openFileAfterConvert: false,
                                        );

                                        if (file != null &&
                                            await file.exists()) {
                                          final IShareAdapter share =
                                              ShareAdapter();
                                          await share.shareFiles(
                                            [file.path],
                                            data[index].examName,
                                          );
                                        }
                                      }
                                    } else {
                                      final result = await widget.downloadPDF(
                                        PdfResultParam(
                                          medicalAppointment:
                                              getUserIdentifier(),
                                          examCode: data[index].examCode,
                                          passage: data[index].passageId,
                                          executionDateBegin:
                                              data[index].executionDate,
                                          executionDateEnd:
                                              data[index].executionDate,
                                          itensIdList:
                                              data[index].examId != null
                                                  ? [data[index].examId!]
                                                  : null,
                                          userType: 0,
                                          examBreak: true,
                                        ),
                                      );

                                      if (result != null) {
                                        final file =
                                            await result.pdfResult.base64ToFile(
                                          fileName:
                                              '${data[index].examName}.pdf',
                                          openFileAfterConvert: false,
                                        );

                                        if (file != null &&
                                            await file.exists()) {
                                          final IShareAdapter share =
                                              ShareAdapter();
                                          await share.shareFiles(
                                            [file.path],
                                            data[index].examName,
                                          );
                                        }
                                      }
                                    }
                                  },
                                );
                              },
                              printOut: () async {
                                ExternalExamFileEntity? fileExam;
                                PrintingAdapter printing = PrintingAdapter();

                                await showLoadingDialog(
                                  context: context,
                                  action: () async {
                                    if (data[index].fileId != null) {
                                      fileExam =
                                          await widget.downloadExternalPDF(
                                        ExternalExamFileReqEntity(
                                          file: data[index].fileId!,
                                          path: data[index].path!,
                                        ),
                                      );
                                    }
                                  },
                                );
                                if (fileExam != null &&
                                    fileExam?.file != null) {
                                  await printing.showLayoutPDF(
                                    file: base64.decode(fileExam!.file),
                                  );
                                }
                              },
                              download: () async {
                                showLoadingDialog(
                                  context: context,
                                  action: () async {
                                    if (data[index].fileId != null) {
                                      final result =
                                          await widget.downloadExternalPDF(
                                        ExternalExamFileReqEntity(
                                          file: data[index].fileId!,
                                          path: data[index].path!,
                                        ),
                                      );

                                      if (result != null) {
                                        await result.file.base64ToFile(
                                          fileName:
                                              'exam.${result.path.split('.').last.toUpperCase()}',
                                          openFileAfterConvert: true,
                                        );
                                      }
                                    } else {
                                      final result = await widget.downloadPDF(
                                        PdfResultParam(
                                          medicalAppointment:
                                              getUserIdentifier(),
                                          examCode: data[index].examCode,
                                          passage: data[index].passageId,
                                          executionDateBegin:
                                              data[index].executionDate,
                                          executionDateEnd:
                                              data[index].executionDate,
                                          itensIdList:
                                              data[index].examId != null
                                                  ? [data[index].examId!]
                                                  : null,
                                          userType: 0,
                                          examBreak: true,
                                        ),
                                      );

                                      if (result != null) {
                                        await result.pdfResult.base64ToFile(
                                          fileName:
                                              '${data[index].examName}.PDF',
                                          openFileAfterConvert: true,
                                        );
                                      }
                                    }
                                  },
                                );
                              },
                            ), //data[index].examId
              paddingLeftBody: kIsWeb
                  ? defaultLeftPaddingPage
                  : context.isTablet()
                      ? 0.0
                      : 20.0,
              onTap: () {
                final routeTap = widget.route ?? Routes.examResultPage;
                Navigator.of(context).pushNamed(
                  routeTap,
                  arguments: data[index],
                );
              },

              title: data[index].examName ?? '',
              localExam: data[index].labName ?? 'Albert Einstein',

              imgIcon: getImageIcon(
                data[index].examType > 0 ? data[index].examType : 1,
              ),
              colorCard: getColorCard(
                data[index].examType > 0 ? data[index].examType : 1,
              ),
              statusResult: data[index].statusResult,
              body: [
                Visibility(
                  visible: data[index].statusResult == 4,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      bottom: 5.0,
                    ),
                    child: ZeraText(
                      '${WAITING_FOR_RESULT_RELEASE.translate()}...',
                      type: ZeraTextType.MEDIUM_12_NEUTRAL_DARK,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) => widget.listExam == null
      ? FutureBuilder<List<ExamEntity>>(
          future: _loadList(),
          builder: (
            BuildContext context,
            AsyncSnapshot<List<ExamEntity>> snapshot,
          ) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? const SizedBox(
                      height: 60.0,
                      width: 60.0,
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : snapshot.data == null
                      ? const SizedBox(
                          height: 20,
                        )
                      : _examDetails(data: snapshot.data!),
        )
      : _examDetails(data: widget.listExam!);
}
