import 'package:flutter/material.dart';

import 'package:pdfx/pdfx.dart';

import '../../../../core/adapters/pdf_view/pdf_view_adapter.dart';
import '../../../../core/extensions/string_extension.dart';

class PDFBodyPage extends StatelessWidget {
  const PDFBodyPage({
    Key? key,
    required PdfControllerPinch pdfController,
    required String baseString,
  })  : _pdfController = pdfController,
        _baseString = baseString,
        super(key: key);

  final PdfControllerPinch _pdfController;
  final String _baseString;

  @override
  Widget build(BuildContext context) => Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: Container(
                constraints: const BoxConstraints(
                  // ? MediaQuery.of(context).size.width * 0.7
                  maxWidth: 1024,
                ),
                width: double.infinity,
                alignment: Alignment.center,
                child: MouseRegion(
                  cursor: SystemMouseCursors.grab,
                  child: PdfViewerAdapter().openData(
                    _baseString.toUint8List(),
                    _pdfController,
                  ),
                  // child: pdfWidget,
                ),
              ),
            ),
            // ACESSIBILIDADE PARA ZOOM E TROCA DE PAGINA
            /* Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 40,
                  width: double.infinity,
                  margin: EdgeInsets.only(bottom: 28, left: 16, right: 16),
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Color(0xFF1B1C1D).withOpacity(0.9),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  constraints: BoxConstraints(
                    // maxWidth: 317,
                    maxWidth: 324,
                  ),
                  child: Center(
                    child: Row(
                      children: [
                        PdfPageNumber(
                          controller: _pdfController,
                          builder: (_, loadingState, page, pagesCount) =>
                              Container(
                            alignment: Alignment.center,
                            child: ZeraText(
                              'Página $page de $pagesCount',
                              color: ZeraColors.neutralLight,
                              theme: ZeraTextTheme(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        // ValueListenableBuilder(
                        //   valueListenable: _pdfController,
                        //   builder: (context, _, child) => ZeraText(
                        //     _pdfController.isReady
                        //         ? 'Página ${_pdfController.currentPageNumber} de ${_pdfController.pageCount}'
                        //         : 'Página - ',
                        //     color: ZeraColors.neutralLight,
                        //     theme: ZeraTextTheme(
                        //       fontSize: 14.0,
                        //       fontWeight: FontWeight.w400,
                        //     ),
                        //   ),
                        // ),
                        Expanded(child: SizedBox()),
                        IconBottomPdfWidget(
                          path: NAVIGATION_UP_IMG,
                          onTap: () {
                            //_pdfController.ready?.goToPage(pageNumber: 1);
                            _pdfController.previousPage(
                              duration: Duration(milliseconds: 250),
                              curve: Curves.easeOut,
                            );
                          },
                        ),
                        SizedBox(width: 24),
                        IconBottomPdfWidget(
                          path: NAVIGATION_DOWN_IMG,
                          onTap: () {
                            //_pdfController.ready
                            //    ?.goToPage(pageNumber: _pdfController.pageCount);
                            _pdfController.nextPage(
                              duration: Duration(milliseconds: 250),
                              curve: Curves.easeIn,
                            );
                          },
                        ),
                        SizedBox(width: 24),
                        Container(
                          height: 40,
                          width: 2,
                          color: Color(0xFF1B1C1D),
                        ),
                        SizedBox(width: 24),
                        IconBottomPdfWidget(
                          path: ZOOM_IN_IMG,
                          // onTap: () {
                          //   _pdfController.ready?.setZoomRatio(
                          //     zoomRatio: _pdfController.zoomRatio * 1.5,
                          //   );
                          // },
                        ),
                        SizedBox(width: 24),
                        IconBottomPdfWidget(
                          path: ZOOM_OUT_IMG,
                          // onTap: () {
                          //   _pdfController.ready?.setZoomRatio(
                          //     zoomRatio: _pdfController.zoomRatio / 1.5,
                          //   );
                          // },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              */
          ],
        ),
      );
}
