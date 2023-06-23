// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';

import 'package:base_dependencies/dependencies.dart';

import '../../../../core/constants/strings.dart';
import '../../../../core/extensions/translate_extension.dart';
import '../../../../core/singletons/context_key.dart';
import 'card_with_icon_widget.dart';

Future<void> examUploadWebDialog({
  required Future<void> Function() pdfFun,
  required Future<void> Function() cameraFun,
}) async {
  await showDialog(
    context: ContextUtil().context!,
    useSafeArea: true,
    builder: (context) => AlertDialog(
      insetPadding: EdgeInsets.zero,
      buttonPadding: EdgeInsets.zero,
      actionsPadding: EdgeInsets.zero,
      titlePadding: const EdgeInsets.only(
        top: 14,
        bottom: 0,
      ),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ZeraText(
                  'Importar arquivo',
                  color: ZeraColors.neutralDark01,
                  theme: const ZeraTextTheme(
                    fontWeight: FontWeight.w700,
                    fontSize: 16.0,
                    lineHeight: 1.5,
                  ),
                ),
                InkWell(
                  splashColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(
                    ZeraIcons.close,
                    color: ZeraColors.neutralDark03,
                    size: 15,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ZeraDivider(),
        ],
      ),
      contentPadding: EdgeInsets.zero,
      content: Container(
        constraints: const BoxConstraints(
          maxWidth: 376,
        ),
        width: double.infinity,
        height: 200,
        color: Colors.white,
        margin: const EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          bottom: 24,
          top: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () async {
                await pdfFun();
                Navigator.of(context).pop();
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
                      '${MAXIMUM_FILE_SIZE.translate()}: 20MB',
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
                Navigator.of(context).pop();
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
                  '${ACCEPTED_FORMATS.translate()}:',
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
                  ' pdf, jpeg, png, xlsx, docx.',
                  theme: const ZeraTextTheme(
                    textColor: Color(0xFF373F45),
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
    ),
  );
}
