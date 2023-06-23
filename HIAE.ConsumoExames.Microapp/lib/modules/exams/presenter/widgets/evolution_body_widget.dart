import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:base_dependencies/dependencies.dart';

import '../../../../core/constants/routes.dart';
import '../../../../core/constants/strings.dart';
import '../../../../core/extensions/translate_extension.dart';
import '../../domain/entities/evolutionary_report_response_entity.dart';
import 'evolutionary_report_table.dart';

class EvolutionBodyWidget extends StatefulWidget {
  final EvolutionaryReportExamsEntity evolutionEntity;
  const EvolutionBodyWidget({
    Key? key,
    required this.evolutionEntity,
  }) : super(key: key);

  @override
  State<EvolutionBodyWidget> createState() => _EvolutionBodyWidgetState();
}

class _EvolutionBodyWidgetState extends State<EvolutionBodyWidget> {
  // late final String title;
  // final List<DataRow> _listDataRow = [];
  // List<String> titlesExams = [];
  // List<String> listDates = [];

  // _createdData() {
  //   title = widget.evolutionEntity.examsConsultation[0].description;

  //   final List<DataCell> listDataCell = [];
  //   final List<List<DataCell>> listCategory = [];
  //   final List<DataCell> valuesRefer = [];

  //   if (widget
  //       .evolutionEntity.examsConsultation[0].itensConsultation.isNotEmpty) {
  //     for (var itensConsultation
  //         in widget.evolutionEntity.examsConsultation[0].itensConsultation) {
  //       titlesExams.add(itensConsultation.description);

  //       for (var resultsConsultation in itensConsultation.resultsConsultation) {
  //         String examHour = resultsConsultation.hourResult?.toString() ??
  //             const TimeOfDay(hour: 0, minute: 0).toString();
  //         listDates.add(
  //           DateFormat('dd/MM/yy').format(resultsConsultation.dateResult!) +
  //               ' ' +
  //               (examHour.substring(0, 5)),
  //         );

  //         listDataCell.add(
  //           _contentRow(
  //             label: (resultsConsultation.valueResult ?? 'Não coletado') +
  //                 ' ' +
  //                 (resultsConsultation.unityResult ?? ''),
  //             isAnormalResult: resultsConsultation.anormalResult,
  //           ),
  //         );
  //       }
  //       listCategory.add([...listDataCell]);
  //       listDataCell.clear();
  //       valuesRefer.add(
  //         _titleContentRow(
  //           label:
  //               itensConsultation.resultsConsultation[0].defaultRefValue ?? '-',
  //         ),
  //       );
  //     }
  //   }
  //   listDates = listDates.toSet().toList();
  //   if (titlesExams.isEmpty) {
  //     titlesExams.add('-');
  //   }
  //   if (listDates.isEmpty) {
  //     listDates.add('-');
  //   }

  //   if (valuesRefer.isEmpty) {
  //     _listDataRow.add(
  //       DataRow(
  //         cells: [
  //           _titleContentRow(
  //             label: '-',
  //           ),
  //         ],
  //       ),
  //     );
  //   } else {
  //     _listDataRow.add(DataRow(cells: valuesRefer));
  //   }

  //   bool notExit = true;

  //   int j = 0;
  //   int i = 0;

  //   if (listCategory.isNotEmpty) {
  //     while (notExit) {
  //       for (i = 0; i <= listCategory.length - 1; i++) {
  //         listDataCell.add(
  //           listCategory[i][j],
  //         );
  //       }

  //       _listDataRow.add(
  //         DataRow(
  //           cells: [
  //             ...listDataCell,
  //           ],
  //         ),
  //       );
  //       listDataCell.clear();

  //       j++;
  //       notExit = j < listCategory[i - 1].length;
  //     }
  //   } else {
  //     _listDataRow.add(
  //       DataRow(
  //         cells: [
  //           _contentRow(
  //             label: '-',
  //             isAnormalResult: false,
  //           ),
  //         ],
  //       ),
  //     );
  //   }
  // }

  // final int rowHeight = 56;
  // late final ScrollController _scrollController;

  // final List<DataRow> _iterableListDataRow = [];
  // final List<String> _iterableTitlesExams = [];
  // final List<String> _iterableListDates = [];
  // final int initialRowsLoaded = 6;
  // final int rowsToLoad = 10;
  // late int loadedRows;

  // @override
  // void initState() {
  //   super.initState();
  //   _scrollController = ScrollController();
  //   _createdData();
  //   loadedRows = initialRowsLoaded;
  //   loadContent(initialRowsLoaded);
  // }

  // void loadContent(int numOfRows) {
  //   _iterableListDataRow.clear();
  //   _iterableTitlesExams.clear();
  //   _iterableListDates.clear();
  //   _listDataRow.asMap().forEach((key, value) {
  //     if (key < (numOfRows + 1)) _iterableListDataRow.add(value);
  //   });
  //   titlesExams.asMap().forEach((key, value) {
  //     if (key < numOfRows) _iterableTitlesExams.add(value);
  //   });
  //   listDates.asMap().forEach((key, value) {
  //     if (key < numOfRows) _iterableListDates.add(value);
  //   });
  // }

  @override
  void dispose() {
    // _scrollController.dispose();
    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp],
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          color: ZeraColors.neutralLight02,
          child: Center(
            child: Container(
              constraints: const BoxConstraints(
                maxWidth: 1232,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(11),
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.white,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          ZeraText(
                            '${SUBTITLE.translate()}:',
                            color: ZeraColors.neutralDark01,
                            theme: const ZeraTextTheme(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              lineHeight: 1.5,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: ZeraColors.criticalColorDark,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          ZeraText(
                            OUT_OF_REFERENCE_VALUE.translate(),
                            color: ZeraColors.criticalColorDark,
                            theme: const ZeraTextTheme(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              lineHeight: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: EvolutionaryReportTable(
                        examsConsultation:
                            widget.evolutionEntity.examsConsultation[0],
                        // _evolutionaryReports
                        //     .examsConsultation[index],
                      ),
                    ),
                    // SizedBox(
                    //   height: ((36 + 96) + (56 * _iterableListDataRow.length))
                    //       .toDouble(),
                    //   child: DraggableScrollbar(
                    //     alwaysVisibleScrollThumb: true,
                    //     controller: _scrollController,
                    //     backgroundColor: ZeraColors.primaryLight,
                    //     widthScrollThumb: 100,
                    //     scrollThumbBuilder: (
                    //       Color backgroundColor,
                    //       Animation<double> thumbAnimation,
                    //       Animation<double> labelAnimation,
                    //       double width, {
                    //       Text? labelText,
                    //       BoxConstraints? labelConstraints,
                    //     }) =>
                    //         Container(
                    //       height: 10,
                    //       width: width,
                    //       decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(40),
                    //         color: backgroundColor,
                    //       ),
                    //     ),
                    //     child: DataTableWidget(
                    //       controller: _scrollController,
                    //       title: title,
                    //       titleReferColumn: [
                    //         _dataColumn(label: 'Valor\nde referência'),
                    //       ],
                    //       dateReferRows: List.generate(
                    //         _iterableListDates.length,
                    //         (index) => _getRow(date: _iterableListDates[index]),
                    //       ),
                    //       valueColumn: List.generate(
                    //         titlesExams.length,
                    //         (index) => _contentColumn(
                    //           label: titlesExams[index],
                    //         ),
                    //       ),
                    //       valueRows: _iterableListDataRow,
                    //     ),
                    //   ),
                    // ),
                    // const SizedBox(height: 32),
                    // InkWell(
                    //   onTap: () {
                    //     loadedRows += rowsToLoad;
                    //     loadContent(loadedRows);
                    //     setState(() {});
                    //   },
                    //   child: ZeraText(
                    //     'Exibir mais resultados',
                    //     color: ZeraColors.primaryDark,
                    //     theme: const ZeraTextTheme(
                    //       fontWeight: FontWeight.w700,
                    //       fontSize: 16,
                    //       lineHeight: 1.5,
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(height: 40),
                    Center(
                      child: ZeraButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                            Routes.evolutionaryReportGroupsExams,
                          );
                        },
                        text: 'Ver outros laudos evolutivos',
                        style: ZeraButtonStyle.PRIMARY_DARK,
                        theme: ZeraButtonTheme(
                          fontSize: 16,
                          minWidth: 300,
                        ),
                      ),
                    ),
                    const SizedBox(height: 42),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

  // DataRow _getRow({
  //   required String date,
  // }) =>
  //     DataRow(
  //       selected: true,
  //       cells: [
  //         DataCell(
  //           Container(
  //             color: ZeraColors.primaryDarkest,
  //             height: 56,
  //             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  //             alignment: Alignment.center,
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               mainAxisSize: MainAxisSize.max,
  //               children: [
  //                 ZeraText(
  //                   date,
  //                   color: ZeraColors.neutralLight,
  //                   theme: const ZeraTextTheme(
  //                     fontSize: 12,
  //                     fontWeight: FontWeight.w700,
  //                     lineHeight: 1.3,
  //                   ),
  //                 ),
  //                 ZeraText(
  //                   'Ver exame',
  //                   color: ZeraColors.neutralLight,
  //                   theme: const ZeraTextTheme(
  //                     fontSize: 12,
  //                     fontWeight: FontWeight.w600,
  //                     lineHeight: 1.3,
  //                     decoration: TextDecoration.underline,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //           onTap: () {},
  //         ),
  //       ],
  //     );

  // DataCell _titleContentRow({
  //   required String label,
  // }) =>
  //     DataCell(
  //       Container(
  //         height: 56,
  //         color: ZeraColors.primaryLightest,
  //         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  //         alignment: Alignment.center,
  //         child: Row(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           mainAxisSize: MainAxisSize.max,
  //           children: [
  //             Expanded(
  //               child: ZeraText(
  //                 label,
  //                 color: ZeraColors.neutralDark01,
  //                 maxLines: 1,
  //                 theme: const ZeraTextTheme(
  //                   fontSize: 14,
  //                   fontWeight: FontWeight.w400,
  //                   lineHeight: 1.3,
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //       onTap: () {},
  //     );
  // DataCell _contentRow({
  //   required String label,
  //   required bool isAnormalResult,
  //   bool hidden = false,
  // }) =>
  //     DataCell(
  //       Container(
  //         height: 56,
  //         color: hidden ? Colors.transparent : Colors.white,
  //         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  //         alignment: Alignment.center,
  //         child: Row(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           mainAxisSize: MainAxisSize.max,
  //           children: [
  //             hidden
  //                 ? const SizedBox()
  //                 : Expanded(
  //                     child: Row(
  //                       children: [
  //                         ZeraText(
  //                           label,
  //                           color: isAnormalResult
  //                               ? ZeraColors.criticalColorDark
  //                               : ZeraColors.neutralDark01,
  //                           maxLines: 1,
  //                           theme: const ZeraTextTheme(
  //                             fontSize: 14,
  //                             fontWeight: FontWeight.w400,
  //                             lineHeight: 1.3,
  //                           ),
  //                         ),
  //                         if (isAnormalResult) const SizedBox(width: 6),
  //                         if (isAnormalResult)
  //                           Container(
  //                             width: 6,
  //                             height: 6,
  //                             decoration: BoxDecoration(
  //                               color: ZeraColors.criticalColorDark,
  //                               shape: BoxShape.circle,
  //                             ),
  //                           ),
  //                       ],
  //                     ),
  //                   ),
  //           ],
  //         ),
  //       ),
  //       onTap: () {},
  //     );

  // DataColumn _dataColumn({
  //   required String label,
  // }) =>
  //     DataColumn(
  //       label: Padding(
  //         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           mainAxisSize: MainAxisSize.max,
  //           children: [
  //             ZeraText(
  //               label,
  //               color: ZeraColors.neutralDark,
  //               theme: const ZeraTextTheme(
  //                 fontSize: 12,
  //                 fontWeight: FontWeight.w700,
  //                 lineHeight: 1.3,
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     );

  // DataColumn _contentColumn({
  //   required String label,
  // }) =>
  //     DataColumn(
  //       label: Container(
  //         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  //         child: Text(
  //           label,
  //           style: const TextStyle(
  //             color: Colors.white,
  //             fontSize: 12,
  //             fontWeight: FontWeight.w700,
  //             height: 1.3,
  //           ),
  //         ),
  //       ),
  //     );

  // Widget tableWidget() => DataTableWidget(
  //       controller: _scrollController,
  //       title: title,
  //       titleReferColumn: [
  //         _dataColumn(label: 'Valor\nde referência'),
  //       ],
  //       dateReferRows: List.generate(
  //         _iterableListDates.length,
  //         (index) => _getRow(date: _iterableListDates[index]),
  //       ),
  //       valueColumn: List.generate(
  //         titlesExams.length,
  //         (index) => _contentColumn(
  //           label: titlesExams[index],
  //         ),
  //       ),
  //       valueRows: _iterableListDataRow,
  //     );
}
