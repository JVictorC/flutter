// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:base_dependencies/dependencies.dart';

class HeaderExpansionTile extends StatefulWidget {
  final String title;
  final List<Widget> body;
  final bool showIconTrailing;
  final bool subTitleTop;
  final bool initiallyExpanded;
  final String? subTitle;
  final Widget? leading;
  final double? fontSize;
  final Color? textColor;
  final Color? collapsedBackgroundColor;
  final Color? backgroundColor;
  final bool? maintainState;
  final GlobalKey? globalKey;

  const HeaderExpansionTile({
    Key? key,
    this.leading,
    required this.title,
    this.subTitle,
    required this.body,
    this.initiallyExpanded = false,
    this.fontSize,
    this.textColor,
    this.collapsedBackgroundColor,
    this.backgroundColor,
    this.maintainState,
    this.globalKey,
    this.showIconTrailing = false,
    this.subTitleTop = false,
  }) : super(key: key);

  @override
  State<HeaderExpansionTile> createState() => _HeaderExpansionTileState();
}

class _HeaderExpansionTileState extends State<HeaderExpansionTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late bool opened;

  @override
  void initState() {
    opened = widget.initiallyExpanded;
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
          key: widget.globalKey,
          maintainState: widget.maintainState ?? false,
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
              ? widget.subTitleTop
                  ? Padding(
                      padding: const EdgeInsets.only(
                        top: 8,
                        bottom: 20,
                      ),
                      child: ZeraText(
                        widget.title,
                        theme: ZeraTextTheme(
                          fontFamily: kMontserratFontFamily,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          textColor: ZeraColors.neutralDark,
                        ),
                      ),
                    )
                  : ZeraText(
                      widget.subTitle,
                      theme: ZeraTextTheme(
                        fontFamily: kMontserratFontFamily,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        textColor: ZeraColors.neutralDark01,
                      ),
                    )
              : null,
          tilePadding: kIsWeb
              ? const EdgeInsets.only(
                  left: 0,
                )
              : null,
          title: widget.subTitleTop
              ? ZeraText(
                  widget.subTitle,
                  theme: ZeraTextTheme(
                    fontFamily: kMontserratFontFamily,
                    fontSize: widget.fontSize ?? 12,
                    fontWeight: FontWeight.w400,
                    textColor: widget.textColor ?? ZeraColors.neutralDark02,
                  ),
                )
              : ZeraText(
                  widget.title,
                  theme: ZeraTextTheme(
                    fontFamily: kMontserratFontFamily,
                    fontSize: widget.fontSize ?? 14,
                    fontWeight: FontWeight.w700,
                    textColor: widget.textColor ?? ZeraColors.neutralDark,
                  ),
                ),
          onExpansionChanged: (isOpen) {
            if (_controller.status == AnimationStatus.completed) {
              _controller.reverse();
            } else {
              _controller.forward();
            }

            opened = isOpen;

            if (opened) {
              setState(() {});
            }
          },
          children: opened || widget.initiallyExpanded ? widget.body : [],
        ),
      );
}
