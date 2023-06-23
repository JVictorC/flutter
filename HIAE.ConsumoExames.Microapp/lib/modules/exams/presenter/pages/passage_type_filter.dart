import 'dart:async';

import 'package:base_dependencies/dependencies.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/strings.dart';
import '../../../../core/extensions/mobile_size_extension.dart';
import '../../../../core/extensions/translate_extension.dart';
import '../widgets/exam_check_box.dart';

class PassageTypeFilter extends StatefulWidget {
  final List<int> passage;
  final ValueNotifier<bool> enableButton;
  final StreamController<bool> clearFields;
  const PassageTypeFilter({
    required this.clearFields,
    required this.enableButton,
    required this.passage,
    Key? key,
  }) : super(key: key);

  @override
  State<PassageTypeFilter> createState() => _PassageTypeFilterState();
}

class _PassageTypeFilterState extends State<PassageTypeFilter> {
  Widget _checkBox({required Widget widget}) => Padding(
        padding: !kIsWeb ? EdgeInsets.zero : const EdgeInsets.symmetric(vertical: 10),
        child: widget,
      );
  @override
  Widget build(BuildContext context) => StreamBuilder<bool>(
        initialData: false,
        stream: widget.clearFields.stream,
        builder: (context, snapshot) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: ZeraText(
                PASSAGE_FILTER_DESCRIPTION.translate(),
                textAlign: TextAlign.left,
                theme: ZeraTextTheme(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  textAlign: TextAlign.center,
                  textColor: ZeraColors.neutralDark,
                ),
              ),
            ),
            _checkBox(
              widget: ExamCheckBox(
                title: INTERNAL.translate(),
                defaultValue: widget.passage.contains(1),
                direction: CheckBoxDirection.left,
                mainAxisAlignment: MainAxisAlignment.start,
                action: (value) {
                  if (value && !widget.passage.contains(1)) {
                    widget.passage.add(1);
                  } else {
                    widget.passage.remove(1);
                  }

                  widget.enableButton.value = true;
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: context.isDevice() ? 50 : 31,
                bottom: 12,
              ),
              child: ZeraText(
                'Exames realizados durante internações, tratamentos quimioterápicos e similares.',
                theme: ZeraTextTheme(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  textColor: ZeraColors.neutralDark01,
                ),
              ),
            ),
            ZeraDivider(),
            _checkBox(
              widget: ExamCheckBox(
                title: EXTERNAL.translate(),
                defaultValue: widget.passage.contains(2),
                direction: CheckBoxDirection.left,
                mainAxisAlignment: MainAxisAlignment.start,
                action: (value) {
                  if (value && !widget.passage.contains(2)) {
                    widget.passage.add(2);
                  } else {
                    widget.passage.remove(2);
                  }

                  widget.enableButton.value = true;
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: context.isDevice() ? 50 : 31,
                bottom: 12,
              ),
              child: ZeraText(
                'Exames feitos com agendamento prévio e/ou realizados em nossas clínicas.',
                theme: ZeraTextTheme(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  textColor: ZeraColors.neutralDark01,
                ),
              ),
            ),
            ZeraDivider(),
            _checkBox(
              widget: ExamCheckBox(
                title: EMERGENCY_SERVICE.translate(),
                defaultValue: widget.passage.contains(3),
                direction: CheckBoxDirection.left,
                mainAxisAlignment: MainAxisAlignment.start,
                action: (value) {
                  if (value && !widget.passage.contains(3)) {
                    widget.passage.add(3);
                  } else {
                    widget.passage.remove(3);
                  }

                  widget.enableButton.value = true;
                },
              ),
            ),
            ZeraDivider(),
            const SizedBox(
              height: 5,
            ),
          ],
        ),
      );
}
