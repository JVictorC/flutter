// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:base_dependencies/dependencies.dart';

import '../../../../core/extensions/mobile_size_extension.dart';
import '../../../../core/utils/primitive_wrapper.dart';
import '../../../../core/widgets/text_field_list.dart';
import '../../domain/entities/exams_filters_entity.dart';
import '../../domain/entities/exams_filters_external_entity.dart';
import '../../domain/entities/exams_medical_records_entity.dart';
import '../../domain/entities/load_date_exam_entity.dart';
import '../../domain/entities/load_exams_entity.dart';
import '../cubits/exam_cubit.dart';
import 'title_hover.dart';

class SearchListExams extends StatefulWidget {
  final ExamFiltersEntity examFiltersEntity;
  final FiltersExternalEntity externalFilter;
  final ExamCubit cubit;
  final DateTime? dateInit;
  final DateTime? dateFinal;
  final TextEditingController controller;
  final LoadDateExamEntity loadDateExamEntity;
  final bool enabledCard;
  final Function actionVoice;
  final Function clearField;
  final void Function()? onTap;
  final PrimitiveWrapper<String> examCode;

  const SearchListExams({
    required this.externalFilter,
    required this.dateInit,
    required this.dateFinal,
    required this.examFiltersEntity,
    required this.cubit,
    required this.controller,
    required this.loadDateExamEntity,
    required this.enabledCard,
    required this.actionVoice,
    required this.clearField,
    required this.examCode,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  State<SearchListExams> createState() => _SearchListExamsState();
}

class _SearchListExamsState extends State<SearchListExams> {
  bool enableList = false;
  bool loadVoice = false;

  Future<ValueChanged<String>?> _submitted(String value) async {
    widget.examCode.value = null;

    if (value.trim().isNotEmpty) {
      widget.controller.text = value.trim();
      widget.examFiltersEntity.examName = widget.controller.text;
      widget.externalFilter.examName = widget.controller.text;
    } else {
      widget.controller.clear();
      widget.examFiltersEntity.examName = null;
      widget.externalFilter.examName = null;
    }

    final loadData = LoadExamEntity(
      lab: null,
      passageId: null,
      initialDate: widget.dateInit ?? widget.loadDateExamEntity.initialDate,
      finalDate: widget.dateFinal ?? widget.loadDateExamEntity.finalDate,
      auxPrint: false,
      chAuthentication: null,
      medicalAppointment: null,
      results: true,
      numberOfRecords: null,
      exams: null,
      idItens: null,
      filters: widget.examFiltersEntity,
      externalFilters: widget.externalFilter,
    );

    if (widget.controller.text.isNotEmpty || widget.enabledCard) {
      await widget.cubit.loadFilter(
        loadExamEntity: loadData,
      );
    } else {
      await widget.cubit.loadExamDate(
        loadDataExamEntity: widget.loadDateExamEntity,
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
        return 70;
      } else {
        return lengthItens * 45;
      }
    }
  }

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.only(
          left: context.isDevice() ? 16.0 : 0.0,
          right: context.isDevice() ? 16.0 : 0.0,
        ),
        height: 48.0,
        child: TextFieldList<ExamsMedicalRecordsEntity>(
          actionVoice: () async {
            loadVoice = true;
            await widget.actionVoice();
            widget.controller.addListener(() {
              if (widget.controller.text.trim().isNotEmpty && loadVoice) {
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
            widget.examCode.value = examCode;
            widget.externalFilter.examName = widget.controller.text;

            final loadData = LoadExamEntity(
              lab: null,
              passageId: null,
              initialDate:
                  widget.dateInit ?? widget.loadDateExamEntity.initialDate,
              finalDate:
                  widget.dateFinal ?? widget.loadDateExamEntity.finalDate,
              auxPrint: false,
              chAuthentication: null,
              medicalAppointment: null,
              results: true,
              numberOfRecords: null,
              exams: examCode,
              idItens: null,
              filters: widget.examFiltersEntity,
              externalFilters: widget.externalFilter,
            );

            await widget.cubit.loadFilter(
              loadExamEntity: loadData,
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
            AutocompleteOnSelected<ExamsMedicalRecordsEntity> onSelected,
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
                            itemCount: options.length > 5 ? 5 : options.length,
                            itemBuilder: (BuildContext context, int index) {
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
      );
}
