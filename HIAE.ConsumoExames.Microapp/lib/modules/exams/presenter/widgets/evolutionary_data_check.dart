import 'package:flutter/material.dart';

import 'package:base_dependencies/dependencies.dart';

import 'exam_check_box.dart';

class EvolutionaryDataCheck extends StatelessWidget {
  final String title;
  final Function(bool) action;
  final bool defaultValue;
  const EvolutionaryDataCheck({
    required this.title,
    required this.action,
    required this.defaultValue,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: ZeraColors.neutralLight02,
              width: 1,
            ),
          ),
        ),
        child: ExamCheckBox(
          direction: CheckBoxDirection.left,
          title: title,
          defaultValue: defaultValue,
          mainAxisAlignment: MainAxisAlignment.start,
          action: action,
        ),
      );
}
