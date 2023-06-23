// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';

import 'package:base_dependencies/dependencies.dart';

class SearchTextFieldWidget extends StatelessWidget {
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final String? hintText;
  const SearchTextFieldWidget({
    Key? key,
    this.controller,
    this.onChanged,
    this.hintText,
  }) : super(key: key);
  static final OutlineInputBorder border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(48),
    borderSide: BorderSide(
      color: ZeraColors.neutralLight03,
      width: 1,
    ),
  );
  @override
  Widget build(BuildContext context) => TextField(
        key: key,
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText ?? '',
          isDense: true,
          contentPadding: const EdgeInsets.all(0),
          prefixIcon: Icon(
            ZeraIcons.search,
            color: ZeraColors.primaryMedium,
          ),
          border: border,
          enabledBorder: border,
          focusedBorder: border,
        ),
      );
}
