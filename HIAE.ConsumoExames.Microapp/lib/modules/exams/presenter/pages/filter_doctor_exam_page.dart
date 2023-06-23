// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';

import 'package:base_dependencies/dependencies.dart';

import '../../domain/entities/exams_doctor_entity.dart';
import '../widgets/filter_doctor_body_widget.dart';

class FilterDoctorExamPage extends StatefulWidget {
  const FilterDoctorExamPage({Key? key}) : super(key: key);

  @override
  State<FilterDoctorExamPage> createState() => _FilterDoctorExamPageState();
}

class _FilterDoctorExamPageState extends State<FilterDoctorExamPage> {
  late TextEditingController _startDateTimeController;
  late TextEditingController _endDateTimeController;
  late ExamsDoctorEntity doctorFilter;
  @override
  void initState() {
    super.initState();
    _startDateTimeController = TextEditingController();
    _endDateTimeController = TextEditingController();
  }

  bool _isLoaded = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isLoaded) {
      _isLoaded = true;
      doctorFilter =
          ModalRoute.of(context)?.settings.arguments as ExamsDoctorEntity;
    }
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
            body: FilterDoctorBodyWidget(
              doctorFilter: doctorFilter,
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
