import '../constants/strings.dart';
import '../extensions/translate_extension.dart';

String getPassageById(String? id) {
  switch (id) {
    case '1':
      return INTERNAL.translate();
    case '2':
      return EXTERNAL.translate();
    case '3':
      return EMERGENCY_SERVICE.translate();
    default:
      return '-';
  }
}
