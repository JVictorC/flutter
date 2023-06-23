// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:base_dependencies/dependencies.dart';

class FilterExpansionTile extends StatefulWidget {
  final Widget? leading;
  final String title;
  final String? subTitle;
  final List<Widget> body;
  final bool initiallyExpanded;
  final double? fontSize;
  final Color? textColor;
  final Color? collapsedBackgroundColor;
  final Color? backgroundColor;
  final Future? loadDetail;
  final bool showIconTrailing;
  final bool ignoreExpand;

  const FilterExpansionTile({
    Key? key,
    this.leading,
    required this.title,
    this.subTitle,
    required this.body,
    this.initiallyExpanded = true,
    this.fontSize = kFontsizeXS,
    this.textColor = const Color(0xFF373F45),
    this.collapsedBackgroundColor,
    this.backgroundColor = Colors.white,
    this.loadDetail,
    this.showIconTrailing = false,
    this.ignoreExpand = false,
  }) : super(key: key);

  @override
  State<FilterExpansionTile> createState() => _FilterExpansionTileState();
}

class _FilterExpansionTileState extends State<FilterExpansionTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late bool opened;

  @override
  void initState() {
    opened = false;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: widget.initiallyExpanded,
          collapsedBackgroundColor: widget.collapsedBackgroundColor,
          backgroundColor: widget.backgroundColor,
          trailing: Visibility(
            visible: widget.showIconTrailing,
            child: RotationTransition(
              turns: Tween(begin: 0.0, end: 0.5).animate(_controller),
              child: Icon(
                widget.initiallyExpanded
                    ? ZeraIcons.arrow_up_1
                    : ZeraIcons.arrow_down_1,
                color: opened || widget.initiallyExpanded
                    ? ZeraColors.primaryMedium
                    : Colors.black,
                size: 17,
              ),
            ),
          ),
          leading: widget.leading,
          subtitle: widget.subTitle != null
              ? ZeraText(
                  widget.subTitle,
                  theme: ZeraTextTheme(
                    fontFamily: kMontserratFontFamily,
                    fontSize: kFontSizeXXXS,
                    fontWeight: FontWeight.w500,
                    textColor: ZeraColors.neutralDark01,
                  ),
                )
              : null,
          tilePadding: const EdgeInsets.only(left: 0),
          title: ZeraText(
            widget.title,
            theme: ZeraTextTheme(
              fontFamily: kMontserratFontFamily,
              fontSize: widget.fontSize ?? kFontsizeXXS,
              fontWeight: FontWeight.w700,
              textColor: widget.textColor ?? ZeraColors.neutralDark,
            ),
          ),
          // onExpansionChanged: (isOpen) {
          //   if (_controller.status == AnimationStatus.completed) {
          //     _controller.reverse();
          //   } else {
          //     _controller.forward();
          //   }

          //   opened = isOpen;

          //   if (opened) {
          //     setState(() {});
          //   }
          // },
          children: opened || widget.initiallyExpanded ? widget.body : [],
        ),
      );
}
