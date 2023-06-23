// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:base_dependencies/dependencies.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../core/constants/assets_constants.dart';
import '../../../../core/constants/strings.dart';
import '../../../../core/di/initInjector.dart';
import '../../../../core/entities/user_auth_info.dart';
import '../../../../core/extensions/string_extension.dart';
import '../../../../core/extensions/translate_extension.dart';
import '../../../../core/widgets/custom_check_box.dart';
import '../../../../core/widgets/custom_tooltip_widget.dart';
import '../../../../core/widgets/responsive_app_bar.dart';
import '../../domain/entities/exams_doctor_entity.dart';
import '../../domain/entities/exams_filters_entity.dart';
import '../../domain/entities/exams_filters_external_entity.dart';
import 'input_calendar_widget.dart';
import 'period_button_widget.dart';

class FilterDoctorBodyWidget extends StatefulWidget {
  final ExamsDoctorEntity doctorFilter;
  final TextEditingController initialDateController;
  final TextEditingController finalDateController;
  final void Function(ExamsDoctorEntity) resultFilter;

  const FilterDoctorBodyWidget({
    Key? key,
    required this.doctorFilter,
    required this.initialDateController,
    required this.finalDateController,
    required this.resultFilter,
  }) : super(key: key);

  @override
  State<FilterDoctorBodyWidget> createState() => _FilterDoctorBodyWidgetState();
}

class _FilterDoctorBodyWidgetState extends State<FilterDoctorBodyWidget>
    with TickerProviderStateMixin {
  late ExamsDoctorEntity doctorFilter;
  late ExamFiltersEntity internalFilter;
  late FiltersExternalEntity externalFilter;
  late FocusNode _focusStartDate;
  late FocusNode _focusEndDate;
  late DateFormat _outputFormat;
  late bool _focusEnableStart;
  late bool _focusEnableEnd;
  late ScrollController _scrollController;
  late AnimationController _animationControllerShow;
  late Animation<double> _animation;
  bool _isExpanded = false;
  late String localization;

  DateTime _focusedDay = DateTime.now();
  DateTime finalDate = DateTime.now();
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOn;
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  bool _isOthersSelected = false;
  bool _isEinsteinSelected = false;
  bool _isFilterValid = false;

  late AnimationController _animationController;
  List<int> passType = [];
  final Map<String, bool> _mapPeriods = {
    '${LAST.translate()} 3 ${MONTHS.translate()}': false,
    '${LAST.translate()} 6 ${MONTHS.translate()}': false,
    '${DateTime.now().year}': false,
    '${DateTime.now().year - 1}': false,
    '${DateTime.now().year - 2}': false,
    '${DateTime.now().year - 3}': false,
    '${DateTime.now().year - 4} ${AND_EARLIER.translate()}': false,
  };

  final Map<String, DateTime> mapPeriodsValue = {
    '${LAST.translate()} 3 ${MONTHS.translate()}': DateTime(
      DateTime.now().year,
      DateTime.now().month - 3,
      DateTime.now().day,
    ),
    '${LAST.translate()} 6 ${MONTHS.translate()}': DateTime(
      DateTime.now().year,
      DateTime.now().month - 6,
      DateTime.now().day,
    ),
    '${DateTime.now().year}': DateTime(
      DateTime.now().year,
      1,
      1,
    ),
    '${DateTime.now().year - 1}': DateTime(
      DateTime.now().year - 1,
      1,
      1,
    ),
    '${DateTime.now().year - 2}': DateTime(
      DateTime.now().year - 2,
      1,
      1,
    ),
    '${DateTime.now().year - 3}': DateTime(
      DateTime.now().year - 3,
      1,
      1,
    ),
    '${DateTime.now().year - 4} ${AND_EARLIER.translate()}': DateTime(
      DateTime.now().year - 4,
      1,
      1,
    ),
  };
  void handleFinalDate(int year) {
    // verifica as datas pelo key `String`
    // n vai pegar os meses da String
    // trata os campos vindo como ano
    if (year >= 1000 && (year != DateTime.now().year)) {
      int december = 12;
      finalDate = DateTime(year, december, 31);
    } else {
      // trata os campos vindo como mês
      finalDate = DateTime.now();
    }
  }

  bool _showRemovePeriodButton = false;
  final kLastDay = DateTime(
    DateTime.now().year + 7,
    DateTime.now().month,
    DateTime.now().day,
  );

  late ScrollController _dateController;
  @override
  void initState() {
    super.initState();
    _dateController = ScrollController();
    final user = I.getDependency<UserAuthInfoEntity>();
    localization = user.localization;
    doctorFilter = widget.doctorFilter;

    internalFilter = ExamFiltersEntity();
    externalFilter = FiltersExternalEntity();

    _animationControllerShow = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(_animationControllerShow);

    _animationControllerShow.addStatusListener((status) {
      if (status == AnimationStatus.reverse) {
        setState(() {
          _isExpanded = false;
        });
      }
    });
    _focusStartDate = FocusNode();
    _focusEndDate = FocusNode();
    _scrollController = ScrollController();

    _outputFormat = DateFormat('dd/MM/yyyy');
    _focusEnableStart = false;
    _focusEnableEnd = false;
    _focusedDay = DateTime.now();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _dateController.dispose();
    widget.initialDateController.clear();
    widget.finalDateController.clear();
    _isOthersSelected = false;
    _isEinsteinSelected = false;
    widget.initialDateController.clear();
    widget.finalDateController.clear();
    passType = [];
    internalFilter = ExamFiltersEntity();
    externalFilter = FiltersExternalEntity();
    _isOthersSelected = false;
    _isEinsteinSelected = false;
    _showRemovePeriodButton = false;
    _mapPeriods.updateAll((key, value) => value = false);

    _scrollController.dispose();
    _focusEndDate.dispose();
    _focusStartDate.dispose();
    _animationController.dispose();
    _animationControllerShow.dispose();

    super.dispose();
  }

  void _toggleExpanded() {
    if (_animationControllerShow.isDismissed) {
      setState(() {
        _isExpanded = true;
      });
      _animationControllerShow.forward();
    } else {
      _animationControllerShow.reverse();
    }
  }

  void _expandedCalendar() {
    if (_animationController.isDismissed) {
      _animationController.forward();
    }
  }

  void _hideCalendar() {
    if (!_animationController.isDismissed) {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final result = internalFilter.props
        .where(
          (element) => element is List ? element.isNotEmpty : element != null,
        )
        .toList();
    if (result.isEmpty) {
      _showRemovePeriodButton = false;
      _mapPeriods.updateAll((key, value) => value = false);
      passType = [];
      _isFilterValid = false;
    } else {
      _isFilterValid = true;
    }
    if (_isEinsteinSelected || _isOthersSelected) {
      _isFilterValid = true;
    }
    return SingleChildScrollView(
      controller: _scrollController,
      child: Container(
        color: ZeraColors.neutralLight,
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width > 600 ? 40 : 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width > 600 ? 16 : 0,
              ),
              child: ResponsiveAppBar(
                iconAppBar: ZeraIcons.close,
                iconColor: ZeraColors.primaryMedium,
                bottomChild: [
                  ZeraText(
                    FILTER.translate(),
                    type: ZeraTextType.BOLD_24_NEUTRAL_DARK_BASE,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // FilterExpansionTile(
            //   ignoreExpand: true,
            //   showIconTrailing: false,
            //   title: EXECUTION_DATE,
            //   body: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ZeraText(
                EXECUTION_DATE.translate(),
                theme: ZeraTextTheme(
                  fontFamily: kMontserratFontFamily,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  textColor: ZeraColors.neutralDark01,
                ),
              ),
            ),
            ZeraDivider(),
            const SizedBox(height: 16.0),
            RawScrollbar(
              isAlwaysShown: kIsWeb,
              thickness: kIsWeb ? 8 : 0,
              interactive: true,
              thumbColor: ZeraColors.primaryDark,
              radius: const Radius.circular(10),
              controller: _dateController,
              child: Builder(
                builder: (context) {
                  final listDates = [
                    Visibility(
                      visible: _showRemovePeriodButton,
                      child: Container(
                        height: 30,
                        width: 30,
                        margin: const EdgeInsets.only(right: 8, top: 10),
                        child: TextButton(
                          child: Image.asset(
                            XMARK_IMG,
                            package: MICRO_APP_PACKAGE_NAME,
                          ),
                          onPressed: () {
                            _mapPeriods
                                .updateAll((key, value) => value = false);
                            _rangeStart = null;
                            _rangeEnd = null;
                            _showRemovePeriodButton = false;
                            widget.initialDateController.text = '';
                            widget.finalDateController.text = '';
                            _focusedDay = DateTime.now();

                            internalFilter = internalFilter.copyWith(
                              executionInitialDate: _rangeStart,
                              executionFinalDate: _rangeEnd,
                            );
                            externalFilter = externalFilter.copyWith(
                              executionInitialDate: _rangeStart,
                              executionFinalDate: _rangeEnd,
                            );

                            _hideCalendar();
                            setState(() {});
                          },
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                            backgroundColor: MaterialStateProperty.all(
                              ZeraColors.informationColorLightest,
                            ),
                          ),
                        ),
                      ),
                    ),
                    ..._mapPeriods.entries
                        .map(
                          (e) => PeriodButtonWidget(
                            title: e.key,
                            onPressed: () {
                              _mapPeriods
                                  .updateAll((key, value) => value = false);
                              _mapPeriods[e.key] = true;
                              _rangeStart = mapPeriodsValue[e.key]!;
                              _showRemovePeriodButton = true;
                              widget.initialDateController.text =
                                  DateFormat('dd/MM/yy')
                                      .format(mapPeriodsValue[e.key]!);
                              handleFinalDate(e.key.onlyNumbersToInt);
                              _rangeEnd = finalDate;
                              widget.finalDateController.text =
                                  DateFormat('dd/MM/yy').format(finalDate);
                              _focusedDay = mapPeriodsValue[e.key]!;
                              internalFilter = internalFilter.copyWith(
                                executionInitialDate: _rangeStart,
                                executionFinalDate: _rangeEnd,
                              );
                              externalFilter = externalFilter.copyWith(
                                executionInitialDate: _rangeStart,
                                executionFinalDate: _rangeEnd,
                              );

                              _hideCalendar();
                              setState(() {});
                            },
                            isSelected: e.value,
                          ),
                        )
                        .toList(),
                  ];
                  return !kIsWeb
                      ? SingleChildScrollView(
                          controller: _dateController,
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          clipBehavior: Clip.antiAlias,
                          child: Row(
                            children: listDates,
                          ),
                        )
                      : Wrap(
                          children: listDates,
                        );
                },
                // children:const [],
              ),
            ),
            const SizedBox(height: 40.0),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                constraints: const BoxConstraints(
                  maxWidth: 375,
                ),
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: InputCalendarWidget(
                        inputLabel: INITIAL_DATE.translate(),
                        focusNode: _focusStartDate,
                        controller: widget.initialDateController,
                        onTap: () {
                          _expandedCalendar();
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 16.0,
                    ),
                    Expanded(
                      child: InputCalendarWidget(
                        inputLabel: FINAL_DATE.translate(),
                        focusNode: _focusEndDate,
                        controller: widget.finalDateController,
                        onTap: () {
                          _expandedCalendar();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 36.0),
            SizeTransition(
              sizeFactor: _animationController,
              child: Container(
                margin: const EdgeInsets.only(
                  bottom: 16,
                  left: 16,
                  right: 16,
                ),
                constraints: const BoxConstraints(
                  maxWidth: 375,
                ),
                height: 345,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                child: TableCalendar(
                  rangeStartDay: _rangeStart,
                  rangeEndDay: _rangeEnd,
                  rangeSelectionMode: _rangeSelectionMode,
                  onDaySelected: (selectedDay, focusedDay) {
                    if (!isSameDay(_selectedDay, selectedDay)) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                        _rangeStart = null; // Important to clean those
                        _rangeEnd = null;
                        _rangeSelectionMode = RangeSelectionMode.toggledOff;
                      });
                    }
                    if (_focusEnableStart) {
                      widget.initialDateController.text =
                          _outputFormat.format(focusedDay);
                    } else if (_focusEnableEnd) {
                      widget.finalDateController.text =
                          _outputFormat.format(focusedDay);
                    }
                  },
                  onRangeSelected: (start, end, focusedDay) {
                    _showRemovePeriodButton = false;
                    _mapPeriods.updateAll((key, value) => value = false);

                    internalFilter = internalFilter.copyWith(
                      executionInitialDate: start,
                      executionFinalDate: end,
                    );
                    // internalFilter.executionInitialDate = start;
                    // internalFilter.executionFinalDate = end;

                    setState(() {
                      _selectedDay = null;
                      _focusedDay = focusedDay;
                      _rangeStart = start;
                      _rangeEnd = end;
                      _rangeSelectionMode = RangeSelectionMode.toggledOn;

                      if (start != null) {
                        widget.initialDateController.text =
                            _outputFormat.format(start);
                      } else {
                        widget.initialDateController.clear();
                      }

                      if (end != null) {
                        widget.finalDateController.text =
                            _outputFormat.format(end);
                      } else {
                        widget.finalDateController.clear();
                      }
                    });
                  },
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    formatButtonShowsNext: false,
                    titleCentered: true,
                  ),
                  availableCalendarFormats: const {
                    CalendarFormat.month: Month,
                    CalendarFormat.twoWeeks: TWO_WEEKS,
                    CalendarFormat.week: TWO_WEEKS,
                  },
                  selectedDayPredicate: (day) => isSameDay(day, _focusedDay),
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14.0,
                      fontFamily: 'Montserrat',
                      height: 1.6,
                      color: Color(0xff8E959A),
                    ),
                    weekendStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14.0,
                      fontFamily: 'Montserrat',
                      height: 1.6,
                      color: Color(0xffC8D1D9),
                    ),
                    dowTextFormatter: (date, locale) => DateFormat.E(
                      locale,
                    ).format(date)[0].toUpperCase(),
                  ),
                  calendarStyle: CalendarStyle(
                    todayDecoration: const BoxDecoration(),
                    defaultDecoration: const BoxDecoration(),
                    selectedDecoration: BoxDecoration(
                      color: const Color(0xFF0077CF),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    markerDecoration: BoxDecoration(
                      color: const Color(0xff0077CF),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    outsideDaysVisible: false,
                    selectedTextStyle: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 14.0,
                      height: 1.6,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    weekendTextStyle: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 14.0,
                      height: 1.6,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff1B1C1D),
                    ),
                    todayTextStyle: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 14.0,
                      height: 1.6,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff1B1C1D),
                    ),
                    defaultTextStyle: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 14.0,
                      height: 1.6,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff1B1C1D),
                    ),
                  ),
                  calendarBuilders: CalendarBuilders(
                    rangeStartBuilder: (context, day, focusedDay) => Center(
                      child: Container(
                        height: 32,
                        width: 32,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0077CF),
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Center(
                          child: Text(
                            day.day.toString(),
                            style: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 14.0,
                              // height: 1.6,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    rangeEndBuilder: (context, day, focusedDay) => Center(
                      child: Container(
                        height: 32,
                        width: 32,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0077CF),
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Center(
                          child: Text(
                            day.day.toString(),
                            style: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 14.0,
                              // height: 1.6,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    selectedBuilder: (context, day, focusedDay) => Center(
                      child: Container(
                        height: 32,
                        width: 32,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0077CF),
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Center(
                          child: Text(
                            day.day.toString(),
                            style: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 14.0,
                              // height: 1.6,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  rowHeight: 41,
                  daysOfWeekHeight: 35,
                  locale: localization, //'pt_BR',
                  firstDay: DateTime.utc(2000, 1, 1),
                  lastDay: DateTime.now(),
                  focusedDay: _focusedDay,
                  currentDay: _focusedDay,
                ),
              ),
            ),

            //   ],
            // ),
            // FilterExpansionTile(
            //   ignoreExpand: true,
            //   showIconTrailing: false,
            //   title: 'Tipo',
            //   body: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ZeraText(
                PASSAGE.translate(),
                theme: ZeraTextTheme(
                  fontFamily: kMontserratFontFamily,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  textColor: ZeraColors.neutralDark01,
                ),
              ),
            ),
            ZeraDivider(),
            CustomCheckBox(
              isDisabled:
                  _isOthersSelected && !_isEinsteinSelected ? true : false,
              title: INTERNAL.translate(),
              value: internalFilter.passType?.contains(1) ?? false,
              // theme: ZeraCheckboxTheme(
              //   textType: ZeraTextType.REGULAR_MEDIUM_16_DARK_01,
              // ),
              onChanged: (value) {
                if (value == true) {
                  passType.add(1);
                } else {
                  passType.remove(1);
                }
                internalFilter = internalFilter.copyWith(passType: passType);
                setState(() {});
              },
            ),
            ZeraDivider(),
            CustomCheckBox(
              isDisabled:
                  _isOthersSelected && !_isEinsteinSelected ? true : false,
              title: EXTERNAL.translate(),
              value: internalFilter.passType?.contains(2) ?? false,
              // theme: ZeraCheckboxTheme(
              //   textType: ZeraTextType.REGULAR_MEDIUM_16_DARK_01,
              // ),
              onChanged: (value) {
                if (value == true) {
                  passType.add(2);
                } else {
                  passType.remove(2);
                }
                internalFilter = internalFilter.copyWith(passType: passType);
                setState(() {});
              },
            ),
            ZeraDivider(),
            CustomCheckBox(
              isDisabled:
                  _isOthersSelected && !_isEinsteinSelected ? true : false,
              title: EMERGENCY_SERVICE.translate(),
              value: internalFilter.passType?.contains(3) ?? false,
              // theme: ZeraCheckboxTheme(
              //   textType: ZeraTextType.REGULAR_MEDIUM_16_DARK_01,
              // ),
              onChanged: (value) {
                if (value == true) {
                  passType.add(3);
                } else {
                  passType.remove(3);
                }
                internalFilter = internalFilter.copyWith(passType: passType);
                setState(() {});
              },
            ),
            const SizedBox(height: 23.0),
            //   ],
            // ),
            // FilterExpansionTile(
            //   ignoreExpand: true,
            //   showIconTrailing: false,
            //   title: 'Laboratórios',
            //   body: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ZeraText(
                LABORATORIES.translate(),
                theme: ZeraTextTheme(
                  fontFamily: kMontserratFontFamily,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  textColor: ZeraColors.neutralDark01,
                ),
              ),
            ),
            ZeraDivider(),
            CustomCheckBox(
              title: 'Albert Einstein',
              value: _isEinsteinSelected,
              onChanged: (value) {
                _isEinsteinSelected = value ?? false;
                setState(() {});
              },
            ),
            ZeraDivider(),
            CustomCheckBox(
              title: OTHERS_IMPORT_EXAMS.translate(),
              value: _isOthersSelected,
              onChanged: (value) {
                _isOthersSelected = value ?? false;
                setState(() {});
              },
              suffixWidget: Padding(
                padding: const EdgeInsets.only(top: 10.0, right: 16),
                child: CustomTooltipWidget(
                  message: SEE_EXAMS_YOU_IMPORTED_FROM_OTHER_LABS.translate(),
                  child: const Icon(
                    ZeraIcons.question_circle,
                    size: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 48.0),
            Center(
              child: Container(
                constraints: const BoxConstraints(
                  maxWidth: 320,
                ),
                margin: const EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                ),
                child: Column(
                  children: [
                    ZeraButton(
                      text: APPLY.translate(),
                      style: _isFilterValid
                          ? ZeraButtonStyle.PRIMARY_DARK
                          : ZeraButtonStyle.PRIMARY_DISABLE,
                      onPressed: _isFilterValid
                          ? () {
                              ExamsDoctorEntity resultFilter;
                              resultFilter = isBothSelected()
                                  ? doctorFilter = doctorFilter.copyWith(
                                      localLab: _isEinsteinSelected,
                                      otherLab: _isOthersSelected,
                                      internalFilter: internalFilter,
                                      externalFilter: externalFilter,
                                    )
                                  : doctorFilter = doctorFilter.copyWith(
                                      localLab: _isEinsteinSelected,
                                      otherLab: _isOthersSelected,
                                      internalFilter: _isEinsteinSelected
                                          ? internalFilter
                                          : null,
                                      externalFilter: _isOthersSelected
                                          ? externalFilter
                                          : null,
                                    );

                              widget.resultFilter(resultFilter);
                            }
                          : null,
                    ),
                    const SizedBox(height: 16.0),
                    ZeraButton(
                      onPressed: () {
                        widget.initialDateController.clear();
                        widget.finalDateController.clear();
                        passType = [];
                        internalFilter = ExamFiltersEntity();
                        externalFilter = FiltersExternalEntity();
                        _isOthersSelected = false;
                        _isEinsteinSelected = false;
                        _showRemovePeriodButton = false;
                        _mapPeriods.updateAll((key, value) => value = false);
                        setState(() {});
                      },
                      style: ZeraButtonStyle.PRIMARY_CLEAN,
                      text: CLEAR_FILTER.translate(),
                    ),
                    const SizedBox(height: 40.0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool isBothSelected() =>
      (!_isEinsteinSelected && !_isOthersSelected) ||
      (_isEinsteinSelected && _isOthersSelected);
}
