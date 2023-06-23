import 'package:flutter/material.dart';

import 'package:base_dependencies/dependencies.dart';

class DataTableWidget extends StatelessWidget {
  final String title;
  final List<DataColumn> titleReferColumn;
  final List<DataRow> dateReferRows;
  final List<DataColumn> valueColumn;
  final List<DataRow> valueRows;
  final ScrollController? controller;
  const DataTableWidget({
    Key? key,
    required this.title,
    required this.titleReferColumn,
    required this.dateReferRows,
    required this.valueColumn,
    required this.valueRows,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 96,
              ),
              SizedBox(
                width: 127,
                child: DataTable(
                  headingRowHeight: 56,
                  dataRowHeight: 56,
                  headingRowColor: MaterialStateProperty.all(
                    ZeraColors.primaryLightest,
                  ),
                  border: const TableBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4),
                      bottomLeft: Radius.circular(4),
                    ),
                    horizontalInside: BorderSide(
                      color: Colors.white,
                      width: 1,
                    ),
                    verticalInside: BorderSide(
                      color: Colors.white,
                      width: 1,
                    ),
                  ),
                  horizontalMargin: 0,
                  columnSpacing: 0,
                  dividerThickness: 2,
                  showBottomBorder: true,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  columns: titleReferColumn,
                  rows: dateReferRows,
                ),
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: controller,
              scrollDirection: Axis.horizontal,
              // physics: const BouncingScrollPhysics(),
              child: IntrinsicHeight(
                child: IntrinsicWidth(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        height: 56,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 20,
                        ),
                        decoration: BoxDecoration(
                          color: ZeraColors.primaryDarkest,
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(4),
                            topLeft: Radius.circular(4),
                          ),
                        ),
                        alignment: Alignment.centerLeft,
                        child: ZeraText(
                          title,
                          color: Colors.white,
                          theme: const ZeraTextTheme(
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            lineHeight: 1.5,
                          ),
                        ),
                      ),
                      DataTable(
                        headingRowHeight: 40,
                        dataRowHeight: 56,
                        headingRowColor: MaterialStateProperty.all(
                          ZeraColors.primaryMedium,
                        ),
                        showBottomBorder: false,
                        border: const TableBorder(),
                        horizontalMargin: 0,
                        columnSpacing: 0,
                        dividerThickness: 0,
                        columns: valueColumn,
                        rows: valueRows,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );
}
