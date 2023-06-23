import 'package:flutter/material.dart';

import 'package:base_dependencies/dependencies.dart';

class TextSubTitle extends StatelessWidget {
  final String title;

  const TextSubTitle({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ZeraText(
        title,
        type: ZeraTextType.BOLD_24_NEUTRAL_DARK_BASE,
        theme: const ZeraTextTheme(
          fontSize: 32,
        ),
      );
}
