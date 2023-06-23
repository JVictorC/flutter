// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:base_dependencies/dependencies.dart';

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? trailing;
  final IconData? iconAppBar;
  final double leftPaddingHeader;
  final bool rootNavigator;
  final String? title;
  final bool? centerTitle;
  final double bottomHeight;
  final Widget? bottomChild;
  final Color backgroundColor;
  final Color? iconColor;
  final bool hasMaxWidth;
  final Widget? leading;
  final Function? actionButton;

  const DefaultAppBar({
    Key? key,
    this.trailing,
    this.iconAppBar,
    this.leading,
    this.leftPaddingHeader = kIsWeb ? 72.0 : 5.0,
    this.rootNavigator = false,
    this.title,
    this.centerTitle,
    this.bottomHeight = 0,
    this.bottomChild,
    this.backgroundColor = Colors.white,
    this.iconColor,
    this.hasMaxWidth = false,
    this.actionButton,
  }) : super(key: key);

  @override
  Size get preferredSize => kIsWeb
      ? Size.fromHeight(kNavBarHeightWeb + bottomHeight - 50)
      : Size.fromHeight(kNavBarHeight + bottomHeight);

  @override
  Widget build(BuildContext context) => Container(
        //width: MediaQuery.of(context).size.width,
        color: backgroundColor,
        padding: EdgeInsets.only(left: leftPaddingHeader),
        child: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          title: title != null
              ? ZeraText(
                  title,
                  type: ZeraTextType.BOLD_20_NEUTRAL_DARK_BASE,
                )
              : null,
          centerTitle: centerTitle ?? false,
          backgroundColor: backgroundColor,
          actions: <Widget>[
            trailing ?? Container(),
          ],
          leading: leading ??
              ZeraIconButton(
                onPressed: actionButton ??
                    () => Navigator.of(
                          context,
                          rootNavigator: rootNavigator,
                        ).pop(context),
                icon: iconAppBar ?? ZeraIcons.arrow_left_1,
                iconColor: iconColor,
                style: ZeraIconButtonStyle.ICON_CLOSE,
              ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(bottomHeight),
            child: bottomChild ?? const SizedBox.shrink(),
          ),
        ),
      );
}
