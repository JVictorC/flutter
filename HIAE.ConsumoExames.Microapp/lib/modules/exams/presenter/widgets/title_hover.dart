import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:base_dependencies/dependencies.dart';

// ignore: must_be_immutable
class TitleHover extends StatefulWidget {
  final String title;
  final GestureTapCallback onTap;
  const TitleHover({required this.onTap, required this.title, Key? key})
      : super(key: key);

  @override
  State<TitleHover> createState() => _TitleHoverState();
}

class _TitleHoverState extends State<TitleHover> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: widget.onTap,
        child: MouseRegion(
          onEnter: (event) => setState(() {
            isHovered = true;
          }),
          onExit: (event) => setState(() {
            isHovered = false;
          }),
          cursor: SystemMouseCursors.click,
          child: Container(
            padding: const EdgeInsets.only(
              top: 10,
              left: 16,
              bottom: 10, // context.isDevice() ? 30 : 25,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: ZeraText(
                widget.title,
                theme: ZeraTextTheme(
                  fontSize: !isHovered ? 12 : 13.8,
                  textColor: !isHovered ? Colors.black : ZeraColors.primaryDark,
                ),
              ),
            ),
          ),

          /*ListTile(
            title: ZeraText(
              widget.title,
              theme: ZeraTextTheme(
                fontSize: !isHovered ? 12 : 13.8,
                textColor: !isHovered ? Colors.black : ZeraColors.primaryDark,
              ),
            ),
          ),*/
        ),
      );
}
