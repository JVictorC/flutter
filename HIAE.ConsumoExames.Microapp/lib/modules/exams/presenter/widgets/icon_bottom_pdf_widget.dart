// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';

import '../../../../core/constants/assets_constants.dart';

class IconBottomPdfWidget extends StatelessWidget {
  final String path;
  final void Function()? onTap;
  const IconBottomPdfWidget({
    Key? key,
    required this.path,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        child: Image.asset(
          path,
          package: MICRO_APP_PACKAGE_NAME,
        ),
      );
}
