// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../core/constants/strings.dart';

class CalendarWidget extends StatelessWidget {
  final DateTime? rangeStartDay;
  final DateTime? rangeEndDay;
  final RangeSelectionMode rangeSelectionMode;
  final void Function(DateTime, DateTime)? onDaySelected;
  final void Function(DateTime?, DateTime?, DateTime)? onRangeSelected;
  final bool Function(DateTime)? selectedDayPredicate;
  final DateTime firstDay;
  final DateTime lastDay;
  final DateTime focusedDay;
  final DateTime? currentDay;
  final String? localization;

  const CalendarWidget({
    Key? key,
    this.rangeStartDay,
    this.rangeEndDay,
    required this.rangeSelectionMode,
    this.onDaySelected,
    this.onRangeSelected,
    this.selectedDayPredicate,
    this.localization,
    required this.firstDay,
    required this.lastDay,
    required this.focusedDay,
    this.currentDay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => TableCalendar(
        rangeStartDay: rangeStartDay,
        rangeEndDay: rangeEndDay,
        rangeSelectionMode: rangeSelectionMode,
        onDaySelected: onDaySelected,
        onRangeSelected: onRangeSelected,
        headerStyle: const HeaderStyle(
          formatButtonVisible: true, //aqui
          formatButtonShowsNext: false,
          titleCentered: true,
        ),
        availableCalendarFormats: const {
          CalendarFormat.month: Month,
          CalendarFormat.twoWeeks: TWO_WEEKS,
          CalendarFormat.week: TWO_WEEKS,
        },
        selectedDayPredicate: selectedDayPredicate,
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
          canMarkersOverflow: true, //
          isTodayHighlighted: true, //
          markersAutoAligned: true, //

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
        locale: localization ?? 'pt_BR',
        firstDay: firstDay,
        lastDay: lastDay,
        focusedDay: focusedDay,
        currentDay: currentDay,
        daysOfWeekVisible: true,
      );
}
