import 'package:flutter/material.dart';

import 'package:base_dependencies/dependencies.dart';

class CardDateEvolutionaryReport extends StatelessWidget {
  final String label;
  final GestureTapCallback onTap;
  final bool isSelected;
  const CardDateEvolutionaryReport({
    required this.label,
    required this.onTap,
    required this.isSelected,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.only(left: 8, right: 8),
          height: 34.0,
          child: Center(
            child: ZeraText(
              label,
              theme: ZeraTextTheme(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                textColor:
                    isSelected ? ZeraColors.white : ZeraColors.neutralDark,
              ),
            ),
          ),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(8),
            ),
            color: isSelected ? ZeraColors.primaryMedium : ZeraColors.white,
            border: Border.all(
              width: 1,
              color: ZeraColors.neutralLight02,
              style: BorderStyle.solid,
            ),
          ),
        ),
      );
}
