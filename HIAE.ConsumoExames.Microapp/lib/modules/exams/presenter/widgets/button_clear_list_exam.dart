import 'package:flutter/material.dart';

import 'package:base_dependencies/dependencies.dart';

import '../../../../core/constants/strings.dart';
import '../../../../core/extensions/mobile_size_extension.dart';
import '../../../../core/extensions/numeric_helper_extension.dart';
import '../../../../core/extensions/translate_extension.dart';

class ButtonClearListExam extends StatelessWidget {
  final Function? onPressed;
  const ButtonClearListExam({required this.onPressed, Key? key})
      : super(key: key);

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
              text: COME_BACK.translate(),
              onPressed: onPressed,
            ),
          ),
        ),
      );
}
