import 'package:flutter/material.dart';

import 'package:base_dependencies/dependencies.dart';

class CardWithIconWidget extends StatelessWidget {
  final Widget body;
  final Widget icon;
  const CardWithIconWidget({
    Key? key,
    required this.body,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        height: 76,
        padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 19),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: ZeraColors.neutralLight02,
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 20),
            body,
          ],
        ),
      );
}
