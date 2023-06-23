import 'dart:async';

import 'package:flutter/material.dart';

import 'package:base_dependencies/dependencies.dart';

import '../../../../core/constants/strings.dart';
import '../../../../core/extensions/mobile_size_extension.dart';
import '../../../../core/extensions/translate_extension.dart';
import 'exam_check_box.dart';

class FilterCategory extends StatefulWidget {
  final List<int> examType;
  final ValueNotifier<bool> enableButton;
  final StreamController<bool> clearAllFields;
  const FilterCategory({
    required this.clearAllFields,
    required this.enableButton,
    required this.examType,
    Key? key,
  }) : super(key: key);

  @override
  State<FilterCategory> createState() => _FilterCategoryState();
}

class _FilterCategoryState extends State<FilterCategory> {
  @override
  Widget build(BuildContext context) => StreamBuilder<bool>(
        stream: widget.clearAllFields.stream,
        initialData: false,
        builder: (context, snapshot) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ExamCheckBox(
              direction: CheckBoxDirection.left,
              mainAxisAlignment: MainAxisAlignment.start,
              defaultValue: widget.examType.contains(1),
              title: LABORATORY_EXAM.translate(),
              action: (value) {
                if (value && !widget.examType.contains(1)) {
                  widget.examType.add(1);
                } else if (!value) {
                  widget.examType.remove(1);
                }
                widget.enableButton.value = true;
              },
            ),
            Padding(
              padding: EdgeInsets.only(
                left: context.isDevice() ? 46 : 30,
              ),
              child: ZeraText(
                LABORATORY_EXAM_TYPE,
                theme: const ZeraTextTheme(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            ExamCheckBox(
              direction: CheckBoxDirection.left,
              mainAxisAlignment: MainAxisAlignment.start,
              defaultValue: widget.examType.contains(2),
              title: DIAGNOSTIC_IMAGE.translate(),
              action: (value) {
                if (value && !widget.examType.contains(2)) {
                  widget.examType.add(2);
                } else if (!value) {
                  widget.examType.remove(2);
                }

                widget.enableButton.value = true;
              },
            ),
            Padding(
              padding: EdgeInsets.only(
                left: context.isDevice() ? 46 : 30,
              ),
              child: ZeraText(
                DIAGNOSTIC_IMAGE_TYPE,
                theme: const ZeraTextTheme(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      );
}
