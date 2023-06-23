import 'dart:typed_data';

import 'package:printing/printing.dart';

import 'printing_interface.dart';

class PrintingAdapter implements IPrinting {
  @override
  showLayoutPDF({required Uint8List file}) async {
    await Printing.layoutPdf(
      onLayout: (format) => file,
    );
  }
}
