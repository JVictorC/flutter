import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:base_dependencies/dependencies.dart';

import '../../../../core/constants/strings.dart';
import '../../../../core/extensions/mobile_size_extension.dart';
import '../../../../core/extensions/translate_extension.dart';

class LabelAccountExams extends StatelessWidget {
  final int dateCount;
  final int countLabel;
  final bool filterCardMonth;
  final String? monthLabel;
  final String? yearLabel;
  final GestureTapCallback action;

  const LabelAccountExams({
    required this.dateCount,
    required this.countLabel,
    required this.filterCardMonth,
    required this.monthLabel,
    required this.yearLabel,
    required this.action,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Center(
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 1200,
          ),
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(
            left: context.isDevice() ? 16 : 0,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ZeraText(
                !filterCardMonth
                    ? '${countLabel.toString().padLeft(2, '0')} ${EXAM_DATES_FOUND.translate()}'
                    : '${dateCount.toString().padLeft(2, '0')} ${FOUNDS_PASSAGES_ACCOUNT_FILTER.translate()} $monthLabel ${OF_FILTER_DATE_EXAMS.translate().trim()} $yearLabel',
                color: ZeraColors.neutralDark01,
                theme: const ZeraTextTheme(
                  fontSize: 12.5,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: InkWell(
                  onTap: action,
                  child: ZeraText(
                    CLEAR_FILTER,
                    theme: ZeraTextTheme(
                      textColor: ZeraColors.primaryMedium,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
