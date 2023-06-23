import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:base_dependencies/dependencies.dart';

import '../../../../core/extensions/mobile_size_extension.dart';
import '../../../../core/widgets/text_field_list.dart';
import '../../domain/entities/exams_doctor_entity.dart';
import '../../domain/entities/exams_medical_records_entity.dart';
import '../../domain/entities/load_exams_entity.dart';
import '../cubits/exam_cubit.dart';
import 'title_hover.dart';

class SearchListExamDoctor extends StatefulWidget {
  final ExamsDoctorEntity examsDoctor;
  final TextEditingController controller;
  final void Function()? openFilter;
  final Function clearField;
  final Function actionVoice;
  final bool enabledCard;
  final ExamCubit cubit;

  const SearchListExamDoctor({
    required this.examsDoctor,
    required this.openFilter,
    required this.clearField,
    required this.actionVoice,
    required this.controller,
    required this.enabledCard,
    required this.cubit,
    Key? key,
  }) : super(key: key);

  @override
  State<SearchListExamDoctor> createState() => _SearchListExamDoctorState();
}

class _SearchListExamDoctorState extends State<SearchListExamDoctor> {
  bool enableList = false;
  bool loadVoice = false;

  Future<ValueChanged<String>?> _submitted(String value) async {
    widget.examsDoctor.examCode = null;

    if (value.trim().isNotEmpty) {
      widget.controller.text = value.trim();
      widget.examsDoctor.internalFilter!.examName = widget.controller.text;
      widget.examsDoctor.externalFilter!.examName = widget.controller.text;
    } else {
      widget.controller.clear();
      widget.examsDoctor.internalFilter!.examName = null;
      widget.examsDoctor.externalFilter!.examName = null;
    }

    final loadData = LoadExamEntity(
      lab: null,
      passageId: null,
      initialDate: widget.examsDoctor.examsDate.initialDate,
      finalDate: widget.examsDoctor.examsDate.finalDate,
      auxPrint: false,
      chAuthentication: null,
      medicalAppointment: null,
      results: true,
      numberOfRecords: null,
      exams: null,
      idItens: null,
      filters: widget.examsDoctor.internalFilter!,
      externalFilters: widget.examsDoctor.externalFilter!,
    );

    if (widget.controller.text.isNotEmpty || widget.enabledCard) {
      await widget.cubit.loadFilter(
        loadExamEntity: loadData,
      );
    } else {
      await widget.cubit.loadExamDate(
        loadDataExamEntity: widget.examsDoctor.examsDate,
      );
    }
  }

  double _getHeight(int lengthItens) {
    if (kIsWeb) {
      return lengthItens >= 5 ? 150 : (lengthItens * 40);
    } else {
      if (lengthItens >= 5) {
        return 150;
      } else if (lengthItens == 1) {
        return 75;
      } else {
        return lengthItens * 55;
      }
    }
  }

  @override
  Widget build(BuildContext context) => Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          padding: EdgeInsets.only(
            left: context.isDevice() ? 16.0 : 0.0,
          ),
          height: 36.0,
          child: Row(
            children: [
              Flexible(
                child: TextFieldList<ExamsMedicalRecordsEntity>(
                  actionVoice: () async {
                    loadVoice = true;
                    widget.actionVoice();
                    widget.controller.addListener(() {
                      if (widget.controller.text.trim().isNotEmpty &&
                          loadVoice) {
                        loadVoice = false;
                        _submitted(widget.controller.text);
                      }
                    });
                  },
                  controller: widget.controller,
                  onSubmitted: _submitted,
                  clearField: widget.clearField,
                  onChange: (value) {
                    enableList = value.trim().length >= 3;

                    if (value.isEmpty) {
                      widget.controller.clear();
                    }
                  },
                  list: widget.cubit.listMedicalRecordsExams,
                  displayStringForOption: (ExamsMedicalRecordsEntity option) =>
                      option.examName,
                  onSelected: (selection) async {
                    widget.controller.text = selection.examName.trim();
                    final String examCode = selection.examCode;
                    widget.examsDoctor.examCode = examCode;
                    widget.examsDoctor.externalFilter!.examName =
                        widget.controller.text.trim();

                    await widget.cubit.loadFilter(
                      loadExamEntity: LoadExamEntity(
                        lab: null,
                        passageId: null,
                        initialDate: widget.examsDoctor.examsDate.initialDate,
                        finalDate: widget.examsDoctor.examsDate.finalDate,
                        auxPrint: false,
                        chAuthentication: null,
                        medicalAppointment: null,
                        results: true,
                        numberOfRecords: null,
                        exams: examCode,
                        idItens: null,
                        filters: widget.examsDoctor.internalFilter!,
                        externalFilters: widget.examsDoctor.externalFilter!,
                      ),
                    );
                  },
                  optionsBuilder: (
                    TextEditingValue fieldTextEditingController,
                  ) {
                    final list = widget.cubit.listMedicalRecordsExams
                        .where(
                          (value) => value.examName.toLowerCase().contains(
                                fieldTextEditingController.text.toLowerCase(),
                              ),
                        )
                        .toList();

                    list.sort(
                      (a, b) => a.examName.compareTo(b.examName),
                    );
                    return list;
                  },
                  optionsViewBuilder: (
                    BuildContext context,
                    AutocompleteOnSelected<ExamsMedicalRecordsEntity>
                        onSelected,
                    Iterable<ExamsMedicalRecordsEntity> options,
                  ) =>
                      LayoutBuilder(
                    builder: (context, constraints) => Visibility(
                      visible: enableList,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Material(
                          color: Colors.white,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: 1130,
                              minWidth: kIsWeb ? 430 : 300,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 16,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: ZeraColors.primaryMedium,
                                  ),
                                ),
                                width: kIsWeb
                                    ? MediaQuery.of(context).size.width - 80
                                    : MediaQuery.of(context).size.width - 100,
                                height: _getHeight(options.length),
                                child: Scrollbar(
                                  interactive: true,
                                  // ignore: deprecated_member_use
                                  isAlwaysShown: true,
                                  child: ListView.builder(
                                    itemCount:
                                        options.length > 5 ? 5 : options.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      final option = options.elementAt(index);

                                      return TitleHover(
                                        onTap: () {
                                          onSelected(option);
                                        },
                                        title: option.examName,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: widget.openFilter,
                splashColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: 15.0,
                    left: 20.0,
                  ),
                  child: Icon(
                    ZeraIcons.filter_1,
                    size: 20.0,
                    color: ZeraColors.primaryMedium,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
