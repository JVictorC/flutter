import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:base_dependencies/dependencies.dart';

import '../../../../core/constants/strings.dart';
import '../../../../core/extensions/mobile_size_extension.dart';
import '../../../../core/extensions/numeric_helper_extension.dart';
import '../../../../core/extensions/translate_extension.dart';
import '../cubits/exam_cubit.dart';
import 'arrow_scroll_button.dart';
import 'card_date_with_icon.dart';

// ignore: must_be_immutable
class ListDateCards extends StatefulWidget {
  final ExamCubit cubit;
  final int loadCountList;
  final Function clearField;
  final int? defaultMonthCard;
  final int? defaultYearCard;
  final ScrollController scrollController;
  final double? positionScroll;
  final Future<void> Function(DateTime dateInit, DateTime dateFim) clickedCard;

  const ListDateCards({
    required this.clearField,
    required this.clickedCard,
    required this.cubit,
    required this.loadCountList,
    required this.defaultYearCard,
    required this.defaultMonthCard,
    required this.scrollController,
    required this.positionScroll,
    Key? key,
  }) : super(key: key);

  @override
  State<ListDateCards> createState() => _ListDateCardsState();
}

class _ListDateCardsState extends State<ListDateCards> {
  bool hoverArrowRight = false;
  bool hoverArrowLeft = false;
  bool selectedCard = false;
  int? selectedYear;
  int? selectedMonth;
  double leftPosition = 0;
  double rightPosition = 0;

  @override
  void initState() {
    super.initState();

    selectedYear = widget.defaultYearCard;
    selectedMonth = widget.defaultMonthCard;
    selectedCard = selectedYear != null && selectedMonth != null;

    // ignore: prefer_null_aware_operators, unnecessary_null_comparison
    var execute = WidgetsBinding != null ? WidgetsBinding.instance : null;

    execute!.addPostFrameCallback(
      (_) {
        if (widget.positionScroll != null) {
          widget.scrollController.jumpTo(widget.positionScroll!);
        }
      },
    );
  }

  Future<void> onTapCard() async {}

  bool isSelected({required int year, required int month}) =>
      year == selectedYear && selectedMonth == month;

  List<Widget> labelAccount(BuildContext context) => [
        const SizedBox(
          height: 24.0,
        ),
        Visibility(
          visible: widget.cubit.listDateExams.isNotEmpty,
          child: Padding(
            padding: EdgeInsets.only(
              left: context.isDevice() ? 5.0 : 0.0,
            ),
            child: ZeraText(
              '${widget.cubit.listDateExams.length > widget.loadCountList ? widget.loadCountList.toString().padLeft(2, '0') : widget.cubit.listDateExams.length.toString().padLeft(2, '0')} $EXAMS_RESULT_FOUND',
              color: ZeraColors.neutralDark01,
              theme: const ZeraTextTheme(
                fontSize: 12.5,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 40.0,
        ),
      ];

  Widget _closeButton() => InkWell(
        hoverColor: Colors.transparent,
        canRequestFocus: false,
        onTap: () {
          widget.clearField();
          setState(() {
            selectedCard = false;
            selectedYear = null;
            selectedMonth = null;
          });
        },
        child: Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            color: ZeraColors.primaryLightest,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              Icons.close,
              size: 15,
              color: ZeraColors.primaryDarkest,
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) => SizedBox(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: context.isDevice() ? 16 : 0,
                right: context.isDevice() ? 16 : 0,
              ),
              child: Visibility(
                visible: widget.cubit.datesCards?.isNotEmpty ?? false,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ZeraText(
                            DATE_I_LOOK_EXAMS.translate(),
                            theme: ZeraTextTheme(
                              fontFamily: kMontserratFontFamily,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              textColor: ZeraColors.neutralDark,
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          ZeraText(
                            SELECT_DATE_BELOW_EXAMS_DATE.translate(),
                            theme: ZeraTextTheme(
                              fontFamily: kMontserratFontFamily,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              textColor: ZeraColors.neutralDark02,
                            ),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: kIsWeb,
                      child: ArrowScrollButton(
                        scrollController: widget.scrollController,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(
                      left: context.isDevice() ? 16 : 0,
                      right: context.isDevice() ? 16 : 0,
                    ),
                    controller: widget.scrollController,
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      height: 80,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: widget.cubit.datesCards?.values.length ?? 0,
                        itemBuilder: (
                          BuildContext context,
                          int indexHeader,
                        ) {
                          final month = widget.cubit.datesCards?.values
                              .elementAt(indexHeader);
                          final year = widget.cubit.datesCards?.keys
                              .elementAt(indexHeader);

                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: month!.length,
                            itemBuilder:
                                (BuildContext context, int indexCard) => Stack(
                              alignment: Alignment.topRight,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 5,
                                  ),
                                  child: InkWell(
                                    hoverColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      final dateBegin = (month[indexCard] < 12)
                                          ? DateTime(
                                              year!,
                                              month[indexCard] + 1,
                                              1,
                                            )
                                          : DateTime(
                                              year! + 1,
                                              1,
                                              1,
                                            );

                                      final lastDate = dateBegin.subtract(
                                        const Duration(days: 1),
                                      );

                                      final dateInitial = DateTime(
                                        year,
                                        month[indexCard],
                                        1,
                                      );

                                      await widget.clickedCard(
                                        dateInitial,
                                        lastDate,
                                      );
                                      setState(
                                        () {
                                          selectedYear = year;
                                          selectedMonth = month[indexCard];
                                          selectedCard = true;
                                          // selectedCard = indexCard;
                                        },
                                      );
                                    },
                                    child: CardDateWithIcon(
                                      isSelected: isSelected(
                                        year: year!,
                                        month: month[indexCard],
                                      ),
                                      yearLabel: year.toString(),
                                      monthLabel: month[indexCard]
                                          .getMonth()
                                          .toUpperCase()
                                          .substring(0, 3),
                                      onTapCloseButton: () {
                                        widget.clearField();
                                        setState(() {
                                          selectedCard = false;
                                          selectedYear = null;
                                          selectedMonth = null;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: isSelected(
                                    year: year,
                                    month: month[indexCard],
                                  ),
                                  child: Align(
                                    alignment: Alignment.topRight,
                                    child: _closeButton(),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
}
