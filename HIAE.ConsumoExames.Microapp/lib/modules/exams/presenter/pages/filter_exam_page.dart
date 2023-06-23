import 'package:flutter/material.dart';

import 'package:base_dependencies/dependencies.dart';

import '../../domain/entities/exams_filters_entity.dart';
import '../widgets/filter_body_widget.dart';

class FilterExamPage extends StatefulWidget {
  const FilterExamPage({Key? key}) : super(key: key);

  @override
  State<FilterExamPage> createState() => _FilterExamPageState();
}

class _FilterExamPageState extends State<FilterExamPage> {
  late TextEditingController _startDateTimeController;
  late TextEditingController _endDateTimeController;
  ExamFiltersEntity filter = ExamFiltersEntity();

  @override
  void initState() {
    super.initState();
    _startDateTimeController = TextEditingController();
    _endDateTimeController = TextEditingController();
  }

  @override
  void dispose() {
    _startDateTimeController.dispose();
    _endDateTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Container(
        color: ZeraColors.neutralLight,
        child: SafeArea(
          child: ZeraScaffold(
            body: FilterBodyWidget(
              filter: filter,
              filterChanged: (newFilter) {
                filter = newFilter ?? ExamFiltersEntity();
              },
              finalDateController: _endDateTimeController,
              initialDateController: _startDateTimeController,
              resultFilter: (result) {
                Navigator.of(context).pop(result);
              },
            ),
          ),
        ),
      );
}
