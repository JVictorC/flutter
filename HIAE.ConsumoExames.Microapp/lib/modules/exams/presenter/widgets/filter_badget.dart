import 'package:flutter/material.dart';

import 'package:base_dependencies/dependencies.dart';

// ignore: must_be_immutable
class FilterBadGet extends StatelessWidget {
  final String title;
  final VoidCallback? actionClose;

  const FilterBadGet({
    required this.title,
    required this.actionClose,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.only(left: 10.0),
        height: 42.0,
        decoration: BoxDecoration(
          color: ZeraColors.primaryMedium,
          borderRadius: const BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ZeraText(
              title,
              theme: ZeraTextTheme(
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
                textColor: ZeraColors.white,
              ),
            ),
            IconButton(
              onPressed: actionClose,
              icon: Icon(
                ZeraIcons.close,
                color: ZeraColors.white,
                size: 15,
              ),
            ),
          ],
        ),
      );
}
