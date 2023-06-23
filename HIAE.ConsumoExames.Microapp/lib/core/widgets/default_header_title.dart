// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:base_dependencies/dependencies.dart';

class DefaultHeaderTitle extends StatelessWidget {
  final String title;
  final num? incLeftPadding;
  final double leftPaddingHeader;

  const DefaultHeaderTitle({
    Key? key,
    required this.title,
    this.incLeftPadding,
    this.leftPaddingHeader = kIsWeb ? 72.0 : 5.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 16.0),
        height: 56.0,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(
          left: leftPaddingHeader + (incLeftPadding ?? 20),
        ),
        color: Colors.white,
        child: ZeraText(
          title,
          type: ZeraTextType.BOLD_24_NEUTRAL_DARK_BASE,
        ),
      );
}
