import 'package:flutter/material.dart';

class BaseAppBar extends AppBar {
  final bool hasMenu;
  final void Function()? onTapBack;

  BaseAppBar({
    super.key,
    this.hasMenu = true,
    this.onTapBack,
  }) : super(
          title: Image.asset(
            "assets/images/IMG_LOGO_INICIE.png",
          ),
          centerTitle: true,
          leading: GestureDetector(
            onTap: onTapBack,
            child: SizedBox(
              child: Image.asset(
                hasMenu
                    ? "assets/images/IMG_MENU.png"
                    : "assets/images/IMG_BACK_ARROW.png",
              ),
            ),
          ),
          actions: [
            Image.asset(
              "assets/images/IMG_IMAGE_USER.png",
            ),
          ],
          backgroundColor: Colors.transparent,
          bottomOpacity: 0.0,
          elevation: 0.0,
        );
}
