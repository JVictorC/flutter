import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:base_dependencies/dependencies.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/routes.dart';
import '../../../../core/constants/strings.dart';
import '../../../../core/di/initInjector.dart';
import '../../../../core/extensions/translate_extension.dart';
import '../../../../core/utils/show_loading_dialog.dart';
import '../../../../core/widgets/custom_tooltip_widget.dart';
import '../../domain/entities/evolutionary_report_response_entity.dart';
import '../../domain/entities/evolutionary_report_table_entity.dart';
import '../../domain/entities/exams_filters_entity.dart';
import '../../domain/entities/exams_filters_external_entity.dart';
import '../../domain/entities/load_exams_entity.dart';
import '../cubits/exam_cubit.dart';
import 'draggable_scrollbar_widget.dart';

class EvolutionaryReportTable extends StatefulWidget {
  final bool openExam;
  final ExamsConsultationEntity examsConsultation;
  const EvolutionaryReportTable({
    required this.examsConsultation,
    this.openExam = true,
    Key? key,
  }) : super(key: key);

  @override
  State<EvolutionaryReportTable> createState() =>
      _EvolutionaryReportTableState();
}

class _EvolutionaryReportTableState extends State<EvolutionaryReportTable> {
  late final EvolutionaryReportTableEntity tableData;
  final List<DataColumn> listDataColumnHeader = [];
  final List<DataRow> listDataRowTable = [];
  final List<DataRow> listDateRow = [];
  List<DateTime> listDates = [];
  bool referenceValue = false;
  final double rowHeight = 56;
  final double cellWidth = 145;
  late double paddingDateTable;
  late final ScrollController _scrollController;
  int limitRecords = 6;
  bool refreshScreen = false;
  double tableHeight = 56;
  late final ExamCubit _cubit;
  bool showLoadExams = true;

  void _loadDates() {
    int totalDate = 0;
    DateTime evolutionaryDate;
    final Map<DateTime, Map<String, String?>> dataExams = {};

    referenceValue = widget.examsConsultation.itensConsultation.any(
      (element) => element.resultsConsultation.any(
        (data) => data.defaultRefValue != null,
      ),
    );

    for (var itensConsultation in widget.examsConsultation.itensConsultation) {
      for (var resultsConsultation in itensConsultation.resultsConsultation) {
        final time = resultsConsultation.hourResult!;
        final date = resultsConsultation.dateResult!;

        evolutionaryDate =
            DateTime(date.year, date.month, date.day, time.hour, time.minute);

        if (!listDates.contains(evolutionaryDate)) {
          listDates.add(evolutionaryDate);

          dataExams[evolutionaryDate] = {
            'passageId': resultsConsultation.idPassageResult,
            'examId': resultsConsultation.idItemResult,
          };
        }
      }
    }

    if (listDates.isNotEmpty) {
      listDates.sort((a, b) => b.compareTo(a));

      totalDate = listDates.length;

      if (limitRecords < listDates.length) {
        final int removeIndex = listDates.length - limitRecords;
        listDates.removeRange(
          ((listDates.length - 1) - removeIndex),
          listDates.length - 1,
        );

        dataExams.removeWhere((key, value) => !listDates.contains(key));
      } else if (showLoadExams) {
        showLoadExams = false;
      }

      if (limitRecords == 6) limitRecords = 10;

      if (listDateRow.isNotEmpty) {
        listDateRow.clear();
      }

      int i = 0;
      for (var date in listDates) {
        final double topRadius = i == 0 && !referenceValue ? 4 : 0;
        final double bottomRadius = i == listDates.length - 1 ? 4 : 0;

        listDateRow.add(
          DataRow(
            cells: [
              DataCell(
                Container(
                  decoration: BoxDecoration(
                    color: ZeraColors.primaryDark,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(topRadius),
                      bottomLeft: Radius.circular(bottomRadius),
                    ),
                  ),

                  padding: const EdgeInsets.only(
                    left: 16,
                  ),
                  width: cellWidth,
                  //color: ZeraColors.primaryDark,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ZeraText(
                        DateFormat('dd/MM/yyyy HH:mm').format(date),
                        color: ZeraColors.white,
                        textAlign: TextAlign.left,
                        theme: const ZeraTextTheme(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Visibility(
                        visible: widget.openExam,
                        child: InkWell(
                          onTap: () async {
                            await showLoadingDialog(
                              context: context,
                              action: () async {
                                final exams = await _cubit.loadExamsDetails(
                                  loadExamEntity: LoadExamEntity(
                                    idItens: null,
                                    medicalAppointment: null,
                                    chAuthentication: null,
                                    results: false,
                                    lab: null,
                                    auxPrint: false,
                                    numberOfRecords: null,
                                    exams: null,
                                    initialDate: date,
                                    finalDate: date,
                                    passageId: dataExams[date]?['passageId'],
                                    externalFilters: FiltersExternalEntity(),
                                    filters: ExamFiltersEntity(
                                      examId: dataExams[date]?['examId'],
                                    ),
                                  ),
                                );

                                final examEntity =
                                    exams!.resultInternalExam.first.listExam
                                        .where(
                                          (data) =>
                                              data.examId ==
                                              dataExams[date]?['examId'],
                                        )
                                        .toList()
                                        .first;

                                Navigator.of(context).pushNamed(
                                  Routes.examResultPage,
                                  arguments: examEntity,
                                );
                              },
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                              bottom: 5,
                              top: 5,
                            ),
                            child: Text(
                              SEE_EXAM.translate(),
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: ZeraColors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
        i++;
      }
    }

    if (!refreshScreen) {
      tableHeight *= (listDateRow.length + 3);
      tableHeight += 50;
    } else if (totalDate <= listDates.length) {
      tableHeight = (56 * (listDateRow.length + 3)) + 50;
    } else {
      tableHeight += rowHeight;
    }
  }

  void _loadData() {
    final List<DataCell> referencesValueRow = [];
    final List<DataCell> valuesRow = [];
    bool hasValue;

    if (listDataColumnHeader.isNotEmpty) {
      listDataColumnHeader.clear();
    }

    for (var itensConsultation in widget.examsConsultation.itensConsultation) {
      hasValue = false;

      listDataColumnHeader.add(
        DataColumn(
          numeric: false,
          label: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: ZeraText(
              itensConsultation.description,
              color: ZeraColors.white,
              textAlign: TextAlign.center,
              theme: const ZeraTextTheme(
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      );

      for (var resultsConsultation in itensConsultation.resultsConsultation) {
        String? refValue = resultsConsultation.defaultRefValue;

        if (referenceValue) {
          if (resultsConsultation.unityResult != null && refValue != null) {
            refValue += ' ${resultsConsultation.unityResult}';
          }

          referencesValueRow.add(
            DataCell(
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: ZeraText(
                  refValue ?? '',
                  color: ZeraColors.neutralDark,
                ),
              ),
            ),
          );
          break;
        }
      }
    }

    if (listDataRowTable.isNotEmpty) {
      listDataRowTable.clear();
    }

    if (referencesValueRow.isNotEmpty) {
      if (!refreshScreen) {
        paddingDateTable += paddingDateTable;
      }

      listDataRowTable.add(
        DataRow(
          color: MaterialStateProperty.all(
            ZeraColors.primaryLightest,
          ),
          cells: referencesValueRow,
        ),
      );
    }

    bool isUrlOrPath;
    bool showTooltip;
    for (var date in listDates) {
      valuesRow.clear();

      for (var itensConsultation
          in widget.examsConsultation.itensConsultation) {
        hasValue = false;

        for (var item in itensConsultation.resultsConsultation) {
          showTooltip = false;

          final DateTime compareDateTime = DateTime(
            item.dateResult!.year,
            item.dateResult!.month,
            item.dateResult!.day,
            item.hourResult!.hour,
            item.hourResult!.minute,
          );

          showTooltip = !item.anormalResult &&
              (item.valueResult?.trim().toUpperCase() ==
                  NOT_DETECTABLE.translate().trim().toUpperCase());

          try {
            isUrlOrPath = ((Uri.parse(item.valueResult!.trim()).isAbsolute) ||
                (((item.valueResult!.contains(r'\')) ||
                        (item.valueResult!.contains(r'/'))) &&
                    ([
                      'pdf',
                      'jpeg',
                      'jpeg',
                      'gif',
                      'bitmap',
                      'bmp',
                      'csv',
                      'txt',
                      'doc',
                      'docx',
                      'docm',
                      'xls',
                      'xlsx',
                      'ppt',
                      'pptx',
                      'ppsx'
                    ].contains(
                      item.valueResult!.split('.').last.toLowerCase(),
                    ))));
          } catch (_) {
            isUrlOrPath = false;
          }

          if (date.compareTo(compareDateTime) == 0) {
            Color colorValue = item.anormalResult
                ? ZeraColors.criticalColorDarkest
                : ZeraColors.neutralDark01;

            if (showTooltip) {
              colorValue = ZeraColors.neutralDark01;
            }

            if (item.valueResult == null) {
              valuesRow.add(
                DataCell(
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: ZeraText(
                      '',
                      color: colorValue,
                      theme: ZeraTextTheme(
                        fontWeight: item.anormalResult
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              );
            } else if (isUrlOrPath) {
              valuesRow.add(
                DataCell(
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ZeraText(
                          THE_EVOLUTIONARY_REPORT_DOES_APPLY_TO_THIS_EXAM
                              .translate(),
                          color: ZeraColors.neutralDark01,
                          theme: ZeraTextTheme(
                            fontWeight: item.anormalResult
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                        ),
                        Visibility(
                          visible: item.anormalResult,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5, top: 5),
                            child: Container(
                              decoration: BoxDecoration(
                                color: ZeraColors.criticalColorDark,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              width: 8,
                              height: 8,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              valuesRow.add(
                DataCell(
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ZeraText(
                          '${item.valueResult} ${item.unityResult ?? ''}'
                              .trim(),
                          color: colorValue,
                          theme: ZeraTextTheme(
                            fontWeight:
                                showTooltip ? FontWeight.w600 : FontWeight.w500,
                          ),
                        ),
                        Visibility(
                          visible: item.anormalResult,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5, top: 5),
                            child: Container(
                              decoration: BoxDecoration(
                                color: ZeraColors.criticalColorDark,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              width: 8,
                              height: 8,
                            ),
                          ),
                        ),
                        Visibility(
                          visible: showTooltip,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8, top: 0),
                            child: CustomTooltipWidget(
                              message: NOT_QUANTIFIABLE_MSG.translate(),
                              child: const Icon(
                                ZeraIcons.question_circle,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            hasValue = true;
            break;
          }
        }

        if (!hasValue) {
          valuesRow.add(
            DataCell(
              ZeraText(
                '',
              ),
            ),
          );
        }
      }
      listDataRowTable.add(
        DataRow(
          color: MaterialStateProperty.all<Color>(Colors.white),
          cells: [...valuesRow],
        ),
      );
    }
  }

  @override
  void initState() {
    _cubit = I.getDependency<ExamCubit>();
    _scrollController = ScrollController();
    tableData = EvolutionaryReportTableEntity(
      name: widget.examsConsultation.description,
    );
    paddingDateTable = rowHeight;
    _loadDates();
    _loadData();

    super.initState();
  }

  @override
  void dispose() {
    _cubit.close();
    _scrollController.dispose();
    super.dispose();
  }

  Widget _dateTable() => Visibility(
        visible: listDateRow.isNotEmpty,
        child: Padding(
          padding: EdgeInsets.only(
            top: paddingDateTable,
          ),
          child: DataTable(
            dataRowHeight: rowHeight,
            headingRowHeight: rowHeight,
            horizontalMargin: 0,
            columns: [
              DataColumn(
                label: Visibility(
                  visible: referenceValue,
                  child: Container(
                    decoration: BoxDecoration(
                      color: ZeraColors.primaryLightest,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4),
                      ),
                    ),
                    width: cellWidth,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 16),
                    child: ZeraText(
                      REFERENCE_VALUE.translate(),
                      textAlign: TextAlign.left,
                      color: ZeraColors.neutralDark,
                      theme: const ZeraTextTheme(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                numeric: false,
              ),
            ],
            rows: listDateRow,
          ),
        ),
      );

  Widget _title() => Container(
        alignment: Alignment.centerLeft,
        height: rowHeight,
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 20,
        ),
        decoration: BoxDecoration(
          color: ZeraColors.primaryDarkest,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(4),
            topLeft: Radius.circular(4),
          ),
        ),
        child: ZeraText(
          widget.examsConsultation.description,
          color: Colors.white,
          theme: const ZeraTextTheme(
            fontWeight: FontWeight.w700,
            fontSize: 12,
            lineHeight: 1.5,
          ),
        ),
      );

  Widget _dataTable() => listDateRow.isNotEmpty
      ? Flexible(
          child: SingleChildScrollView(
            padding: EdgeInsets.zero,
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            child: IntrinsicWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _title(),
                  DataTable(
                    checkboxHorizontalMargin: 0,
                    border: TableBorder.all(
                      width: 0.5,
                      color: ZeraColors.neutralLight02,
                    ),
                    dataRowHeight: rowHeight,
                    headingRowHeight: rowHeight,
                    headingRowColor: MaterialStateProperty.all(
                      ZeraColors.primaryMedium,
                    ),
                    showBottomBorder: true,
                    horizontalMargin: 10,
                    columnSpacing: 20,
                    columns: listDataColumnHeader,
                    rows: listDataRowTable,
                  ),
                ],
              ),
            ),
          ),
        )
      : Container();

  @override
  Widget build(BuildContext context) => Visibility(
        visible: listDates.isNotEmpty,
        child: Padding(
          padding: const EdgeInsets.only(
            bottom: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: tableHeight,
                child: DraggableScrollbar(
                  scrollThumbBuilder: (
                    Color backgroundColor,
                    Animation<double> thumbAnimation,
                    Animation<double> labelAnimation,
                    double width, {
                    Text? labelText,
                    BoxConstraints? labelConstraints,
                  }) =>
                      Container(
                    height: 10,
                    width: width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: backgroundColor,
                    ),
                  ),
                  alwaysVisibleScrollThumb: true,
                  controller: _scrollController,
                  backgroundColor: ZeraColors.primaryLight,
                  widthScrollThumb: 100,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _dateTable(),
                      _dataTable(),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: showLoadExams,
                child: Padding(
                  padding: const EdgeInsets.only(top: 40, bottom: 30),
                  child: InkWell(
                    onTap: () {
                      limitRecords += limitRecords;

                      if (!refreshScreen) {
                        refreshScreen = true;
                      }

                      setState(() {
                        _loadDates();
                        _loadData();
                      });
                    },
                    child: Center(
                      child: ZeraText(
                        SHOW_MORE_RESULTS.translate(),
                        color: ZeraColors.primaryDark,
                        theme: const ZeraTextTheme(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
