import 'package:flutter/material.dart';

import 'package:base_dependencies/dependencies.dart';

class CheckRadioWidget extends StatelessWidget {
  final dynamic targetValue;
  final dynamic value;
  final void Function()? onTap;
  final EdgeInsetsGeometry? marin;
  const CheckRadioWidget({
    Key? key,
    this.targetValue,
    this.value,
    this.marin,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Container(
          width: 20,
          height: 20,
          margin: marin,
          decoration: BoxDecoration(
            color: targetValue == value ? ZeraColors.primaryDark : Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: targetValue == value
                  ? ZeraColors.primaryDark
                  : ZeraColors.neutralLight04,
              width: 1.5,
            ),
          ),
          child: targetValue == value
              ? Center(
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                )
              : null,
        ),
      );
}
