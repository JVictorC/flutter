import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';

import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class DownloadMobileUtils {
  Future<void> downloadFile({
    required Uint8List file64,
    String? fileName,
  }) async {
    var tempDir = await getTemporaryDirectory();
    String fullPath = tempDir.path + '/' + (fileName ?? 'laudo.pdf');
    File file = File(fullPath);
    var raf = file.openSync(mode: FileMode.write);
    raf.writeFromSync(file64);
    await raf.close();
    if (await file.exists()) {
      final teste = await OpenFile.open(file.path);
      if (kDebugMode) {
        print(teste.message);
      }
    } else {
      if (kDebugMode) {
        print('errouuuu');
      }
    }
  }
}
