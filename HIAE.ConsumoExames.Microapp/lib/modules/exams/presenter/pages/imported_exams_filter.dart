import 'dart:async';

import 'package:base_dependencies/dependencies.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/strings.dart';
import '../../../../core/extensions/translate_extension.dart';
import '../../../../core/utils/primitive_wrapper.dart';
import '../../../../core/widgets/custom_tooltip_widget.dart';
import '../widgets/exam_check_box.dart';

class ImportedExamFilter extends StatefulWidget {
  final PrimitiveWrapper<bool> localLab;
  final PrimitiveWrapper<bool> otherLab;
  final ValueNotifier<bool> enableButton;
  final StreamController<bool> clearFields;
  const ImportedExamFilter({
    required this.localLab,
    required this.otherLab,
    required this.enableButton,
    required this.clearFields,
    Key? key,
  }) : super(key: key);

  @override
  State<ImportedExamFilter> createState() => _ImportedExamFilterState();
}

//OTHERS_IMPORT_EXAMS
class _ImportedExamFilterState extends State<ImportedExamFilter> {
  Widget _checkBox({required Widget widget}) => Padding(
        padding: !kIsWeb ? EdgeInsets.zero : const EdgeInsets.symmetric(vertical: 10),
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
                defaultValue: widget.localLab.value,
                title: 'Albert Einstein',
                action: (value) {
                  widget.localLab.value = value;
                  widget.enableButton.value = true;
                },
              ),
            ),
            ZeraDivider(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: _checkBox(
                    widget: ExamCheckBox(
                      direction: CheckBoxDirection.left,
                      mainAxisAlignment: MainAxisAlignment.start,
                      defaultValue: widget.otherLab.value,
                      title: OTHERS_IMPORT_EXAMS.translate(),
                      action: (value) {
                        widget.otherLab.value = value;
                        widget.enableButton.value = true;
                      },
                    ),
                  ),
                ),
                CustomTooltipWidget(
                  message: 'Veja os exames que você importou de outros laboratórios',
                  child: Icon(
                    Icons.help_outline_outlined,
                    color: ZeraColors.neutralDark02,
                  ),
                ),
              ],
            ),
            ZeraDivider(),
          ],
        ),
      );
}
