import 'package:flutter/material.dart';

import 'package:base_dependencies/dependencies.dart';

class ResponsiveAppBar extends StatelessWidget {
  final List<Widget> trailing;
  final IconData? iconAppBar;
  final bool rootNavigator;
  final String? title;
  final bool? centerTitle;
  final List<Widget>? bottomChild;
  final Color backgroundColor;
  final Color? iconColor;
  final bool hasMaxWidth;
  final Widget? leading;
  final Widget? breadCrumbs;
  final GestureTapCallback? onTap;

  const ResponsiveAppBar({
    Key? key,
    this.trailing = const <Widget>[],
    this.iconAppBar,
    this.rootNavigator = false,
    this.title,
    this.centerTitle,
    this.bottomChild = const <Widget>[],
    this.backgroundColor = Colors.white,
    this.iconColor,
    this.hasMaxWidth = false,
    this.leading,
    this.breadCrumbs,
    this.onTap,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    List<Widget> breadCrumbsWidget = breadCrumbs != null
        ? [
            const SizedBox(height: 16),
            breadCrumbs!,
          ]
        : [];

    return Container(
      color: backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...breadCrumbsWidget,
          SizedBox(height: (breadCrumbs == null) ? 14 : 6),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: onTap ??
                    () => Navigator.of(
                          context,
                          rootNavigator: rootNavigator,
                        ).pop(context),
                child: Icon(
                  iconAppBar ?? ZeraIcons.arrow_left_1,
                  size: 24,
                  color: iconColor ?? ZeraColors.primaryMedium,
                ),
              ),
              Row(
                children: trailing,
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...?bottomChild,
        ],
      ),
    );
  }
}
