import 'package:flutter/material.dart';

import 'package:base_dependencies/dependencies.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../constants/strings.dart';
import '../di/initInjector.dart';
import '../entities/user_auth_info.dart';
import '../extensions/string_extension.dart';
import '../extensions/translate_extension.dart';

// ignore: must_be_immutable
class DateFieldCalendar extends StatefulWidget {
  final Function(DateTime?)? onChangeInitialDateTime;
  final Function(DateTime?)? onChangeFinalDateTime;
  DateTime? dateStart;
  DateTime? dateEnd;
  final bool enableCalendar;

  final bool? readOnly;

  DateFieldCalendar({
    required this.dateStart,
    required this.dateEnd,
    required this.enableCalendar,
    this.onChangeInitialDateTime,
    this.onChangeFinalDateTime,
    this.readOnly,
    Key? key,
  }) : super(key: key);

  @override
  State<DateFieldCalendar> createState() => _DateFieldCalendarState();
}

class _DateFieldCalendarState extends State<DateFieldCalendar>
    with TickerProviderStateMixin {
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOn;

  late DateFormat _outputFormat;
  late AnimationController _animationController;
  late final TextEditingController initialDateController;
  late final TextEditingController finalDateController;

  late String localization;
  late DateTime _focusedDay;

  @override
  void initState() {
    initialDateController = TextEditingController();
    finalDateController = TextEditingController();
    final user = I.getDependency<UserAuthInfoEntity>();
    localization = user.localization;
    _outputFormat = DateFormat('dd/MM/yyyy');

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _focusedDay = DateTime.now();

    if (widget.dateStart != null) {
      initialDateController.text = _outputFormat.format(widget.dateStart!);
    }

    if (widget.dateEnd != null) {
      finalDateController.text = _outputFormat.format(widget.dateEnd!);
    }

    super.initState();
  }

  @override
  void didUpdateWidget(covariant DateFieldCalendar oldWidget) {
    if (widget.dateStart != null) {
      initialDateController.text = _outputFormat.format(widget.dateStart!);
    } else if (initialDateController.text.isNotEmpty) {
      initialDateController.clear();
    }

    if (widget.dateEnd != null) {
      finalDateController.text = _outputFormat.format(widget.dateEnd!);
    } else if (finalDateController.text.isNotEmpty) {
      finalDateController.clear();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    initialDateController.dispose();
    finalDateController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _expandedCalendar() {
    if (_animationController.isCompleted && !widget.enableCalendar) {
      _animationController.reverse();
    } else if (_animationController.isDismissed) {
      _animationController.forward();
    }
  }

  InputBorder border = OutlineInputBorder(
    borderSide: BorderSide(
      color: ZeraColors.neutralLight03,
      width: 1,
    ),
    borderRadius: BorderRadius.circular(4.0),
  );
  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ZeraText(
                      INITIAL_DATE.translate(),
                      theme: const ZeraTextTheme(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        lineHeight: 1.3,
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    TextField(
                      onChanged: (value) {
                        if ((value.isEmpty || value.trim().length != 8) &&
                            (widget.dateStart != null)) {
                          widget.dateStart = null;
                          if (widget.onChangeInitialDateTime != null) {
                            widget.onChangeInitialDateTime!(widget.dateStart);
                          }
                        } else if (value.isNotEmpty &&
                            value.trim().length == 8 &&
                            value.validStringToDateTime()) {
                          widget.dateStart = value.stringDatePtBrToDateTime();
                          if (widget.onChangeInitialDateTime != null) {
                            widget.onChangeInitialDateTime!(widget.dateStart);
                          }
                        }
                      },
                      controller: initialDateController,
                      onSubmitted: (initialDate) {
                        if (initialDate.trim().isNotEmpty &&
                            initialDate.validStringToDateTime()) {
                          initialDate =
                              initialDate.replaceAll(RegExp(r'[^0-9]'), '');

                          widget.dateStart =
                              initialDate.stringDatePtBrToDateTime();
                          initialDateController.text = DateFormat('dd/MM/yyyy')
                              .format(widget.dateStart!);
                          if (widget.onChangeInitialDateTime != null) {
                            widget.onChangeInitialDateTime!(widget.dateStart!);
                          }
                        } else {
                          widget.dateStart = null;
                          initialDateController.clear();
                          if (widget.onChangeInitialDateTime != null) {
                            widget.onChangeInitialDateTime!(widget.dateStart!);
                          }
                        }
                      },
                      onTap: () {
                        _expandedCalendar();
                      },
                      readOnly: widget.readOnly ?? true,
                      keyboardType: TextInputType.datetime,
                      maxLength: 8,
                      decoration: InputDecoration(
                        counterText: '',
                        border: border,
                        focusedBorder: border,
                        enabledBorder: border,
                        errorBorder: border,
                        focusedErrorBorder: border,
                        fillColor: ZeraColors.neutralLight,
                        filled: true,
                        hintText: 'dd/mm/aa',
                        hintStyle: TextStyle(
                          color: ZeraColors.neutralDark03,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                        ),
                        contentPadding: const EdgeInsets.only(
                          top: 8.0,
                          bottom: 8.0,
                          left: 16,
                        ),
                        suffixIcon: Icon(
                          ZeraIcons.calendar,
                          color: ZeraColors.primaryMedium,
                          size: 24.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 16.0,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ZeraText(
                      FINAL_DATE.translate(),
                      theme: const ZeraTextTheme(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        lineHeight: 1.3,
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    TextField(
                      onChanged: (value) {
                        if ((value.isEmpty || value.trim().length != 8) &&
                            (widget.dateEnd != null)) {
                          widget.dateEnd = null;
                          if (widget.onChangeFinalDateTime != null) {
                            widget.onChangeFinalDateTime!(widget.dateEnd);
                          }
                        } else if (value.isNotEmpty &&
                            value.trim().length == 8 &&
                            value.validStringToDateTime()) {
                          widget.dateEnd = value.stringDatePtBrToDateTime();
                          if (widget.onChangeFinalDateTime != null) {
                            widget.onChangeFinalDateTime!(widget.dateEnd);
                          }
                        }
                      },
                      onSubmitted: (finalDate) {
                        if (finalDate.trim().isNotEmpty &&
                            finalDate.validStringToDateTime()) {
                          finalDate =
                              finalDate.replaceAll(RegExp(r'[^0-9]'), '');

                          widget.dateEnd = finalDate.stringDatePtBrToDateTime();
                          finalDateController.text =
                              DateFormat('dd/MM/yyyy').format(widget.dateEnd!);
                          if (widget.onChangeFinalDateTime != null) {
                            widget.onChangeFinalDateTime!(widget.dateEnd);
                          }
                        } else {
                          widget.dateEnd = null;
                          finalDateController.clear();
                          if (widget.onChangeFinalDateTime != null) {
                            widget.onChangeFinalDateTime!(widget.dateEnd);
                          }
                        }
                      },
                      controller: finalDateController,
                      onTap: () {
                        _expandedCalendar();
                      },
                      readOnly: widget.readOnly ?? true,
                      keyboardType: TextInputType.datetime,
                      maxLength: 8,
                      decoration: InputDecoration(
                        counterText: '',
                        border: border,
                        focusedBorder: border,
                        enabledBorder: border,
                        errorBorder: border,
                        focusedErrorBorder: border,
                        fillColor: ZeraColors.neutralLight,
                        filled: true,
                        hintText: 'dd/mm/aa',
                        hintStyle: TextStyle(
                          color: ZeraColors.neutralDark03,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                        ),
                        contentPadding: const EdgeInsets.only(
                          top: 8.0,
                          bottom: 8.0,
                          left: 16,
                        ),
                        suffixIcon: Icon(
                          ZeraIcons.calendar,
                          color: ZeraColors.primaryMedium,
                          size: 24.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: SizeTransition(
              sizeFactor: _animationController,
              child: Container(
                margin: const EdgeInsets.only(
                  top: 15.0,
                  left: 30,
                  right: 30,
                ),
                child: TableCalendar(
                  rangeStartDay: widget.dateStart,
                  rangeEndDay: widget.dateEnd,
                  rowHeight: 41,
                  daysOfWeekHeight: 35,
                  locale: localization, //'pt_BR',
                  firstDay: DateTime.utc(2000, 10, 16),
                  lastDay: DateTime.utc(2030, 3, 14),
                  currentDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(day, _focusedDay),
                  focusedDay: _focusedDay,
                  rangeSelectionMode: _rangeSelectionMode,
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _focusedDay = focusedDay;
                      widget.dateStart = null;
                      widget.dateEnd = null;

                      _rangeSelectionMode = RangeSelectionMode.toggledOff;
                    });
                  },
                  onRangeSelected: (start, end, focusedDay) {
                    if (start != null) {
                      initialDateController.text = _outputFormat.format(start);
                    } else {
                      initialDateController.clear();
                    }

                    if (end != null) {
                      finalDateController.text = _outputFormat.format(end);
                    } else {
                      finalDateController.clear();
                    }

                    widget.dateStart = start;
                    widget.dateEnd = end;

                    if (widget.onChangeInitialDateTime != null) {
                      widget.onChangeInitialDateTime!(widget.dateStart);
                    }

                    if (widget.onChangeFinalDateTime != null) {
                      widget.onChangeFinalDateTime!(widget.dateEnd);
                    }

                    setState(() {
                      _focusedDay = focusedDay;
                      _rangeSelectionMode = RangeSelectionMode.toggledOn;
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
                ),
              ),
            ),
          ),
        ],
      );
}
