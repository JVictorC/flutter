import 'dart:convert';

import 'package:universal_html/html.dart';

class DownloadWebUtils {
  void download(
    List<int> bytes, {
    required String downloadName,
  }) {
    // Encode our file in base64
    final _base64 = base64Encode(bytes);
    // Create the link with the file
    final anchor =
        AnchorElement(href: 'data:application/octet-stream;base64,$_base64')
          ..target = 'blank';
    // add the name
    anchor.download = downloadName;
    // trigger download
    document.body?.append(anchor);
    anchor.click();
    anchor.remove();
    return;
  }
}
