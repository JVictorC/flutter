import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:base_dependencies/dependencies.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/strings.dart';
import '../../../../core/extensions/mobile_size_extension.dart';
import '../../../../core/extensions/translate_extension.dart';
import '../../domain/entities/exams_doctor_entity.dart';
import '../../domain/entities/load_date_exam_entity.dart';
import '../../domain/entities/load_exams_entity.dart';
import '../cubits/exam_cubit.dart';
import 'arrow_scroll_button.dart';
import 'filter_badget.dart';

class HeaderFilterDoctor extends StatefulWidget {
  final ExamsDoctorEntity examsDoctor;
  final ExamCubit cubit;
  final int amount;
  const HeaderFilterDoctor({
    required this.cubit,
    required this.examsDoctor,
    required this.amount,
  });

  @override
  State<HeaderFilterDoctor> createState() => _HeaderFilterDoctorState();
}

class _HeaderFilterDoctorState extends State<HeaderFilterDoctor> {
  late DateFormat _outputFormat;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _outputFormat = DateFormat('dd/MM/yyyy');
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  double _getPaddingScreen(BuildContext context, double defaultValue) {
    double size = (MediaQuery.of(context).size.width - 1200) / 2;

    return size <= 0 ? defaultValue : size;
  }

  Future<void> refreshFilter() async {
    DateTime dateFilterInitial =
        widget.examsDoctor.internalFilter?.executionInitialDate ??
            widget.examsDoctor.externalFilter?.executionInitialDate ??
            widget.examsDoctor.dateFinal;

    DateTime dateFilterFinal =
        widget.examsDoctor.internalFilter?.executionFinalDate ??
            widget.examsDoctor.externalFilter?.executionFinalDate ??
            widget.examsDoctor.dateFinal;

    widget.examsDoctor.localLab ??= false;
    widget.examsDoctor.otherLab ??= false;

    final loadData = LoadExamEntity(
      lab: widget.examsDoctor.localLab! && widget.examsDoctor.otherLab!
          ? null
          : widget.examsDoctor.localLab!
              ? 'Albert Einstein'
              : 'outros',
      passageId: null,
      initialDate: dateFilterInitial,
      finalDate: dateFilterFinal,
      auxPrint: false,
      chAuthentication: null,
      medicalAppointment: null,
      results: true,
      numberOfRecords: null,
      exams: widget.examsDoctor.examCode,
      idItens: null,
      filters: widget.examsDoctor.internalFilter!,
      externalFilters: widget.examsDoctor.externalFilter!,
    );

    bool enableCategory =
        ((widget.examsDoctor.internalFilter!.examType != null &&
                widget.examsDoctor.internalFilter!.examType!.isNotEmpty) ||
            (widget.examsDoctor.externalFilter!.examType != null &&
                widget.examsDoctor.externalFilter!.examType!.isNotEmpty));

    bool enableType = widget.examsDoctor.internalFilter!.passType != null &&
        widget.examsDoctor.internalFilter!.passType!.isNotEmpty;

    bool enableUnity =
        widget.examsDoctor.internalFilter!.unity?.isNotEmpty ?? false;

    bool enableDate =
        widget.examsDoctor.internalFilter!.executionInitialDate != null ||
            widget.examsDoctor.externalFilter!.executionFinalDate != null;

    widget.examsDoctor.enableCardFilters = enableCategory ||
        enableType ||
        enableUnity ||
        enableDate ||
        widget.examsDoctor.localLab! ||
        widget.examsDoctor.otherLab!;

    if (widget.examsDoctor.enableCardFilters == true ||
        widget.examsDoctor.examCode != null ||
        widget.examsDoctor.internalFilter!.examName != null ||
        widget.examsDoctor.externalFilter!.examName != null) {
      await widget.cubit.loadFilter(loadExamEntity: loadData);
    } else {
      final loadDateFilter = LoadDateExamEntity(
        initialDate: widget.examsDoctor.dateInitial,
        finalDate: widget.examsDoctor.dateFinal,
        numberOfRecords: 0,
      );
      await widget.cubit.loadExamDate(
        loadDataExamEntity: loadDateFilter,
        clearList: true,
      );
    }
  }

  List<Widget> labBadGet() {
    final List<Widget> listWidget = [];

    if (widget.examsDoctor.localLab!) {
      listWidget.add(
        Padding(
          padding: const EdgeInsets.only(right: 5.0),
          child: FilterBadGet(
            title: 'Albert Einstein',
            actionClose: () async {
              widget.examsDoctor.localLab = false;

              await refreshFilter();
            },
          ),
        ),
      );
    }

    if (widget.examsDoctor.otherLab!) {
      listWidget.add(
        Padding(
          padding: const EdgeInsets.only(right: 5.0),
          child: FilterBadGet(
            title: 'Outros',
            actionClose: () async {
              widget.examsDoctor.otherLab = false;

              await refreshFilter();
            },
          ),
        ),
      );
    }

    return listWidget;
  }

  Widget dateBadGet() => Visibility(
        visible:
            widget.examsDoctor.internalFilter?.executionInitialDate != null ||
                widget.examsDoctor.externalFilter?.executionInitialDate != null,
        child: Padding(
          padding: const EdgeInsets.only(right: 5.0),
          child: FilterBadGet(
            title: '${_outputFormat.format(
              widget.examsDoctor.internalFilter!.executionInitialDate ??
                  widget.examsDoctor.externalFilter!.executionInitialDate ??
                  DateTime.now(),
            )} à ${_outputFormat.format(
              widget.examsDoctor.internalFilter!.executionFinalDate ??
                  widget.examsDoctor.internalFilter!.executionFinalDate ??
                  DateTime.now(),
            )}',
            actionClose: () async {
              widget.examsDoctor.internalFilter!.executionInitialDate = null;
              widget.examsDoctor.externalFilter!.executionInitialDate = null;
              widget.examsDoctor.internalFilter!.executionFinalDate = null;
              widget.examsDoctor.externalFilter!.executionFinalDate = null;
              await refreshFilter();
            },
          ),
        ),
      );

  List<Widget> categoryBadGet() {
    final List<Widget> listWidget = [];
    final List<int> examType = [];
    final List<int> distinctExamType;

    if (widget.examsDoctor.internalFilter!.examType != null) {
      examType.addAll(widget.examsDoctor.internalFilter!.examType!);
    }

    if (widget.examsDoctor.externalFilter!.examType != null) {
      examType.addAll(widget.examsDoctor.externalFilter!.examType!);
    }

    distinctExamType = examType.toSet().toList();

    if (distinctExamType.isNotEmpty) {
      for (var category in distinctExamType) {
        String name =
            category == 1 ? 'Exame Laboratorial' : 'Diagnóstico por imagem';

        listWidget.add(
          Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: FilterBadGet(
              title: name,
              actionClose: () async {
                if (widget.examsDoctor.internalFilter!.examType != null &&
                    widget.examsDoctor.internalFilter!.examType!.isNotEmpty) {
                  widget.examsDoctor.internalFilter!.examType!
                      .removeWhere((element) => element == category);
                }

                if (widget.examsDoctor.externalFilter!.examType != null &&
                    widget.examsDoctor.externalFilter!.examType!.isNotEmpty) {
                  widget.examsDoctor.externalFilter!.examType!
                      .removeWhere((element) => element == category);
                }

                if (distinctExamType.isNotEmpty) {
                  distinctExamType
                      .removeWhere((element) => element == category);
                }

                if (examType.isNotEmpty) {
                  examType.removeWhere((element) => element == category);
                }

                await refreshFilter();
              },
            ),
          ),
        );
      }
    }

    return listWidget;
  }

  List<Widget> typeBadGet() {
    final List<Widget> listWidget = [];
    String name;

    if (widget.examsDoctor.internalFilter!.passType
            ?.any((element) => element > 0) ??
        false) {
      for (var type in widget.examsDoctor.internalFilter!.passType!) {
        if (type == 1) {
          name = 'Internação';
        } else if (type == 2) {
          name = 'Realização de Exames';
        } else {
          name = 'Pronto atendimento';
        }

        listWidget.add(
          Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: FilterBadGet(
              title: name,
              actionClose: () async {
                widget.examsDoctor.internalFilter!.passType!
                    .removeWhere((element) => element == type);
                await refreshFilter();
              },
            ),
          ),
        );
      }
    }

    return listWidget;
  }

  List<Widget> unitBadGet() {
    final List<Widget> listWidget = [];

    if (widget.examsDoctor.internalFilter!.unity
            ?.any((element) => element.trim().isNotEmpty) ??
        false) {
      for (var unity in widget.examsDoctor.internalFilter!.unity!) {
        listWidget.add(
          Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: FilterBadGet(
              title: unity,
              actionClose: () async {
                widget.examsDoctor.internalFilter!.unity!.removeWhere(
                  (element) =>
                      element.trim().toUpperCase() ==
                      unity.trim().toUpperCase(),
                );
                await refreshFilter();
              },
            ),
          ),
        );
      }
    }

    return listWidget;
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.only(
          left: context.isDevice() ? 16 : 0, // _getPaddingScreen(context, 5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ZeraText(
                      SEARCH_RESULTS.translate(),
                      theme: ZeraTextTheme(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w700,
                        textColor: ZeraColors.neutralDark,
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    ZeraText(
                      '${widget.amount.toString().padLeft(widget.amount > 0 ? 2 : 1, '0')} $EXAMS_RESULT_FOUND',
                      color: ZeraColors.neutralDark01,
                      theme: const ZeraTextTheme(
                        fontSize: 12.5,
                      ),
                    ),
                  ],
                ),
                Visibility(
                  visible: kIsWeb,
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: context.isDevice()
                          ? 16
                          : 0, //_getPaddingScreen(context, 5),
                    ),
                    child: ArrowScrollButton(
                      scrollController: _scrollController,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 24,
            ),
            SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  dateBadGet(),
                  ...categoryBadGet(),
                  ...typeBadGet(),
                  ...labBadGet(),
                  ...unitBadGet(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: InkWell(
                  onTap: () async {
                    widget.examsDoctor.localLab = false;
                    widget.examsDoctor.otherLab = false;
                    widget.examsDoctor.internalFilter!.executionInitialDate =
                        null;
                    widget.examsDoctor.externalFilter!.executionInitialDate =
                        null;
                    widget.examsDoctor.internalFilter!.executionFinalDate =
                        null;
                    widget.examsDoctor.externalFilter!.executionFinalDate =
                        null;

                    widget.examsDoctor.internalFilter?.examType?.clear();
                    widget.examsDoctor.internalFilter?.examName = null;
                    widget.examsDoctor.internalFilter?.examId = null;
                    widget.examsDoctor.internalFilter?.passType?.clear();
                    widget.examsDoctor.internalFilter?.unity?.clear();

                    widget.examsDoctor.externalFilter?.examName = null;
                    widget.examsDoctor.externalFilter?.examType?.clear();

                    await refreshFilter();
                  },
                  child: ZeraText(
                    CLEAR_FILTERS.translate(),
                    color: ZeraColors.primaryMedium,
                    theme: const ZeraTextTheme(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
