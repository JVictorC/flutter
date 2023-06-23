// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';

import 'package:base_dependencies/dependencies.dart';

import '../../../../core/constants/strings.dart';
import '../../../../core/singletons/context_key.dart';
import '../../../../core/widgets/default_app_bar.dart';
import '../../domain/entities/exams_filters_entity.dart';
import 'filter_body_widget.dart';

Future<ExamFiltersEntity?> showWebDialog() async {
  TextEditingController initialDateTimeController = TextEditingController();
  TextEditingController finalDateTimeController = TextEditingController();
  ExamFiltersEntity filter = ExamFiltersEntity();

  // final ExamFiltersEntity? value = await showDialog<ExamFiltersEntity?>(
  final dynamic value = await showDialog(
    context: ContextUtil().context!,
    useSafeArea: true,
    builder: (_) => StatefulBuilder(
      builder: (context, StateSetter setStateModal) => AlertDialog(
        actions: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(40.0),
                  onTap: () {
                    setStateModal(() {
                      initialDateTimeController.clear();
                      finalDateTimeController.clear();
                      filter = ExamFiltersEntity();
                    });
                  },
                  child: Container(
                    height: 50,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(40),
                      ),
                    ),
                    child: Center(
                      child: ZeraText(
                        CLEAR_FILTER,
                        type: ZeraTextType.BOLD_16_DARK_01,
                        color: ZeraColors.primaryMedium,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(40.0),
                  onTap: () {
                    Navigator.of(context).pop(filter);
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: ZeraColors.primaryDark,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(40),
                      ),
                    ),
                    child: Center(
                      child: ZeraText(
                        APPLY,
                        color: ZeraColors.white,
                        theme: const ZeraTextTheme(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
        title: Center(
          child: Container(
            constraints: const BoxConstraints(
              maxWidth: 800,
            ),
            height: 80,
            width: double.infinity,
            child: DefaultAppBar(
              iconAppBar: ZeraIcons.close,
              bottomHeight: 36,
              leftPaddingHeader: 0,
              bottomChild: Container(
                margin: const EdgeInsets.only(left: 16, top: 10, bottom: 12),
                alignment: Alignment.centerLeft,
                child: ZeraText(
                  FILTER,
                  type: ZeraTextType.MEDIUM_20_NEUTRAL_DARK,
                  theme: const ZeraTextTheme(
                    fontWeight: FontWeight.w700,
                    fontSize: 20.0,
                    fontStyle: FontStyle.normal,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),
            ),
          ),
        ),
        content: Center(
          child: Container(
            constraints: const BoxConstraints(
              maxWidth: 800,
            ),
            width: double.infinity,
            color: Colors.white,
            height: MediaQuery.of(context).size.height,
            child: FilterBodyWidget(
              filter: filter,
              filterChanged: (param) {
                filter = param ?? ExamFiltersEntity();
              },
              finalDateController: finalDateTimeController,
              initialDateController: initialDateTimeController,
              resultFilter: (result) {},
              // onDataPress: () {
              //   setStateModal(() {});
              // },
            ),
          ),
        ),
      ),
    ),
  );
  if (value is ExamFiltersEntity) {
    return value;
  }
}
