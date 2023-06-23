import 'package:flutter/material.dart';

import 'package:base_dependencies/dependencies.dart';

class ButtonFooterWidget extends StatelessWidget {
  ButtonFooterWidget({
    Key? key,
    required this.text,
    required this.textColor,
    required this.buttonType,
    this.onTap,
  }) : super(key: key);
  final String text;
  final Color textColor;
  final ButtonType buttonType;
  void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    switch (buttonType) {
      case ButtonType.iconLeft:
        return InkWell(
          onTap: onTap,
          child: Row(
            children: [
              Icon(
                ZeraIcons.arrow_left_1,
                color: textColor,
                size: 16,
              ),
              const SizedBox(width: 8),
              ZeraText(
                text,
                color: textColor,
                type: ZeraTextType.SEMIBOLD_TIGHT_12_DARK_01,
                theme: const ZeraTextTheme(
                    fontSize: 12, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        );
      case ButtonType.iconRight:
        return InkWell(
          onTap: onTap,
          child: Row(
            children: [
              ZeraText(
                text,
                color: textColor,
                type: ZeraTextType.SEMIBOLD_TIGHT_12_DARK_01,
                theme: const ZeraTextTheme(
                    fontSize: 12, fontWeight: FontWeight.w700),
              ),
              const SizedBox(width: 8),
              Icon(
                ZeraIcons.arrow_right_1,
                color: textColor,
                size: 16,
              ),
            ],
          ),
        );
    }
  }
}

enum ButtonType {
  iconLeft,
  iconRight,
}
