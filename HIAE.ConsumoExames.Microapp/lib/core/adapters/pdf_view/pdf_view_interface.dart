import 'dart:typed_data';

import 'package:flutter/material.dart';

abstract class IPdfViewAdapter {
  // Widget openData(
  //   Uint8List data, {
  //   controller,
  //   onDocumentLoaded,
  // });
  Widget openData(Uint8List data, [controller]);
}
