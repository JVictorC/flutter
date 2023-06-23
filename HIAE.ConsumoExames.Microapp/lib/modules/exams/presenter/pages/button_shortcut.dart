import 'package:flutter/material.dart';

import 'package:base_dependencies/dependencies.dart';

class ButtonShortCut extends StatelessWidget {
  final String title;
  final Widget icon;
  final GestureTapCallback action;
  const ButtonShortCut({
    required this.title,
    required this.icon,
    required this.action,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: action,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
              //set border radius more than 50% of height and width to make circle
            ),
            elevation: 8,
            shadowColor: ZeraColors.neutralDark,
            child: SizedBox(
              height: 100,
              width: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(
                    height: 12,
                  ),
                  SizedBox(
                    height: 36,
                    width: 36,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: icon,
                    ),
                  ),
                  Flexible(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: ZeraText(
                          title,
                          textAlign: TextAlign.center,
                          color: ZeraColors.neutralDark,
                          theme: const ZeraTextTheme(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
