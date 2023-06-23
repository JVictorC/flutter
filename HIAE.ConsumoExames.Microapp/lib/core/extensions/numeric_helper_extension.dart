import 'package:flutter/widgets.dart';

import '../constants/strings.dart';
import 'translate_extension.dart';

extension NumericHelper on num {
  double wp(
    BuildContext context, {
    double? minValue,
  }) {
    double maxWidth = MediaQuery.of(context).size.width;

    double size = maxWidth * (this / 10);

    size = minValue != null && minValue > size ? minValue : size;

    return size > 0
        ? size > maxWidth
            ? maxWidth
            : size
        : 1;
  }

  double hp(
    BuildContext context, {
    double? minValue,
  }) {
    final double maxHeight = MediaQuery.of(context).size.height;
    double size = maxHeight * (this / 10);

    size = minValue != null && minValue > size ? minValue : size;

    return size > 0
        ? size > maxHeight
            ? maxHeight
            : size
        : 1;
  }

  String getMonth() {
    switch (this) {
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
}
