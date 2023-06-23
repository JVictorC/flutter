import 'package:flutter/material.dart';

import 'package:base_dependencies/dependencies.dart';

class PeriodButtonWidget extends StatelessWidget {
  final String title;
  final void Function()? onPressed;
  final bool isSelected;
  const PeriodButtonWidget({
    Key? key,
    required this.title,
    this.onPressed,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(right: 8),
        child: TextButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              isSelected ? ZeraColors.primaryMedium : null,
            ),
            padding: MaterialStateProperty.all(const EdgeInsets.all(8)),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                  color: isSelected
                      ? ZeraColors.primaryMedium
                      : ZeraColors.neutralLight02,
                  width: 1,
                ),
              ),
            ),
          ),
          onPressed: onPressed,
          child: ZeraText(
            title,
            theme: ZeraTextTheme(
              fontSize: kFontsizeXXS,
              fontWeight: FontWeight.w700,
              textColor: isSelected
                  ? ZeraColors.neutralLight
                  : ZeraColors.neutralDark01,
            ),
          ),
        ),
      );
}
