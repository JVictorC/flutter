import 'package:flutter/material.dart';

import 'package:base_dependencies/dependencies.dart';

Future<void> erroUploadBottomSheet(
  BuildContext context,
  String error, {
  void Function()? onButtonPressed,
}) async {
  await Navigator.of(context).push<void>(
    ZeraBottomSheet<void>(
      bodyPadding: const EdgeInsets.only(
        top: 16,
      ),
      color: Colors.white,
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 450,
        ),
        margin: const EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          bottom: 40,
        ),
        child: Column(
          children: [
            ZeraText(
              error,
              color: ZeraColors.neutralDark01,
              textAlign: TextAlign.center,
              theme: const ZeraTextTheme(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                lineHeight: 1.5,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            ZeraButton(
              text: 'Tentar novamente',
              style: ZeraButtonStyle.PRIMARY_DARK,
              onPressed: onButtonPressed ??
                  () {
                    Navigator.of(context).pop();
                  },
            ),
          ],
        ),
      ),
      tittle: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              ZeraIcons.alert_circle,
              color: ZeraColors.criticalColorDark,
              size: 15,
            ),
            Container(
              width: 291,
              alignment: Alignment.center,
              child: ZeraText(
                'Ops! Algo deu errado...',
                type: ZeraTextType.BOLD_MEDIUM_16_DARK_01,
                color: ZeraColors.criticalColorDark,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
