// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';

import 'package:base_dependencies/dependencies.dart';

class CustomTooltipWidget extends StatelessWidget {
  final String message;
  final Widget child;

  const CustomTooltipWidget({
    Key? key,
    required this.message,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Tooltip(
        decoration: BoxDecoration(
          color: const Color(0xFF373F45),
          borderRadius: BorderRadius.circular(3),
        ),
        triggerMode: TooltipTriggerMode.tap,
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        textStyle: const TextStyle(
          fontFamily: kMontserratFontFamily,
          fontWeight: FontWeight.w400,
          fontSize: 12,
          height: 1.5,
          color: Colors.white,
        ),
        message: message,
        child: child,
      );
}
