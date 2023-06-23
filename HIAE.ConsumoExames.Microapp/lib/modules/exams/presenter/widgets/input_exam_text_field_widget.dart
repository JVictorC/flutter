// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';

import 'package:base_dependencies/dependencies.dart';

import '../../../../core/constants/parameters_constants.dart';

class InputExamTextFieldWidget extends StatelessWidget {
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final String? hintText;
  const InputExamTextFieldWidget({
    Key? key,
    this.controller,
    this.onChanged,
    this.hintText,
  }) : super(key: key);
  static final OutlineInputBorder border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(4),
    borderSide: BorderSide(
      color: ZeraColors.neutralDark03,
      // color: ZeraColors.neutralDark03,
      width: 1,
    ),
  );
  @override
  Widget build(BuildContext context) => TextField(
        key: key,
        controller: controller,
        onChanged: onChanged,
        style: TextStyle(
          fontFamily: fontFamilyName,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: ZeraColors.neutralDark01,
          height: 1.5,
        ),
        decoration: InputDecoration(
          hintText: hintText ?? '',
          hintStyle: TextStyle(
            fontFamily: fontFamilyName,
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: ZeraColors.neutralDark03,
            height: 1.5,
          ),
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          border: border,
          enabledBorder: border,
          focusedBorder: border,
        ),
      );
}
