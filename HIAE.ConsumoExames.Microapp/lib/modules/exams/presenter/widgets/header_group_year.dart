import 'package:flutter/material.dart';

import 'package:base_dependencies/dependencies.dart';

import '../../../../core/extensions/mobile_size_extension.dart';

class HeaderGroupYear extends StatelessWidget {
  final int? year;
  final bool enableBorder;
  const HeaderGroupYear({
    required this.enableBorder,
    required this.year,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.only(
          top: 40,
        ),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color:
                  enableBorder ? ZeraColors.neutralLight03 : Colors.transparent,
            ),
          ),
        ),
        height: 84,
        child: Padding(
          padding: EdgeInsets.only(
            left: context.isDevice() ? 16.5 : 0,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.calendar_today_outlined,
                color: ZeraColors.neutralDark,
                size: 16,
              ),
              const SizedBox(
                width: 16.5,
              ),
              ZeraText(
                year.toString(),
                color: ZeraColors.neutralDark,
                theme: const ZeraTextTheme(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      );
}
