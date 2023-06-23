import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

extension CheckPlatform on BuildContext {
  bool isMobile() => (!kIsWeb &&
      (Platform.isAndroid || Platform.isIOS) &&
      MediaQuery.of(this).size.width < 600);

  bool isTablet() => (!kIsWeb &&
      (Platform.isAndroid || Platform.isIOS) &&
      MediaQuery.of(this).size.width >= 600);

  bool isDevice() => (!kIsWeb && (Platform.isAndroid || Platform.isIOS));
}
