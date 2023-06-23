import 'dart:async';

import 'package:base_dependencies/dependencies.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/strings.dart';
import '../../../../core/extensions/translate_extension.dart';
import '../widgets/exam_check_box.dart';

class UnityEinsteinFilterExam extends StatefulWidget {
  final List<String> unity;
  final ValueNotifier<bool> enableButton;
  final StreamController<bool> clearFields;
  const UnityEinsteinFilterExam({
    required this.enableButton,
    required this.clearFields,
    required this.unity,
    Key? key,
  }) : super(key: key);

  @override
  State<UnityEinsteinFilterExam> createState() => _UnityEinsteinFilterExamState();
}

class _UnityEinsteinFilterExamState extends State<UnityEinsteinFilterExam> {
  List<String> hospitalFilter = [
    'Morumbi',
    'Perdizes',
    'Alphaville',
    'Ibirapuera',
    'Chácara Klabin',
    'Jardins',
    'Goiânia',
  ];

  List<String> clinicFilter = [
    'Santana',
    'Pinheiros',
    'Anália Franco',
    'Parque Ibirapuera',
    'Parque da cidade',
  ];

  List<String> airportFilter = [
    'Aeroporto Internacional Tom Jobim (Rio-Galeão)',
  ];

  Widget _label(String title) => Padding(
        padding: const EdgeInsets.all(34),
        child: ZeraText(
          title,
          theme: ZeraTextTheme(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            textColor: ZeraColors.neutralDark,
          ),
        ),
      );

  Widget _checkBox({required Widget widget}) => Padding(
        padding: !kIsWeb ? EdgeInsets.zero : const EdgeInsets.symmetric(vertical: 10),
        child: widget,
      );
  @override
  Widget build(BuildContext context) => StreamBuilder<bool>(
        stream: widget.clearFields.stream,
        initialData: false,
        builder: (context, snapshot) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            _label(
              HOSPITALS.translate(),
            ),
            SizedBox(
              child: ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                separatorBuilder: (context, index) => ZeraDivider(),
                itemCount: hospitalFilter.length,
                itemBuilder: (context, index) => _checkBox(
                  widget: ExamCheckBox(
                    direction: CheckBoxDirection.left,
                    mainAxisAlignment: MainAxisAlignment.start,
                    defaultValue: widget.unity.contains(hospitalFilter[index]),
                    title: hospitalFilter[index],
                    action: (value) {
                      if (value && !widget.unity.contains(hospitalFilter[index])) {
                        widget.unity.add(hospitalFilter[index]);
                      } else {
                        widget.unity.remove(hospitalFilter[index]);
                      }

                      widget.enableButton.value = true;
                    },
                  ),
                ),
              ),
            ),
            ZeraDivider(),
            _label(
              CLINICS.translate(),
            ),
            SizedBox(
              child: ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                separatorBuilder: (context, index) => ZeraDivider(),
                itemCount: clinicFilter.length,
                itemBuilder: (context, index) => _checkBox(
                  widget: ExamCheckBox(
                    direction: CheckBoxDirection.left,
                    mainAxisAlignment: MainAxisAlignment.start,
                    defaultValue: widget.unity.contains(clinicFilter[index]),
                    title: clinicFilter[index],
                    action: (value) {
                      if (value && !widget.unity.contains(clinicFilter[index])) {
                        widget.unity.add(clinicFilter[index]);
                      } else {
                        widget.unity.remove(clinicFilter[index]);
                      }

                      widget.enableButton.value = true;
                    },
                  ),
                ),
              ),
            ),
            ZeraDivider(),
            _label(
              AIRPORT.translate(),
            ),
            SizedBox(
              child: ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                separatorBuilder: (context, index) => ZeraDivider(),
                itemCount: airportFilter.length,
                itemBuilder: (context, index) => _checkBox(
                  widget: ExamCheckBox(
                    direction: CheckBoxDirection.left,
                    mainAxisAlignment: MainAxisAlignment.start,
                    defaultValue: widget.unity.contains(airportFilter[index]),
                    title: airportFilter[index],
                    action: (value) {
                      if (value && !widget.unity.contains(airportFilter[index])) {
                        widget.unity.add(airportFilter[index]);
                      } else {
                        widget.unity.remove(airportFilter[index]);
                      }

                      widget.enableButton.value = true;
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
