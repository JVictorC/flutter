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
import '../../domain/entities/exams_filters_entity.dart';
import '../../domain/entities/exams_filters_external_entity.dart';
import '../../domain/entities/global_filter_entity.dart';
import 'input_calendar_widget.dart';
import 'period_button_widget.dart';

class FilterBodyWidget extends StatefulWidget {
  ExamFiltersEntity? filter;
  final void Function(ExamFiltersEntity? param) filterChanged;
  final TextEditingController initialDateController;
  final TextEditingController finalDateController;
  final void Function(GlobalFilterEntity) resultFilter;

  FilterBodyWidget({
    Key? key,
    this.filter,
    required this.filterChanged,
    required this.initialDateController,
    required this.finalDateController,
    required this.resultFilter,
  }) : super(key: key);

  @override
  State<FilterBodyWidget> createState() => _FilterBodyWidgetState();
}

class _FilterBodyWidgetState extends State<FilterBodyWidget>
    with TickerProviderStateMixin {
  // with SingleTickerProviderStateMixin {
  FiltersExternalEntity _filterExternal = FiltersExternalEntity();
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
  List<int> examType = [];
  List<int> passType = [];
  List<String> unity = [];
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
      // trata os campos vindo como mês
    } else {
      finalDate = DateTime.now();
    }
  }

  bool _showRemovePeriodButton = false;
  final kLastDay = DateTime(
    DateTime.now().year + 7,
    DateTime.now().month,
    DateTime.now().day,
  );
  List<String> hospitalFilter = [
    'Morumbi',
    'Perdizes',
    'Alphaville',
    'Ibirapuera',
    KLABIN_FARM.translate(),
    'Jardins',
    'Goiânia',
  ];
  List<String> clinicFilter = [
    'Santana',
    'Pinheiros',
    'Anália Franco',
    IBIRAPUERA_PARK.translate(),
    CITYS_PARK.translate(),
  ];
  List<String> airportFilter = [
    TOM_JOBIM_AIRPORT.translate(),
  ];

  late ScrollController _dateController;
  @override
  void initState() {
    super.initState();
    _dateController = ScrollController();

    final user = I.getDependency<UserAuthInfoEntity>();
    localization = user.localization;

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
    widget.initialDateController.addListener(() {
      widget.filter = widget.filter?.copyWith(
        executionInitialDate: _rangeStart,
      );
      _filterExternal = _filterExternal.copyWith(
        executionInitialDate: _rangeStart,
      );

      widget.filterChanged(widget.filter);
    });
    widget.finalDateController.addListener(() {
      widget.filter = widget.filter?.copyWith(
        executionFinalDate: _rangeEnd,
      );
      _filterExternal = _filterExternal.copyWith(
        executionFinalDate: _rangeEnd,
      );

      widget.filterChanged(widget.filter);
    });
    //  finalDateController;
  }

  @override
  void dispose() {
    _dateController.dispose();
    widget.initialDateController.clear();
    widget.finalDateController.clear();
    widget.filter = ExamFiltersEntity();
    _filterExternal = FiltersExternalEntity();
    _isOthersSelected = false;
    _isEinsteinSelected = false;

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

  bool _isValidAlbertinEinsteinFilter() {
    if (examType.isNotEmpty ||
        passType.isNotEmpty ||
        unity.isNotEmpty ||
        (widget.filter?.executionFinalDate != null &&
            widget.filter?.executionInitialDate != null)) {
      if (_isEinsteinSelected) {
        _isFilterValid = true;
        return true;
      }
    }
    return false;
  }

  bool _isValidOthersFilter() {
    if (examType.isNotEmpty ||
        (widget.filter?.executionFinalDate != null &&
            widget.filter?.executionInitialDate != null)) {
      if (_isOthersSelected) {
        _isFilterValid = true;
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    if (_rangeEnd == null || _rangeStart == null) {
      widget.filter?.executionFinalDate = null;
      widget.filter?.executionInitialDate = null;
    }

    final result = widget.filter?.props
        .where(
          (element) => element is List ? element.isNotEmpty : element != null,
        )
        .toList();
    if (result!.isEmpty) {
      _showRemovePeriodButton = false;
      _mapPeriods.updateAll((key, value) => value = false);
      examType = [];
      passType = [];
      unity = [];
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

                            widget.filter = widget.filter?.copyWith(
                              executionInitialDate: _rangeStart,
                              executionFinalDate: _rangeEnd,
                            );
                            _filterExternal = _filterExternal.copyWith(
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

                    // widget.onDataPress();
                  },
                  onRangeSelected: (start, end, focusedDay) {
                    _showRemovePeriodButton = false;
                    _mapPeriods.updateAll((key, value) => value = false);

                    widget.filter?.executionInitialDate = start;
                    widget.filter?.executionFinalDate = end;

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
            //   title: 'Categoria',
            //   body: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ZeraText(
                CATEGORY.translate(),
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
              value: widget.filter?.examType?.contains(1) ?? false,
              title: LABORATORY_EXAM.translate(),
              subTitle: LABORATORY_EXAM_TYPE.translate(),
              onChanged: (value) {
                if (value == true) {
                  examType.add(1);
                } else {
                  examType.remove(1);
                }
                widget.filter = widget.filter?.copyWith(examType: examType);
                widget.filterChanged(widget.filter);
                setState(() {});
              },
            ),

            ZeraDivider(),
            CustomCheckBox(
              value: widget.filter?.examType?.contains(2) ?? false,
              title: DIAGNOSTIC_IMAGE.translate(),
              subTitle: DIAGNOSTIC_IMAGE_TYPE.translate(),
              onChanged: (value) {
                if (value == true) {
                  examType.add(2);
                } else {
                  examType.remove(2);
                }
                widget.filter = widget.filter?.copyWith(examType: examType);
                _filterExternal = _filterExternal.copyWith(examType: examType);
                widget.filterChanged(widget.filter);
                setState(() {});
              },
            ),
            const SizedBox(height: 33.0),

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
              value: widget.filter?.passType?.contains(1) ?? false,
              onChanged: (value) {
                if (value == true) {
                  passType.add(1);
                } else {
                  passType.remove(1);
                }
                widget.filter = widget.filter?.copyWith(passType: passType);
                widget.filterChanged(widget.filter);
                setState(() {});
              },
            ),
            ZeraDivider(),
            CustomCheckBox(
              isDisabled:
                  _isOthersSelected && !_isEinsteinSelected ? true : false,
              title: EXTERNAL.translate(),
              value: widget.filter?.passType?.contains(2) ?? false,
              // theme: ZeraCheckboxTheme(
              //   textType: ZeraTextType.REGULAR_MEDIUM_16_DARK_01,
              // ),
              onChanged: (value) {
                if (value == true) {
                  passType.add(2);
                } else {
                  passType.remove(2);
                }
                widget.filter = widget.filter?.copyWith(passType: passType);
                widget.filterChanged(widget.filter);
                setState(() {});
              },
            ),
            ZeraDivider(),
            CustomCheckBox(
              isDisabled:
                  _isOthersSelected && !_isEinsteinSelected ? true : false,
              title: EMERGENCY_SERVICE.translate(),
              value: widget.filter?.passType?.contains(3) ?? false,
              onChanged: (value) {
                if (value == true) {
                  passType.add(3);
                } else {
                  passType.remove(3);
                }
                widget.filter = widget.filter?.copyWith(passType: passType);
                widget.filterChanged(widget.filter);
                setState(() {});
              },
            ),
            const SizedBox(height: 23.0),

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
              // value: widget.filter?.passType?.contains(1) ?? false,
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
            const SizedBox(height: 23.0),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              // padding: const EdgeInsets.all(8.0),
              child: ZeraText(
                ALBERT_EINSTEIN_UNITS.translate(),
                theme: ZeraTextTheme(
                  fontFamily: kMontserratFontFamily,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  textColor: ZeraColors.neutralDark01,
                ),
              ),
            ),
            ZeraDivider(),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 16.0,
                horizontal: 16,
              ),
              // padding: const EdgeInsets.all(8.0),
              child: ZeraText(
                HOSPITALS.translate(),
                theme: ZeraTextTheme(
                  fontFamily: kMontserratFontFamily,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  textColor: ZeraColors.neutralDark01,
                ),
              ),
            ),
            ZeraDivider(),
            ...initialUnityDisplayed(),
            SizeTransition(
              sizeFactor: _animationControllerShow,
              child: FadeTransition(
                opacity: _animation,
                child: hiddenUnit(),
              ),
            ),

            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: InkWell(
                  onTap: () {
                    _toggleExpanded();
                  },
                  child: ZeraText(
                    _isExpanded
                        ? SHOW_LESS_UNITS.translate()
                        : SHOW_MORE_UNITS.translate(),
                    // type: ZeraTextType.MEDIUM_20_NEUTRAL_DARK,
                    type: ZeraTextType.PRIMARY_MEDIUM_BOLD_16,
                    // style: ZenithTextStyle.medium20NeutralDark,
                    theme: const ZeraTextTheme(
                      fontWeight: FontWeight.w700,
                      fontSize: 14.0,
                      fontStyle: FontStyle.normal,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
              ),
            ),
            //   ],
            // ),
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
                              GlobalFilterEntity resultFilter;
                              resultFilter = isBothSelected()
                                  ? GlobalFilterEntity(
                                      localLab: _isEinsteinSelected,
                                      otherLab: _isOthersSelected,
                                      examFiltersEntity: widget.filter,
                                      filtersExternalEntity: _filterExternal,
                                    )
                                  : GlobalFilterEntity(
                                      localLab: _isEinsteinSelected,
                                      otherLab: _isOthersSelected,
                                      examFiltersEntity: _isEinsteinSelected
                                          ? widget.filter
                                          : null,
                                      filtersExternalEntity: _isOthersSelected
                                          ? _filterExternal
                                          : null,
                                    );

                              widget.resultFilter(resultFilter);
                              widget.initialDateController.clear();
                              widget.finalDateController.clear();
                              widget.filter = ExamFiltersEntity();
                              _filterExternal = FiltersExternalEntity();
                              _isOthersSelected = false;
                              _isEinsteinSelected = false;
                            }
                          : null,
                    ),
                    const SizedBox(height: 16.0),
                    ZeraButton(
                      onPressed: () {
                        widget.initialDateController.clear();
                        widget.finalDateController.clear();
                        widget.filter = ExamFiltersEntity();
                        _filterExternal = FiltersExternalEntity();
                        _isOthersSelected = false;
                        _isEinsteinSelected = false;
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

  List<Widget> initialUnityDisplayed() => [
        // Morumbi
        CustomCheckBox(
          isDisabled: _isOthersSelected && !_isEinsteinSelected ? true : false,
          title: 'Morumbi',
          value: widget.filter?.unity?.contains('Morumbi') ?? false,
          onChanged: (value) {
            if (value == true) {
              unity.add('Morumbi');
            } else {
              unity.remove('Morumbi');
            }
            widget.filter = widget.filter?.copyWith(unity: unity);
            widget.filterChanged(widget.filter);
            setState(() {});
          },
        ),
        ZeraDivider(),
        // Perdizes
        CustomCheckBox(
          isDisabled: _isOthersSelected && !_isEinsteinSelected ? true : false,
          title: 'Perdizes',
          value: widget.filter?.unity?.contains('Perdizes') ?? false,
          onChanged: (value) {
            if (value == true) {
              unity.add('Perdizes');
            } else {
              unity.remove('Perdizes');
            }
            widget.filter = widget.filter?.copyWith(unity: unity);
            widget.filterChanged(widget.filter);
            setState(() {});
          },
        ),
        ZeraDivider(),
        // Alphaville
        CustomCheckBox(
          isDisabled: _isOthersSelected && !_isEinsteinSelected ? true : false,
          title: 'Alphaville',
          value: widget.filter?.unity?.contains('Alphaville') ?? false,
          onChanged: (value) {
            if (value == true) {
              unity.add('Alphaville');
            } else {
              unity.remove('Alphaville');
            }
            widget.filter = widget.filter?.copyWith(unity: unity);
            widget.filterChanged(widget.filter);
            setState(() {});
          },
        ),

        ZeraDivider(),
        // Ibirapuera
        CustomCheckBox(
          isDisabled: _isOthersSelected && !_isEinsteinSelected ? true : false,
          title: 'Ibirapuera',
          value: widget.filter?.unity?.contains('Ibirapuera') ?? false,
          onChanged: (value) {
            if (value == true) {
              unity.add('Ibirapuera');
            } else {
              unity.remove('Ibirapuera');
            }
            widget.filter = widget.filter?.copyWith(unity: unity);
            widget.filterChanged(widget.filter);
            setState(() {});
          },
        ),
        ZeraDivider(),
      ];
  Widget hiddenUnit() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Chácara Klabin
          CustomCheckBox(
            isDisabled:
                _isOthersSelected && !_isEinsteinSelected ? true : false,
            title: KLABIN_FARM.translate(),
            value: widget.filter?.unity?.contains('Chácara Klabin') ?? false,
            onChanged: (value) {
              if (value == true) {
                unity.add('Chácara Klabin');
              } else {
                unity.remove('Chácara Klabin');
              }
              widget.filter = widget.filter?.copyWith(unity: unity);
              widget.filterChanged(widget.filter);
              setState(() {});
            },
          ),
          ZeraDivider(),
          // Jardins
          CustomCheckBox(
            isDisabled:
                _isOthersSelected && !_isEinsteinSelected ? true : false,
            title: 'Jardins',
            value: widget.filter?.unity?.contains('Jardins') ?? false,
            onChanged: (value) {
              if (value == true) {
                unity.add('Jardins');
              } else {
                unity.remove('Jardins');
              }
              widget.filter = widget.filter?.copyWith(unity: unity);
              widget.filterChanged(widget.filter);
              setState(() {});
            },
          ),
          ZeraDivider(),
          // Goiânia
          CustomCheckBox(
            isDisabled:
                _isOthersSelected && !_isEinsteinSelected ? true : false,
            title: 'Goiânia',
            value: widget.filter?.unity?.contains('Goiânia') ?? false,
            onChanged: (value) {
              if (value == true) {
                unity.add('Goiânia');
              } else {
                unity.remove('Goiânia');
              }
              widget.filter = widget.filter?.copyWith(unity: unity);
              widget.filterChanged(widget.filter);
              setState(() {});
            },
          ),
          ZeraDivider(),
          const SizedBox(height: 40.0),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 16,
            ),
            child: ZeraText(
              CLINICS.translate(),
              theme: ZeraTextTheme(
                fontFamily: kMontserratFontFamily,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                textColor: ZeraColors.neutralDark01,
              ),
            ),
          ),
          ZeraDivider(),
          ...List.generate(
            clinicFilter.length,
            (index) => Column(
              children: [
                CustomCheckBox(
                  isDisabled:
                      _isOthersSelected && !_isEinsteinSelected ? true : false,
                  title: clinicFilter[index],
                  value: widget.filter?.unity?.contains(clinicFilter[index]) ??
                      false,
                  onChanged: (value) {
                    if (value == true) {
                      unity.add(clinicFilter[index]);
                    } else {
                      unity.remove(clinicFilter[index]);
                    }
                    widget.filter = widget.filter?.copyWith(unity: unity);
                    widget.filterChanged(widget.filter);
                    setState(() {});
                  },
                ),
                ZeraDivider(),
              ],
            ),
          ),
          const SizedBox(height: 40.0),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 16,
            ),
            child: ZeraText(
              AIRPORT.translate(),
              theme: ZeraTextTheme(
                fontFamily: kMontserratFontFamily,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                textColor: ZeraColors.neutralDark01,
              ),
            ),
          ),
          ZeraDivider(),
          ...List.generate(
            airportFilter.length,
            (index) => Column(
              children: [
                CustomCheckBox(
                  isDisabled:
                      _isOthersSelected && !_isEinsteinSelected ? true : false,
                  title: airportFilter[index],
                  value: widget.filter?.unity?.contains(airportFilter[index]) ??
                      false,
                  onChanged: (value) {
                    if (value == true) {
                      unity.add(airportFilter[index]);
                    } else {
                      unity.remove(airportFilter[index]);
                    }
                    widget.filter = widget.filter?.copyWith(unity: unity);
                    widget.filterChanged(widget.filter);
                    setState(() {});
                  },
                ),
                ZeraDivider(),
              ],
            ),
          ),
        ],
      );
  bool isBothSelected() =>
      (!_isEinsteinSelected && !_isOthersSelected) ||
      (_isEinsteinSelected && _isOthersSelected);
}
