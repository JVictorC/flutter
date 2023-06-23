import 'package:flutter/material.dart';

import 'package:base_dependencies/dependencies.dart';

class ButtonFilter extends StatefulWidget {
  final String title;
  final bool selectedCard;
  final GestureTapCallback? action;

  const ButtonFilter({
    required this.title,
    required this.action,
    this.selectedCard = false,
    Key? key,
  }) : super(key: key);

  @override
  State<ButtonFilter> createState() => _ButtonFilterState();
}

class _ButtonFilterState extends State<ButtonFilter> {
  @override
  Widget build(BuildContext context) => InkWell(
        onTap: widget.action,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: widget.selectedCard
                  ? ZeraColors.primaryMedium
                  : Colors.transparent,
              border: Border.all(
                color: ZeraColors.neutralLight03,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            height: 32,
            child: Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ZeraText(
                    widget.title,
                    color: widget.selectedCard
                        ? Colors.white
                        : ZeraColors.neutralDark01,
                    theme: const ZeraTextTheme(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(
                    width: 8.25,
                  ),
                  Icon(
                    Icons.keyboard_arrow_down_outlined,
                    size: 12,
                    color: widget.selectedCard
                        ? Colors.white
                        : ZeraColors.neutralDark01,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
