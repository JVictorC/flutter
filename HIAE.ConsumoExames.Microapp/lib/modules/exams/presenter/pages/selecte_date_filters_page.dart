import 'dart:async';

import 'package:base_dependencies/dependencies.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../../../core/utils/primitive_wrapper.dart';
import '../../../../core/widgets/date_field_calendar.dart';
import '../widgets/exam_check_box.dart';

class SelectDateFiltersPage extends StatefulWidget {
  final PrimitiveWrapper<int> selectedYear;
  final PrimitiveWrapper<DateTime> initSelectedDate;
  final PrimitiveWrapper<DateTime> finalSelectedDate;
  final ValueNotifier<bool> enableButton;
  final StreamController<bool> clearFields;
  const SelectDateFiltersPage({
    required this.initSelectedDate,
    required this.finalSelectedDate,
    required this.enableButton,
    required this.clearFields,
    required this.selectedYear,
    Key? key,
  }) : super(key: key);

  @override
  State<SelectDateFiltersPage> createState() => _SelectDateFiltersPageState();
}

class _SelectDateFiltersPageState extends State<SelectDateFiltersPage> {
  final int years = DateTime.now().year;

  @override
  void initState() {
    super.initState();
  }

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
            Padding(
              padding: const EdgeInsets.all(30),
              child: DateFieldCalendar(
                dateStart: widget.initSelectedDate.value,
                dateEnd: widget.finalSelectedDate.value,
                enableCalendar: true,
                onChangeInitialDateTime: (d1) {
                  widget.initSelectedDate.value = d1;

                  if (widget.initSelectedDate.value != null && widget.finalSelectedDate.value != null) {
                    widget.enableButton.value = true;
                  }

                  if (widget.selectedYear.value != null) {
                    widget.selectedYear.value = null;
                    setState(() {});
                  }
                },
                onChangeFinalDateTime: (d2) {
                  widget.finalSelectedDate.value = d2;

                  if (widget.initSelectedDate.value != null && widget.finalSelectedDate.value != null) {
                    widget.enableButton.value = true;
                  }
                  if (widget.selectedYear.value != null) {
                    widget.selectedYear.value = null;
                    setState(() {});
                  }
                },
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: ZeraDivider(),
            ),
            SizedBox(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                separatorBuilder: (context, index) => ZeraDivider(),
                itemCount: 5,
                itemBuilder: (context, index) => _checkBox(
                  widget: ExamCheckBox(
                    direction: CheckBoxDirection.left,
                    mainAxisAlignment: MainAxisAlignment.start,
                    defaultValue: widget.selectedYear.value != null && widget.selectedYear.value == (years - index),
                    title: (years - index).toString(),
                    action: (value) {
                      if (value) {
                        widget.selectedYear.value = (years - index);
                        widget.initSelectedDate.value = DateTime((years - index), 1, 1);
                        widget.finalSelectedDate.value = DateTime(
                          ((years - index) + 1),
                          1,
                          1,
                        ).subtract(
                          const Duration(days: 1),
                        );
                      } else {
                        widget.selectedYear.value = null;
                      }

                      setState(() {
                        widget.enableButton.value = true;
                      });
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: ZeraDivider(),
            ),
          ],
        ),
      );
}
