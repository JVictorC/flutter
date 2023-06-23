import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:base_dependencies/dependencies.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/strings.dart';
import '../../../../core/extensions/mobile_size_extension.dart';
import '../../../../core/extensions/translate_extension.dart';
import '../../../../core/utils/primitive_wrapper.dart';
import '../../domain/entities/exams_filters_entity.dart';
import '../../domain/entities/exams_filters_external_entity.dart';
import '../../domain/entities/load_date_exam_entity.dart';
import '../../domain/entities/load_exams_entity.dart';
import '../cubits/exam_cubit.dart';
import 'arrow_scroll_button.dart';
import 'filter_badget.dart';

class HeaderFilter extends StatefulWidget {
  final ExamCubit cubit;
  final ExamFiltersEntity internalFilter;
  final FiltersExternalEntity externalFilter;
  final int amount;
  final DateTime defaultInitDate;
  final DateTime defaultFinalDate;
  final PrimitiveWrapper<bool> enableCardFilters;
  final DateTime dateStart;
  final DateTime dateEnd;
  final PrimitiveWrapper<String> examCode;
  final PrimitiveWrapper<bool> localLab;
  final PrimitiveWrapper<bool> otherLab;

  const HeaderFilter({
    required this.localLab,
    required this.otherLab,
    required this.enableCardFilters,
    required this.cubit,
    required this.internalFilter,
    required this.externalFilter,
    required this.amount,
    required this.defaultInitDate,
    required this.defaultFinalDate,
    required this.dateStart,
    required this.dateEnd,
    required this.examCode,
    Key? key,
  }) : super(key: key);

  @override
  State<HeaderFilter> createState() => _HeaderFilterState();
}

class _HeaderFilterState extends State<HeaderFilter> {
  late final ScrollController _scrollController;
  late DateFormat _outputFormat;

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
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
    DateTime dateFilterInitial = widget.internalFilter.executionInitialDate ??
        widget.externalFilter.executionInitialDate ??
        widget.defaultInitDate;

    DateTime dateFilterFinal = widget.internalFilter.executionInitialDate ??
        widget.externalFilter.executionInitialDate ??
        widget.defaultFinalDate;

    final loadData = LoadExamEntity(
      lab: widget.localLab.value! && widget.otherLab.value!
          ? null
          : widget.localLab.value!
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
      exams: widget.examCode.value,
      idItens: null,
      filters: widget.internalFilter,
      externalFilters: widget.externalFilter,
    );

    bool enableCategory = ((widget.internalFilter.examType != null &&
            widget.internalFilter.examType!.isNotEmpty) ||
        (widget.externalFilter.examType != null &&
            widget.externalFilter.examType!.isNotEmpty));

    bool enableType = widget.internalFilter.passType != null &&
        widget.internalFilter.passType!.isNotEmpty;

    bool enableUnity = widget.internalFilter.unity?.isNotEmpty ?? false;

    bool enableDate = widget.internalFilter.executionInitialDate != null ||
        widget.externalFilter.executionFinalDate != null;

    widget.enableCardFilters.value = enableCategory ||
        enableType ||
        enableUnity ||
        enableDate ||
        widget.localLab.value! ||
        widget.otherLab.value!;

    if (widget.enableCardFilters.value == true ||
        widget.examCode.value != null ||
        widget.internalFilter.examName != null ||
        widget.externalFilter.examName != null) {
      await widget.cubit.loadFilter(loadExamEntity: loadData);
    } else {
      final loadDateFilter = LoadDateExamEntity(
        initialDate: widget.dateStart,
        finalDate: widget.dateEnd,
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

    if (widget.localLab.value!) {
      listWidget.add(
        Padding(
          padding: const EdgeInsets.only(right: 5.0),
          child: FilterBadGet(
            title: 'Albert Einstein',
            actionClose: () async {
              widget.localLab.value = false;

              await refreshFilter();
            },
          ),
        ),
      );
    }

    if (widget.otherLab.value!) {
      listWidget.add(
        Padding(
          padding: const EdgeInsets.only(right: 5.0),
          child: FilterBadGet(
            title: 'Outros',
            actionClose: () async {
              widget.otherLab.value = false;

              await refreshFilter();
            },
          ),
        ),
      );
    }

    return listWidget;
  }

  Widget dateBadGet() => Visibility(
        visible: widget.internalFilter.executionInitialDate != null ||
            widget.externalFilter.executionInitialDate != null,
        child: Padding(
          padding: const EdgeInsets.only(right: 5.0),
          child: FilterBadGet(
            title: '${_outputFormat.format(
              widget.internalFilter.executionInitialDate ??
                  widget.externalFilter.executionInitialDate ??
                  DateTime.now(),
            )} à ${_outputFormat.format(
              widget.internalFilter.executionFinalDate ??
                  widget.internalFilter.executionFinalDate ??
                  DateTime.now(),
            )}',
            actionClose: () async {
              widget.internalFilter.executionInitialDate = null;
              widget.externalFilter.executionInitialDate = null;
              widget.internalFilter.executionFinalDate = null;
              widget.externalFilter.executionFinalDate = null;
              await refreshFilter();
            },
          ),
        ),
      );

  List<Widget> categoryBadGet() {
    final List<Widget> listWidget = [];
    final List<int> examType = [];
    final List<int> distinctExamType;

    if (widget.internalFilter.examType != null) {
      examType.addAll(widget.internalFilter.examType!);
    }

    if (widget.externalFilter.examType != null) {
      examType.addAll(widget.externalFilter.examType!);
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
                if (widget.internalFilter.examType != null &&
                    widget.internalFilter.examType!.isNotEmpty) {
                  widget.internalFilter.examType!
                      .removeWhere((element) => element == category);
                }

                if (widget.externalFilter.examType != null &&
                    widget.externalFilter.examType!.isNotEmpty) {
                  widget.externalFilter.examType!
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

    if (widget.internalFilter.passType?.any((element) => element > 0) ??
        false) {
      for (var type in widget.internalFilter.passType!) {
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
                widget.internalFilter.passType!
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

    if (widget.internalFilter.unity
            ?.any((element) => element.trim().isNotEmpty) ??
        false) {
      for (var unity in widget.internalFilter.unity!) {
        listWidget.add(
          Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: FilterBadGet(
              title: unity,
              actionClose: () async {
                widget.internalFilter.unity!.removeWhere(
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

  Widget _clearFields() => Padding(
        padding: const EdgeInsets.only(top: 16),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: InkWell(
            onTap: () async {
              widget.localLab.value = false;
              widget.otherLab.value = false;
              widget.internalFilter.executionInitialDate = null;
              widget.externalFilter.executionInitialDate = null;
              widget.internalFilter.executionFinalDate = null;
              widget.externalFilter.executionFinalDate = null;

              widget.internalFilter.examType?.clear();

              widget.internalFilter.passType?.clear();
              widget.internalFilter.unity?.clear();
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
      );

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
            _clearFields(),
          ],
        ),
      );
}
