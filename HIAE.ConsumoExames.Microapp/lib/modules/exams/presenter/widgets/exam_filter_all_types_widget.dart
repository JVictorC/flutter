import 'dart:async';

import 'package:base_dependencies/dependencies.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/strings.dart';
import '../../../../core/extensions/translate_extension.dart';
import '../../../../core/utils/primitive_wrapper.dart';
import '../../../../core/widgets/custom_tooltip_widget.dart';
import '../../../../core/widgets/date_field_calendar.dart';
import 'exam_check_box.dart';
import 'list_dates_filter.dart';

class ExamFilterAllTypesWidget extends StatefulWidget {
  final List<int> examType;
  final List<String> unity;
  final List<int> passage;
  final PrimitiveWrapper<bool> localLab;
  final PrimitiveWrapper<bool> otherLab;
  final ValueNotifier<bool> enableButton;
  final StreamController<bool> clearFields;
  final List<int> statusResult;
  final PrimitiveWrapper<int> selectedYear;
  final PrimitiveWrapper<DateTime> initSelectedDate;
  final PrimitiveWrapper<DateTime> finalSelectedDate;

  const ExamFilterAllTypesWidget({
    required this.enableButton,
    required this.clearFields,
    required this.examType,
    required this.unity,
    required this.passage,
    required this.localLab,
    required this.otherLab,
    required this.statusResult,
    required this.finalSelectedDate,
    required this.initSelectedDate,
    required this.selectedYear,
    Key? key,
  }) : super(key: key);

  @override
  State<ExamFilterAllTypesWidget> createState() =>
      _ExamFilterAllTypesWidgetState();
}

class _ExamFilterAllTypesWidgetState extends State<ExamFilterAllTypesWidget> {
  late final ValueNotifier<bool> showAllUnitys;

  @override
  void initState() {
    showAllUnitys = ValueNotifier<bool>(false);
    super.initState();
  }

  @override
  void dispose() {
    showAllUnitys.dispose();
    super.dispose();
  }

  List<String> hospitalFilter = [
    'Morumbi',
    'Perdizes',
    'Alphaville',
    'Ibirapuera',
    'Chácara Klabin',
    'Jardins',
    'Goiânia',
  ];

  List<String> clinicFilter = [
    'Santana',
    'Pinheiros',
    'Anália Franco',
    'Parque Ibirapuera',
    'Parque da cidade',
  ];

  List<String> airportFilter = [
    'Aeroporto Internacional Tom Jobim (Rio-Galeão)',
  ];

  Widget _titleHeader({
    required String title,
  }) =>
      Padding(
        padding: const EdgeInsets.only(top: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ZeraText(
              title,
              color: ZeraColors.neutralDark,
              theme: const ZeraTextTheme(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ZeraDivider(),
          ],
        ),
      );

  Widget _label(String title) => Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 16,
        ),
        child: ZeraText(
          title,
          theme: ZeraTextTheme(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            textColor: ZeraColors.neutralDark,
          ),
        ),
      );

  Widget _formattedBodyWidget({
    required List<Widget> widgets,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: widgets,
      );

  Widget _checkBox({required Widget widget}) => Padding(
        padding: !kIsWeb
            ? EdgeInsets.zero
            : const EdgeInsets.symmetric(vertical: 10),
        child: widget,
      );

  @override
  Widget build(BuildContext context) => StreamBuilder<bool>(
        initialData: false,
        stream: widget.clearFields.stream,
        builder: (context, snapshot) => Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 25,
            vertical: 30,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _titleHeader(title: 'Data de realização'),
              ListDatesFilter(
                selectedValue: widget.selectedYear.value,
                selectedButton: (int value) {
                  DateTime initialDate;
                  DateTime finalDate;
                  widget.selectedYear.value = value;

                  if ([3, 6].contains(value)) {
                    finalDate = DateTime.now();

                    initialDate = finalDate.subtract(
                      Duration(days: value * 31),
                    );
                  } else {
                    initialDate = DateTime(value, 1, 1);
                    finalDate = DateTime(value + 1, 1, 1).subtract(
                      const Duration(
                        days: 1,
                      ),
                    );
                  }
                  widget.initSelectedDate.value = initialDate;
                  widget.finalSelectedDate.value = finalDate;
                  setState(() {});
                },
              ),
              const SizedBox(
                height: 30,
              ),
              DateFieldCalendar(
                dateStart: widget.initSelectedDate.value,
                dateEnd: widget.finalSelectedDate.value,
                enableCalendar: true,
                onChangeInitialDateTime: (d1) {
                  widget.initSelectedDate.value = d1;
                  if (widget.initSelectedDate.value != null &&
                      widget.finalSelectedDate.value != null) {
                    widget.enableButton.value = true;
                  }

                  if (widget.selectedYear.value != null) {
                    widget.selectedYear.value = null;
                    setState(() {});
                  }
                },
                onChangeFinalDateTime: (d2) {
                  widget.finalSelectedDate.value = d2;
                  if (widget.initSelectedDate.value != null &&
                      widget.finalSelectedDate.value != null) {
                    widget.enableButton.value = true;
                  }
                  if (widget.selectedYear.value != null) {
                    widget.selectedYear.value = null;
                    setState(() {});
                  }
                },
              ),
              const SizedBox(
                height: 35,
              ),
              _titleHeader(title: 'Categoria'),
              _formattedBodyWidget(
                widgets: [
                  _checkBox(
                    widget: ExamCheckBox(
                      direction: CheckBoxDirection.left,
                      mainAxisAlignment: MainAxisAlignment.start,
                      defaultValue: widget.examType.contains(1),
                      title: LABORATORY_EXAM.translate(),
                      action: (value) {
                        if (value && !widget.examType.contains(1)) {
                          widget.examType.add(1);
                        } else if (!value) {
                          widget.examType.remove(1);
                        }
                        widget.enableButton.value = true;
                      },
                    ),
                  ),
                  Padding(
                    // ignore: prefer_const_constructors
                    padding: EdgeInsets.only(left: kIsWeb ? 31 : 46),
                    child: ZeraText(
                      LABORATORY_EXAM_TYPE,
                      theme: const ZeraTextTheme(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ZeraDivider(),
                  _checkBox(
                    widget: ExamCheckBox(
                      direction: CheckBoxDirection.left,
                      mainAxisAlignment: MainAxisAlignment.start,
                      defaultValue: widget.examType.contains(2),
                      title: DIAGNOSTIC_IMAGE.translate(),
                      action: (value) {
                        if (value && !widget.examType.contains(2)) {
                          widget.examType.add(2);
                        } else if (!value) {
                          widget.examType.remove(2);
                        }

                        widget.enableButton.value = true;
                      },
                    ),
                  ),
                  Padding(
                    // ignore: prefer_const_constructors
                    padding: EdgeInsets.only(left: kIsWeb ? 31 : 46),
                    child: ZeraText(
                      DIAGNOSTIC_IMAGE_TYPE,
                      theme: const ZeraTextTheme(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ZeraDivider(),
                ],
              ),
              const SizedBox(
                height: 35,
              ),
              _titleHeader(title: 'Status do Resultado'),
              _formattedBodyWidget(
                widgets: [
                  _checkBox(
                    widget: ExamCheckBox(
                      direction: CheckBoxDirection.left,
                      mainAxisAlignment: MainAxisAlignment.start,
                      defaultValue: widget.statusResult.contains(1),
                      title: RELEASED.translate(),
                      action: (value) {
                        if (value && !widget.statusResult.contains(1)) {
                          widget.statusResult.addAll([1, 2, 3]);
                        } else {
                          widget.statusResult
                              .removeWhere((element) => element < 4);
                        }
                        widget.enableButton.value = true;
                      },
                    ),
                  ),
                  ZeraDivider(),
                  _checkBox(
                    widget: ExamCheckBox(
                      direction: CheckBoxDirection.left,
                      mainAxisAlignment: MainAxisAlignment.start,
                      defaultValue: widget.statusResult.contains(4),
                      title: NOT_RELEASED.translate(),
                      action: (value) {
                        if (value && !widget.statusResult.contains(4)) {
                          widget.statusResult.add(4);
                        } else {
                          widget.statusResult.remove(4);
                        }
                        widget.enableButton.value = true;
                      },
                    ),
                  ),
                  ZeraDivider(),
                ],
              ),
              const SizedBox(
                height: 35,
              ),
              _titleHeader(title: 'Laboratório'),
              _formattedBodyWidget(
                widgets: [
                  _checkBox(
                    widget: ExamCheckBox(
                      direction: CheckBoxDirection.left,
                      mainAxisAlignment: MainAxisAlignment.start,
                      defaultValue: widget.localLab.value,
                      title: 'Albert Einstein',
                      action: (value) {
                        widget.localLab.value = value;
                        widget.enableButton.value = true;
                      },
                    ),
                  ),
                  ZeraDivider(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: _checkBox(
                          widget: ExamCheckBox(
                            direction: CheckBoxDirection.left,
                            mainAxisAlignment: MainAxisAlignment.start,
                            defaultValue: widget.otherLab.value,
                            title: OTHERS_IMPORT_EXAMS.translate(),
                            action: (value) {
                              widget.otherLab.value = value;
                              widget.enableButton.value = true;
                            },
                          ),
                        ),
                      ),
                      CustomTooltipWidget(
                        message:
                            'Veja os exames que você importou de outros laboratórios',
                        child: Icon(
                          Icons.help_outline_outlined,
                          color: ZeraColors.neutralDark02,
                        ),
                      ),
                    ],
                  ),
                  ZeraDivider(),
                ],
              ),
              const SizedBox(
                height: 35,
              ),
              _titleHeader(title: 'Unidade Albert Einstein'),
              ValueListenableBuilder<bool>(
                valueListenable: showAllUnitys,
                builder: (context, showAll, _) => _formattedBodyWidget(
                  widgets: [
                    _label(
                      HOSPITALS.translate(),
                    ),
                    ZeraDivider(),
                    SizedBox(
                      child: ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        separatorBuilder: (context, index) => ZeraDivider(),
                        itemCount: showAll ? hospitalFilter.length : 4,
                        itemBuilder: (context, index) => _checkBox(
                          widget: ExamCheckBox(
                            direction: CheckBoxDirection.left,
                            mainAxisAlignment: MainAxisAlignment.start,
                            defaultValue:
                                widget.unity.contains(hospitalFilter[index]),
                            title: hospitalFilter[index],
                            action: (value) {
                              if (value &&
                                  !widget.unity
                                      .contains(hospitalFilter[index])) {
                                widget.unity.add(hospitalFilter[index]);
                              } else {
                                widget.unity.remove(hospitalFilter[index]);
                              }

                              widget.enableButton.value = true;
                            },
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: showAll,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ZeraDivider(),
                          _label(
                            CLINICS.translate(),
                          ),
                          ZeraDivider(),
                          SizedBox(
                            child: ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              separatorBuilder: (context, index) =>
                                  ZeraDivider(),
                              itemCount: clinicFilter.length,
                              itemBuilder: (context, index) => _checkBox(
                                widget: ExamCheckBox(
                                  direction: CheckBoxDirection.left,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  defaultValue: widget.unity
                                      .contains(clinicFilter[index]),
                                  title: clinicFilter[index],
                                  action: (value) {
                                    if (value &&
                                        !widget.unity
                                            .contains(clinicFilter[index])) {
                                      widget.unity.add(clinicFilter[index]);
                                    } else {
                                      widget.unity.remove(clinicFilter[index]);
                                    }

                                    widget.enableButton.value = true;
                                  },
                                ),
                              ),
                            ),
                          ),
                          ZeraDivider(),
                          _label(
                            AIRPORT.translate(),
                          ),
                          ZeraDivider(),
                          SizedBox(
                            child: ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              separatorBuilder: (context, index) =>
                                  ZeraDivider(),
                              itemCount: airportFilter.length,
                              itemBuilder: (context, index) => _checkBox(
                                widget: ExamCheckBox(
                                  direction: CheckBoxDirection.left,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  defaultValue: widget.unity
                                      .contains(airportFilter[index]),
                                  title: airportFilter[index],
                                  action: (value) {
                                    if (value &&
                                        !widget.unity
                                            .contains(airportFilter[index])) {
                                      widget.unity.add(airportFilter[index]);
                                    } else {
                                      widget.unity.remove(airportFilter[index]);
                                    }

                                    widget.enableButton.value = true;
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: TextButton(
                        child: ZeraText(
                          !showAll
                              ? 'Exibir mais unidades'
                              : 'Exibir menos unidades',
                          theme: ZeraTextTheme(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            textColor: ZeraColors.primaryDark,
                          ),
                        ),
                        onPressed: () {
                          showAllUnitys.value = !showAllUnitys.value;
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
