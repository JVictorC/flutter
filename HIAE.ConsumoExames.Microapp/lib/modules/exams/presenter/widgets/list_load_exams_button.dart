import 'package:flutter/material.dart';

import 'package:base_dependencies/dependencies.dart';

import '../../../../core/extensions/mobile_size_extension.dart';
import '../../../../core/extensions/numeric_helper_extension.dart';

class ListLoadExamsButton extends StatelessWidget {
  final String text;
  final bool enableButton;
  final Function? onPressed;
  const ListLoadExamsButton({
    required this.enableButton,
    required this.onPressed,
    required this.text,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Align(
        alignment: Alignment.bottomCenter,
        child: SizedBox(
          width: context.isMobile()
              ? MediaQuery.of(context).size.width
              : context.isTablet()
                  ? 6.wp(
                      context,
                    )
                  : 2.wp(
                      context,
                      minValue: 290,
                    ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ZeraButton(
              // enabled: enableButton,
              text: text,
              onPressed: () {
                if (onPressed != null && enableButton) {
                  onPressed!();
                }
              },
              style: enableButton
                  ? ZeraButtonStyle.SECONDARY_DARK
                  : ZeraButtonStyle.SECONDARY_DISABLE,
              theme: ZeraButtonTheme(
                borderWidth: 1,
                fontSize: 16.0,
              ),
            ),
          ),
        ),
      );
}
