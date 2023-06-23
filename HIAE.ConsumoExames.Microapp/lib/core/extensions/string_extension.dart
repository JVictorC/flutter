import 'dart:convert';
import 'dart:io' as io;
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_html/html.dart';

import '../utils/color_util.dart';

extension ExString on String {
  static const diacritics =
      'ÀÁÂÃÄÅàáâãäåÒÓÔÕÕÖØòóôõöøÈÉÊËĚèéêëěðČÇçčÐĎďÌÍÎÏìíîïĽľÙÚÛÜŮùúûüůŇÑñňŘřŠšŤťŸÝÿýŽž';
  static const nonDiacritics =
      'AAAAAAaaaaaaOOOOOOOooooooEEEEEeeeeeeCCccDDdIIIIiiiiLlUUUUUuuuuuNNnnRrSsTtYYyyZz';

  String get withoutDiacriticalMarks => splitMapJoin(
        '',
        onNonMatch: (char) => char.isNotEmpty && diacritics.contains(char)
            ? nonDiacritics[diacritics.indexOf(char)]
            : char,
      );

  String get onlyNumbers => replaceAll(RegExp(r'[^0-9]'), '');
  int get onlyNumbersToInt => int.parse(onlyNumbers);

  DateTime stringDatePtBrToDateTime() {
    final value = onlyNumbers.trim();

    final int year = int.parse(
      onlyNumbers.substring(4, value.length),
    );

    final int month = int.parse(
      value.substring(2, 4),
    );

    final int day = int.parse(
      value.substring(0, 2),
    );

    return DateTime(year, month, day);
  }

  bool validStringToDateTime() {
    String strDateTime = onlyNumbers;

    if (strDateTime.length == 8) {
      final int year = int.parse(
        strDateTime.substring(4, strDateTime.trim().length),
      );

      final int month = int.parse(
        strDateTime.substring(2, 4),
      );

      final int day = int.parse(
        strDateTime.substring(0, 2),
      );

      if (day.clamp(1, 31) == day &&
          month.clamp(1, 12) == month &&
          year.clamp(1900, DateTime.now().year + 100) == year) {
        int incMonth = month == 12 ? 1 : month + 1;
        int incYear = month == 12 ? year + 1 : year;
        final lastDayOfMonth = DateTime(incYear, incMonth, 1)
            .subtract(
              const Duration(days: 1),
            )
            .day;

        return day <= lastDayOfMonth;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  double get currencyToDouble {
    final doubleStr = replaceAll(RegExp(r'[.,]'), '');
    final doubleValue = double.tryParse(doubleStr) ?? 0.0;
    return doubleValue > 0 ? doubleValue / 100 : doubleValue;
  }

  Future<io.File?> base64ToFile({
    required String fileName,
    bool openFileAfterConvert = false,
  }) async {
    Uint8List bytes = base64.decode(this);

    if (!kIsWeb) {
      final directory = await getApplicationDocumentsDirectory();
      await directory.exists().then((value) {
        if (value) {
          directory.create();
        }
      });

      String dir = '${directory.path}/$fileName';
      io.File file = io.File(dir);

      if (!file.existsSync()) {
        await file.create();
      }
      await file.writeAsBytes(bytes);

      if (openFileAfterConvert) {
        await OpenFile.open(file.path);
      }

      return file;
    } else {
      final anchor = AnchorElement(
        href: 'data:application/octet-stream;base64,$this',
      )
        ..download = fileName
        ..target = 'blank';

      document.body?.append(anchor);
      anchor.click();
      anchor.remove();
    }
  }

  MaterialColor get color => UtilColor.getMaterialColorFromHex(this);

  Uint8List toUint8List() => base64.decode(this);
}
