import 'package:flutter/material.dart';

import 'package:base_dependencies/dependencies.dart';

class SubHeaderTitle extends StatelessWidget {
  final String title;
  const SubHeaderTitle({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ZeraText(
        title,
        type: ZeraTextType.SEMI_BOLD_16_NEUTRAL_DARK_01,
        theme: const ZeraTextTheme(
          fontSize: 16,
        ),
      );
}
