import 'package:flutter/material.dart';

import 'package:base_dependencies/dependencies.dart';

class CircleIcon extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final double? height;
  final double? width;
  const CircleIcon({
    Key? key,
    required this.icon,
    this.iconColor,
    this.height,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: ZeraColors.neutralLight03, width: 2),
        ),
        height: height ?? 40.0,
        width: width ?? 40.0,
        child: Center(
          child: ZeraIcon(
            icon,
            iconColor: iconColor ?? ZeraColors.primaryDark,
            iconSize: 15,
          ),
        ),
      );
}
