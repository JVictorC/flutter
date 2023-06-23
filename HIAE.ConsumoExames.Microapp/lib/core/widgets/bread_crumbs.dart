import 'package:flutter/material.dart';

import 'package:base_dependencies/dependencies.dart';

import '../navigator/navigator_observer.dart';

class BreadCrumbs extends StatelessWidget {
  final List<String> listBreadCrumbs;
  const BreadCrumbs({
    Key? key,
    required this.listBreadCrumbs,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) => SizedBox(
        height: 30.0,
        child: ListView.separated(
          separatorBuilder: (context, index) => Padding(
            padding: const EdgeInsets.only(left: 5.0, right: 5.0),
            child: ZeraText(
              '/',
              theme: ZeraTextTheme(
                fontSize: 12.0,
                fontWeight: FontWeight.w600,
                textColor: ZeraColors.neutralDark04,
                // textColor: ZeraColors.neutralDark03WithOpacity02,
              ),
            ),
          ),
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: listBreadCrumbs.length,
          itemBuilder: (BuildContext context, int index) => InkWell(
            splashColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: listBreadCrumbs.length - 1 == index
                ? null
                : () {
                    final String routName = routeStack[routeStack.length -
                                listBreadCrumbs.length +
                                index]
                            .settings
                            .name ??
                        '';

                    Navigator.of(context).popUntil(
                      ModalRoute.withName(routName),
                    );
                  },
            child: ZeraText(
              listBreadCrumbs[index],
              theme: ZeraTextTheme(
                fontSize: 12.0,
                fontWeight: FontWeight.w600,
                textColor: index == listBreadCrumbs.length - 1
                    ? ZeraColors.primaryMedium
                    : ZeraColors.neutralDark04,
              ),
            ),
          ),
        ),
      );
}
