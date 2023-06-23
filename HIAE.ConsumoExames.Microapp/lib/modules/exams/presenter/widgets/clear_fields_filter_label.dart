import 'dart:async';

import 'package:flutter/material.dart';

import 'package:base_dependencies/dependencies.dart';

import '../../../../core/constants/strings.dart';
import '../../../../core/extensions/translate_extension.dart';

class ClearFieldsFilterLabel extends StatelessWidget {
  final StreamController<bool> clearFiled;
  final ValueNotifier<bool> enableButton;
  final GestureTapCallback action;
  const ClearFieldsFilterLabel({
    required this.clearFiled,
    required this.action,
    required this.enableButton,
    key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Center(
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: InkWell(
            onTap: () {
              action();

              clearFiled.sink.add(true);
              enableButton.value = false;
            },
            child: ZeraText(
              CLEAR.translate(),
              theme: ZeraTextTheme(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                textColor: ZeraColors.primaryDark,
              ),
            ),
          ),
        ),
      );
}
