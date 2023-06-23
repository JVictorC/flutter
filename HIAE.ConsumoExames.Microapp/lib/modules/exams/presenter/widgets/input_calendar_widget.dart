// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';

import 'package:base_dependencies/dependencies.dart';

import '../../../../core/constants/parameters_constants.dart';

class InputCalendarWidget extends StatelessWidget {
  final void Function(bool)? onFocusChange;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String inputLabel;
  final void Function()? onTap;
  InputCalendarWidget({
    Key? key,
    this.onFocusChange,
    this.controller,
    this.focusNode,
    required this.inputLabel,
    this.onTap,
  }) : super(key: key);
  InputBorder border = OutlineInputBorder(
    borderSide: BorderSide(
      color: ZeraColors.neutralLight03,
      width: 1,
    ),
    borderRadius: BorderRadius.circular(4.0),
  );
  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ZeraText(
            inputLabel,
            theme: const ZeraTextTheme(
              fontWeight: FontWeight.w400,
              fontSize: 16,
              lineHeight: 1.3,
            ),
          ),
          const SizedBox(height: 4.0),
          SizedBox(
            height: 40.0,
            child: Focus(
              onFocusChange: onFocusChange,
              child: TextField(
                focusNode: focusNode,
                onTap: onTap,
                readOnly: true,
                controller: controller,
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(
                  fillColor: ZeraColors.neutralLight,
                  filled: true,
                  hintText: 'dd/mm/aa',
                  hintStyle: TextStyle(
                    color: ZeraColors.neutralDark03,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                    fontFamily: fontFamilyName,
                  ),
                  contentPadding: const EdgeInsets.only(
                    top: 8.0,
                    bottom: 8.0,
                    left: 16,
                  ),
                  suffixIcon: Icon(
                    ZeraIcons.calendar,
                    color: ZeraColors.primaryMedium,
                    size: 24.0,
                  ),
                  border: border,
                  focusedBorder: border,
                  enabledBorder: border,
                ),
              ),
            ),
          ),
        ],
      );
}
