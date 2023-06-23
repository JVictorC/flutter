import 'package:intl/intl.dart';

import '../constants/strings.dart';
import '../di/initInjector.dart';
import '../entities/user_auth_info.dart';
import 'translate_extension.dart';

extension DateTimeExtension on DateTime {
  String getWeekDayString() {
    switch (weekday) {
      case 1:
        return MONDAY.translate();
      case 2:
        return TUESDAY.translate();
      case 3:
        return WEDNESDAY.translate();

      case 4:
        return THURSDAY.translate();

      case 5:
        return FRIDAY.translate();

      case 6:
        return SATURDAY.translate();

      default:
        return SUNDAY.translate();
    }
  }

  String? toJson() => DateFormat('yyyy-MM-dd').format(this);

  String? toPtDate() => DateFormat('dd/MM/yyyy').format(this);

  String getMonthString() {
    switch (month) {
      case 1:
        return JANUARY.translate();
      case 2:
        return FEBRUARY.translate();
      case 3:
        return MARCH.translate();
      case 4:
        return APRIL.translate();
      case 5:
        return MAY.translate();
      case 6:
        return JUNE.translate();
      case 7:
        return JULY.translate();
      case 8:
        return AUGUST.translate();
      case 9:
        return SEPTEMBER.translate();
      case 10:
        return OCTOBER.translate();
      case 11:
        return NOVEMBER.translate();
      default:
        return DECEMBER.translate();
    }
  }

  String dateInFull() {
    final user = I.getDependency<UserAuthInfoEntity>();
    final localization = user.localization;

    String dayText = getWeekDayString().substring(0, 3);
    String monthText = getMonthString();
    String dayFormatted = day.toString().padLeft(2, '0');

    return localization == 'en_US'
        ? '$dayText, $monthText $dayFormatted, $year'
        : '$dayText, $dayFormatted $OF $monthText $OF $year';
  }
}
