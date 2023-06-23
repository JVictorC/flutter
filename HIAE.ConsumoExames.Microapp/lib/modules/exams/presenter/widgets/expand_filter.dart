// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';

import 'package:base_dependencies/dependencies.dart';

import '../../../../core/widgets/header_expansion_tile.dart';

class ExpandFilter extends StatefulWidget {
  final String title;
  final List<Widget> body;
  final bool showIconTrailing;
  const ExpandFilter({
    Key? key,
    required this.title,
    required this.body,
    this.showIconTrailing = true,
  }) : super(key: key);

  @override
  State<ExpandFilter> createState() => _ExpandFilterState();
}

class _ExpandFilterState extends State<ExpandFilter> {
  @override
  Widget build(BuildContext context) => Theme(
        data: ThemeData(
          dividerColor: Colors.transparent,
        ),
        child: HeaderExpansionTile(
          initiallyExpanded: true,
          backgroundColor: Colors.white,
          collapsedBackgroundColor: Colors.white,
          title: widget.title,
          fontSize: kFontsizeXS,
          textColor: ZeraColors.neutralDark01,
          body: widget.body,
          showIconTrailing: widget.showIconTrailing,
        ),
      );
}
