// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';

import 'package:base_dependencies/dependencies.dart';

class ItemDecorationTableWidget extends StatelessWidget {
  final Color color;
  final String text;
  const ItemDecorationTableWidget({
    Key? key,
    required this.color,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Container(
            height: 10,
            width: 10,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: color,
            ),
          ),
          const SizedBox(width: 8),
          ZeraText(
            text,
            theme: ZeraTextTheme(
              fontSize: 12.0,
              fontWeight: FontWeight.w400,
              textColor: ZeraColors.neutralDark,
            ),
          ),
        ],
      );
}
