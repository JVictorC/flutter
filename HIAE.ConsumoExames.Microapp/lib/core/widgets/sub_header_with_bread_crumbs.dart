import 'package:flutter/material.dart';

import 'package:base_dependencies/dependencies.dart';

import '../constants/parameters_constants.dart';
import 'bread_crumbs.dart';
import 'text_sub_title.dart';

class SubHeaderWithBreadCrumbs extends StatelessWidget {
  final List<String> listBreadCrumbs;
  final String title;
  final String subTitle;
  final double? leftPadding;
  const SubHeaderWithBreadCrumbs({
    Key? key,
    required this.listBreadCrumbs,
    required this.title,
    required this.subTitle,
    this.leftPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(
            color: ZeraColors.neutralLight02,
          ),
          Container(
            padding: EdgeInsets.only(
              left: leftPadding ?? DEFAULT_LEFT_PADDING,
              top: 15.0,
              bottom: 15.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BreadCrumbs(
                  listBreadCrumbs: listBreadCrumbs,
                ),
                const SizedBox(
                  height: 16.0,
                ),
                TextSubTitle(
                  title: subTitle,
                ),
              ],
            ),
          ),
          Divider(
            color: ZeraColors.neutralLight02,
          ),
        ],
      );
}
