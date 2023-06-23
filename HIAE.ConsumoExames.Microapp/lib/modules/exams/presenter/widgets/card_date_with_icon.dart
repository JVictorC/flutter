import 'package:flutter/material.dart';

import 'package:base_dependencies/dependencies.dart';

class CardDateWithIcon extends StatefulWidget {
  final GestureTapCallback onTapCloseButton;
  final bool isSelected;
  final String yearLabel;
  final String monthLabel;
  const CardDateWithIcon({
    required this.isSelected,
    required this.yearLabel,
    required this.monthLabel,
    required this.onTapCloseButton,
    Key? key,
  }) : super(key: key);

  @override
  State<CardDateWithIcon> createState() => _CardDateWithIconState();
}

class _CardDateWithIconState extends State<CardDateWithIcon> {
  Widget _columnDetails() => MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(8.0),
            ),
            color:
                widget.isSelected ? ZeraColors.primaryMedium : ZeraColors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ZeraText(
                widget.yearLabel.toString(),
                theme: ZeraTextTheme(
                  fontSize: 12.0,
                  textColor: widget.isSelected
                      ? ZeraColors.neutralLight
                      : ZeraColors.neutralDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 3.0,
              ),
              ZeraText(
                widget.monthLabel,
                theme: ZeraTextTheme(
                  fontSize: 14.0,
                  textColor: widget.isSelected
                      ? ZeraColors.neutralLight
                      : ZeraColors.neutralDark,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(right: 8),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: ZeraColors.neutralLight02,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(8.0),
            ),
            color:
                widget.isSelected ? ZeraColors.primaryMedium : ZeraColors.white,
          ),
          height: 72,
          width: 72,
          child: Center(
            child: _columnDetails(),
          ),
        ),
      );
}
