import 'package:flutter/material.dart';

import 'package:base_dependencies/dependencies.dart';

class CustomCheckBox extends StatelessWidget {
  final double? fontSizeTitle;
  final double? fontSizeSubTitle;
  final bool value;
  final String title;
  final String? subTitle;
  final ValueChanged<bool?>? onChanged;
  final bool isDisabled;
  final Widget? suffixWidget;
  const CustomCheckBox({
    Key? key,
    required this.value,
    required this.title,
    this.subTitle,
    this.fontSizeTitle,
    this.fontSizeSubTitle,
    this.onChanged,
    this.isDisabled = false,
    this.suffixWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 12.0, bottom: 12.0, left: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Theme(
              data: ThemeData(
                unselectedWidgetColor: const Color(0xFFB0B8BE),
                disabledColor: const Color(0xFFB0B8BE).withOpacity(0.25),
              ),
              child: SizedBox(
                height: 35,
                width: 35,
                child: Checkbox(
                  value: value,
                  onChanged: isDisabled ? null : onChanged,
                  activeColor: ZeraColors.primaryMedium,
                  checkColor: ZeraColors.white,
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ZeraText(
                    title,
                    type: ZeraTextType.MEDIUM_16_NEUTRAL_DARK_01,
                    color: isDisabled
                        ? const Color(0xFF373F45).withOpacity(0.25)
                        : const Color(0xFF373F45),
                    theme: const ZeraTextTheme(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      lineHeight: 1.7,
                    ),
                  ),
                  if (subTitle != null)
                    const SizedBox(
                      height: 4.0,
                    ),
                  Visibility(
                    visible: subTitle != null,
                    child: ZeraText(
                      subTitle,
                      softWrap: true,
                      type: ZeraTextType.MEDIUM_12_NEUTRAL_DARK,
                      color: isDisabled
                          ? const Color(0xFF373F45).withOpacity(0.25)
                          : const Color(0xFF373F45),
                      theme: const ZeraTextTheme(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        lineHeight: 1.6,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (suffixWidget != null) suffixWidget!,
          ],
        ),
      );
}
