import 'package:flutter/material.dart';

import 'package:base_dependencies/dependencies.dart';

import '../../../../core/constants/strings.dart';
import '../../../../core/extensions/translate_extension.dart';
import '../../../../core/singletons/context_key.dart';
import '../../../../core/utils/handler_files_picker.dart';
import 'card_with_icon_widget.dart';
import 'error_upload_bottom_sheet.dart';

Future<void> getMobileBottomPicker({
  required Future<void> Function() pdfFun,
  required Future<void> Function() cameraFun,
}) async {
  await Navigator.of(ContextUtil().context!).push<void>(
    ZeraBottomSheet<void>(
      bodyPadding: const EdgeInsets.only(
        top: 16,
      ),
      color: Colors.white,
      child: Container(
        margin: const EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          bottom: 40,
        ),
        child: Column(
          children: [
            GestureDetector(
              onTap: () async {
                try {
                  await pdfFun();
                } on FileSizeException catch (err) {
                  return erroUploadBottomSheet(
                    ContextUtil().context!,
                    err.error,
                  );
                } on FileExtensionException catch (err) {
                  return erroUploadBottomSheet(
                    ContextUtil().context!,
                    err.error,
                  );
                }
                Navigator.of(ContextUtil().context!).pop();
              },
              child: CardWithIconWidget(
                icon: Icon(
                  ZeraIcons.medical_file,
                  color: ZeraColors.primaryMedium,
                ),
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ZeraText(
                      SEARCH_ON_DEVICE.translate(),
                      type: ZeraTextType.SEMI_BOLD_14_DARK_01,
                    ),
                    ZeraText(
                      'Tamanho máximo do arquivo: 20MB',
                      type: ZeraTextType.REGULAR_12_DARK_01,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            GestureDetector(
              onTap: () async {
                await cameraFun();
                Navigator.of(ContextUtil().context!).pop();
              },
              child: CardWithIconWidget(
                icon: Icon(
                  ZeraIcons.photo,
                  color: ZeraColors.primaryMedium,
                ),
                body: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ZeraText(
                      TAKE_PICTURE.translate(),
                      type: ZeraTextType.SEMI_BOLD_14_DARK_01,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),
            Row(
              children: [
                ZeraText(
                  'Formatos aceitos:',
                  theme: const ZeraTextTheme(
                    textColor: Color(
                      0xFF373F45,
                    ),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    lineHeight: 1.7,
                  ),
                ),
                ZeraText(
                  ' pdf, jpeg, png.',
                  theme: const ZeraTextTheme(
                    textColor: Color(
                      0xFF373F45,
                    ),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    lineHeight: 1.7,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      tittle: ZeraText(
        IMPORT_FILE.translate(),
        type: ZeraTextType.BOLD_MEDIUM_16_DARK_01,
      ),
    ),
  );
}
