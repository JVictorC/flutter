import 'package:flutter/material.dart';

import 'package:base_dependencies/dependencies.dart';

import '../constants/strings.dart';
import '../extensions/translate_extension.dart';
import '../singletons/context_key.dart';

Future<void> showLoadingDialog({
  required BuildContext context,
  required Future<void> Function() action,
  String? title,
}) async {
  BuildContext? dialogContext;

  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      dialogContext = context;

      return WillPopScope(
        onWillPop: () async => true,
        child: SimpleDialog(
          backgroundColor: ZeraColors.neutralLight,
          children: <Widget>[
            Container(
              constraints: const BoxConstraints(
                maxWidth: 272,
              ),
              width: double.infinity,
              height: 180,
              child: Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 24.0,
                        bottom: 20.0,
                      ),
                      child: CircularProgressIndicator(
                        backgroundColor: const Color(
                          0xFFE6F1FB,
                        ),
                        color: ZeraColors.primaryDark,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: SizedBox(
                        child: ZeraText(
                          title ?? WAIT_MOMENT.translate(),
                          color: ZeraColors.primaryDarkest,
                          textAlign: TextAlign.center,
                          theme: const ZeraTextTheme(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: SizedBox(
                        child: ZeraText(
                          KEEP_OPEN_WHILE_PROCESSING.translate(),
                          color: ZeraColors.neutralDark01,
                          textAlign: TextAlign.center,
                          softWrap: true,
                          theme: const ZeraTextTheme(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    },
  );

  await action()
      .then(
    (value) => Navigator.of(
      dialogContext ?? ContextUtil().context!,
      rootNavigator: true,
    ).pop(),
  )
      .catchError(
    (e) {
      Navigator.of(
        dialogContext ?? ContextUtil().context!,
        rootNavigator: true,
      ).pop();
    },
  );
}
