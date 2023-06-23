import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:pdfx/pdfx.dart';

import 'pdf_view_interface.dart';

class PdfViewerAdapter implements IPdfViewAdapter {
  PdfViewerAdapter();

  @override
  Widget openData(Uint8List data, [controller]) =>
      // @override
      // Widget openData(
      //   Uint8List data, {
      //   controller,
      //   onDocumentLoaded,
      // }) =>
      PdfViewPinch(
        controller: controller,
        builders: PdfViewPinchBuilders<DefaultBuilderOptions>(
          options: const DefaultBuilderOptions(),
          documentLoaderBuilder: (_) =>
              const Center(child: CircularProgressIndicator()),
          pageLoaderBuilder: (_) =>
              const Center(child: CircularProgressIndicator()),
          errorBuilder: (_, error) => Center(child: Text(error.toString())),
        ),
        //onDocumentLoaded: onDocumentLoaded,
        // physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
      );

  // PdfView(

  // PdfViewer.openData(
  //   data,
  //   viewerController = controller,
  //   params = PdfViewerParams(
  //     buildPagePlaceholder: (context, pageNumber, pageRect) => const Center(
  //       child: CircularProgressIndicator(),
  //     ),
  //     panEnabled: true,
  //     alignPanAxis: true,
  //     boundaryMargin: const EdgeInsets.only(
  //       top: 24,
  //       bottom: 8,
  //     ),
  //     scaleEnabled: true,
  //   ),
  // );
}
