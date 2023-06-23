import 'package:flutter/material.dart';

import 'package:base_dependencies/dependencies.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/strings.dart';
import '../../../../core/extensions/translate_extension.dart';
import '../../../../core/utils/snackbar_manager.dart';
import '../../domain/entities/exams_medical_records_entity.dart';
import '../cubits/exam_cubit.dart';
import '../cubits/exam_state_cubit.dart';
import 'evolutionary_data_check.dart';

class SelectedListExamsReportGroup extends StatefulWidget {
  final List<ExamsMedicalRecordsEntity> listExams;

  final Map<String, List<String>> mapExamCode;
  final ExamCubit cubit;
  final String groupName;

  const SelectedListExamsReportGroup({
    required this.groupName,
    required this.listExams,
    required this.cubit,
    required this.mapExamCode,
    Key? key,
  }) : super(key: key);

  @override
  State<SelectedListExamsReportGroup> createState() =>
      _SelectedListExamsReportGroupState();
}

class _SelectedListExamsReportGroupState
    extends State<SelectedListExamsReportGroup> {
  int loadExams = 10;

  @override
  Widget build(BuildContext context) => BlocBuilder<ExamCubit, ExamState>(
        bloc: widget.cubit,
        buildWhen: (context, state) => state is StatusLoadMoreExams,
        builder: (context, state) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListView.builder(
              primary: false,
              shrinkWrap: true,
              itemCount: loadExams >= widget.listExams.length
                  ? widget.listExams.length
                  : loadExams,
              itemBuilder: (context, index) => EvolutionaryDataCheck(
                title: widget.listExams[index].examName,
                defaultValue:
                    widget.mapExamCode.containsKey(widget.groupName) &&
                        widget.mapExamCode[widget.groupName]!.any(
                          (element) =>
                              element == widget.listExams[index].examCode,
                        ),
                action: (value) {
                  int total = 0;

                  widget.mapExamCode.forEach((_, element) {
                    total += element.length;
                  });

                  if (total < 20 || !value) {
                    final bool existsMapCode =
                        widget.mapExamCode.containsKey(widget.groupName) &&
                            widget.mapExamCode[widget.groupName]!
                                .contains(widget.listExams[index].examCode);

                    if (value && !existsMapCode) {
                      if (widget.mapExamCode.containsKey(widget.groupName)) {
                        widget.mapExamCode.update(
                          widget.groupName,
                          (value) => value + [widget.listExams[index].examCode],
                        );
                      } else {
                        widget.mapExamCode.addAll({
                          widget.groupName: [widget.listExams[index].examCode],
                        });
                      }
                    } else if (!value && existsMapCode) {
                      final listExams = widget.mapExamCode[widget.groupName];

                      if (listExams!.length == 1) {
                        widget.mapExamCode.remove(widget.groupName);
                      } else {
                        listExams.remove(widget.listExams[index].examCode);
                        widget.mapExamCode[widget.groupName] = listExams;
                      }
                    }
                  } else if (value) {
                    SnackbarManager(context).showSuccess(
                      message: YOU_CAN_SELECT_A_MAXIMUM_OF_20_EXAMS.translate(),
                    );
                    setState(() {});
                  }

                  widget.cubit.statusButton(widget.mapExamCode.isNotEmpty);
                },
              ),
            ),
            ZeraDivider(),
            const SizedBox(
              height: 16,
            ),
            Center(
              child: InkWell(
                onTap: () {
                  if (loadExams < widget.listExams.length) {
                    loadExams += 10;
                  } else {
                    loadExams = widget.listExams.length;
                  }
                  widget.cubit.loadShowMoreExams(loadExams);
                },
                child: Visibility(
                  visible: loadExams < widget.listExams.length,
                  child: ZeraText(
                    SHOW_MORE_EXAMS.translate(),
                    type: ZeraTextType.REGULAR_14_PRIMARY_MEDIUM,
                    theme: const ZeraTextTheme(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
          ],
        ),
      );
}
