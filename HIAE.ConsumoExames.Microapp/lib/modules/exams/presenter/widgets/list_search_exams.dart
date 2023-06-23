import 'package:flutter/material.dart';

import '../../../../core/utils/primitive_wrapper.dart';
import '../../domain/entities/exams_filters_entity.dart';
import '../../domain/entities/exams_filters_external_entity.dart';
import '../../domain/entities/load_date_exam_entity.dart';
import '../cubits/exam_cubit.dart';
import 'search_list_exams.dart';

class ListSearchExam extends StatelessWidget {
  final LoadDateExamEntity loadDateFilter;
  final ExamCubit cubit;
  final FiltersExternalEntity externalFilter;
  final ExamFiltersEntity filter;
  final TextEditingController controller;
  final bool enabledCard;
  final Function actionVoice;
  final void Function()? onTap;
  final Function clearField;
  final PrimitiveWrapper<String> examCode;
  const ListSearchExam({
    required this.loadDateFilter,
    required this.cubit,
    required this.filter,
    required this.externalFilter,
    required this.controller,
    required this.enabledCard,
    required this.actionVoice,
    required this.clearField,
    required this.examCode,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: SearchListExams(
            externalFilter: externalFilter,
            examCode: examCode,
            clearField: clearField,
            actionVoice: actionVoice,
            enabledCard: enabledCard,
            loadDateExamEntity: loadDateFilter,
            dateInit: null,
            dateFinal: null,
            cubit: cubit,
            examFiltersEntity: filter,
            controller: controller,
            onTap: onTap,
          ),
        ),
      );
}
