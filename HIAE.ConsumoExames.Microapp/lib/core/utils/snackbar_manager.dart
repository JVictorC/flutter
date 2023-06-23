import 'package:flutter/material.dart';

import 'package:base_dependencies/dependencies.dart';

class SnackbarManager {
  final BuildContext context;

  SnackbarManager(this.context);

  _show({required SnackBar snackBar}) {
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  showError({required String message}) {
    var snackBar = SnackBar(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10.0),
      behavior: SnackBarBehavior.fixed,
      backgroundColor: Colors.white,
      content: Container(
        color: const Color(0xFFE42525),
        padding: const EdgeInsets.only(left: 15),
        height: 52,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ZeraText(
              message,
              color: const Color(0xFF0e6038),
              theme: const ZeraTextTheme(
                fontSize: 16.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            IconButton(
              splashRadius: 20,
              padding: EdgeInsets.zero,
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
              icon: const Icon(
                Icons.close,
                color: Color(0xFF0e6038),
              ),
            ),
          ],
        ),
      ),
    );

    _show(snackBar: snackBar);
  }

  showSuccess({required String message}) {
    var snackBar = SnackBar(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10.0),
      behavior: SnackBarBehavior.fixed,
      backgroundColor: Colors.white,
      content: Expanded(
        child: Container(
          padding: const EdgeInsets.only(left: 16),
          color: const Color(0xFFe7f5ee),
          height: 52,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: ZeraText(
                  message,
                  color: const Color(0xFF0e6038),
                  theme: const ZeraTextTheme(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              IconButton(
                splashRadius: 20,
                padding: EdgeInsets.zero,
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
                icon: const Icon(
                  Icons.close,
                  color: Color(0xFF0e6038),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    _show(snackBar: snackBar);
  }
}
