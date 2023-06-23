import 'package:flutter/material.dart';

import 'package:base_dependencies/dependencies.dart';

enum CheckBoxDirection { left, right }

// ignore: must_be_immutable
class ExamCheckBox extends StatefulWidget {
  final String? title;
  final String? subTitle;
  final Function(bool) action;
  final CheckBoxDirection direction;
  final MainAxisAlignment mainAxisAlignment;
  bool? defaultValue;
  ExamCheckBox({
    required this.defaultValue,
    required this.title,
    required this.action,
    this.subTitle,
    this.direction = CheckBoxDirection.right,
    this.mainAxisAlignment = MainAxisAlignment.end,
    Key? key,
  }) : super(key: key);

  @override
  State<ExamCheckBox> createState() => _ExamCheckBoxState();
}

class _ExamCheckBoxState extends State<ExamCheckBox> {
  bool? valueCheckBox;

  List<Widget> _rightCheckBox() => [
        Visibility(
          visible: widget.title != null,
          child: ZeraText(
            widget.title,
          ),
        ),
        Checkbox(
          value: widget.defaultValue ?? valueCheckBox ?? false,
          onChanged: (value) {
            widget.defaultValue = null;
            setState(() {
              valueCheckBox = value ?? false;
              widget.action(valueCheckBox!);
            });
          },
          activeColor: ZeraColors.primaryMedium,
          checkColor: ZeraColors.white,
        ),
      ];

  List<Widget> _leftCheckBox() => [
        Checkbox(
          value: widget.defaultValue ?? valueCheckBox ?? false,
          onChanged: (value) {
            widget.defaultValue = null;
            setState(() {
              valueCheckBox = value ?? false;
              widget.action(valueCheckBox!);
            });
          },
          activeColor: ZeraColors.primaryMedium,
          checkColor: ZeraColors.white,
        ),
        Visibility(
          visible: widget.title != null,
          child: Flexible(
            child: ZeraText(
              widget.title,
            ),
          ),
        ),
      ];

  @override
  Widget build(BuildContext context) => Theme(
        data: ThemeData(
          unselectedWidgetColor: kNeutralColorDark04,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: widget.mainAxisAlignment,
          children: widget.direction == CheckBoxDirection.right
              ? _rightCheckBox()
              : _leftCheckBox(),
        ),
      );
}
