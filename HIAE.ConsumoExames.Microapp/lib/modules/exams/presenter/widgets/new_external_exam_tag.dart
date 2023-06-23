import 'package:flutter/material.dart';

import 'package:base_dependencies/dependencies.dart';

import '../../../../core/constants/strings.dart';
import '../../../../core/extensions/translate_extension.dart';

class NewExamExternalExamTag extends StatelessWidget {
  const NewExamExternalExamTag({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        width: 56,
        height: 20,
        decoration: BoxDecoration(
          color: ZeraColors.primaryLightest,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: ZeraText(
            '${NEW.translate()}!',
            color: ZeraColors.primaryDarkest,
            theme: const ZeraTextTheme(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
}
