import 'dart:async';

import 'package:base_dependencies/dependencies.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/strings.dart';
import '../../../../core/extensions/translate_extension.dart';
import '../widgets/exam_check_box.dart';

class ReleasedResultsFilterPage extends StatefulWidget {
  final ValueNotifier<bool> enableButton;
  final StreamController<bool> clearFields;
  final List<int> statusResult;
  const ReleasedResultsFilterPage({
    required this.enableButton,
    required this.clearFields,
    required this.statusResult,
    Key? key,
  }) : super(key: key);

  @override
  State<ReleasedResultsFilterPage> createState() =>
      _ReleasedResultsFilterPageState();
}

class _ReleasedResultsFilterPageState extends State<ReleasedResultsFilterPage> {
  Widget _checkBox({required Widget widget}) => Padding(
        padding: !kIsWeb
            ? EdgeInsets.zero
            : const EdgeInsets.symmetric(vertical: 10),
        child: widget,
      );

  @override
  Widget build(BuildContext context) => StreamBuilder<bool>(
        initialData: false,
        stream: widget.clearFields.stream,
        builder: (context, snapshot) => Column(
          children: [
            _checkBox(
              widget: ExamCheckBox(
                direction: CheckBoxDirection.left,
                mainAxisAlignment: MainAxisAlignment.start,
                defaultValue: widget.statusResult.contains(1),
                title: RELEASED.translate(),
                action: (value) {
                  if (value && !widget.statusResult.contains(1)) {
                    widget.statusResult.addAll([1, 2, 3]);
                  } else {
                    widget.statusResult.removeWhere((element) => element < 4);
                  }
                  widget.enableButton.value = true;
                },
              ),
            ),
            ZeraDivider(),
            _checkBox(
              widget: ExamCheckBox(
                direction: CheckBoxDirection.left,
                mainAxisAlignment: MainAxisAlignment.start,
                defaultValue: widget.statusResult.contains(4),
                title: NOT_RELEASED.translate(),
                action: (value) {
                  if (value && !widget.statusResult.contains(4)) {
                    widget.statusResult.add(4);
                  } else {
                    widget.statusResult.remove(4);
                  }
                  widget.enableButton.value = true;
                },
              ),
            ),
            ZeraDivider(),
          ],
        ),
      );
}
