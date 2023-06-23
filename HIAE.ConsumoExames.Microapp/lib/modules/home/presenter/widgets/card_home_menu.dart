import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:base_dependencies/dependencies.dart';

import '../../../../core/constants/assets_constants.dart';

class CardHomeMenu extends StatelessWidget {
  final String img;
  final String title;
  final GestureTapCallback action;
  final double leftPaddingHeader = kIsWeb ? 56.0 : 5.0;
  CardHomeMenu({
    Key? key,
    required this.title,
    required this.img,
    required this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.only(
          left: leftPaddingHeader,
          right: leftPaddingHeader,
          bottom: 20.0,
        ),
        child: InkWell(
          onTap: action,
          child: ZeraCard(
            shape: RoundedRectangleBorder(
              side: BorderSide(color: ZeraColors.neutralLight03, width: 1.0),
              borderRadius: const BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            shadowColor: ZeraColors.neutralLight,
            color: ZeraColors.neutralLight,
            style: ZeraCardStyle.VARIANT,
            elevation: 0.0,
            child: Center(
              child: ListTile(
                leading: SizedBox(
                  height: 32,
                  width: 32,
                  child: Image.asset(
                    img,
                    package: MICRO_APP_PACKAGE_NAME,
                  ),
                ),
                trailing: Icon(
                  ZeraIcons.arrow_right_1,
                  color: ZeraColors.neutralDark02,
                  size: 16.0,
                ),
                title: ZeraText(
                  title,
                  type: ZeraTextType.SEMI_BOLD_14_DARK_BASE,
                ),
              ),
            ),
            //childPadding: const EdgeInsets.only(left: 0.0, top: 23.0),
            height: 80.0,
            width: MediaQuery.of(context).size.width - 30,
          ),
        ),
      );
}
