import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../adapters/share/share_adapter.dart';

class ShareMobileUtils {
  Future<void> shareBase64File({
    required List<int> data,
    String? fileName,
  }) async {
    final temp = await getTemporaryDirectory();
    final savePath = '${temp.path}/${fileName ?? 'laudo.pdf'}';

    File file = File(savePath);
    var raf = file.openSync(mode: FileMode.write);
    // response.data is List<int> type
    raf.writeFromSync(data);
    await raf.close();

    await ShareAdapter().shareFiles(
      [savePath], // files
      'Laudo de exame', // title
    );
  }
}
