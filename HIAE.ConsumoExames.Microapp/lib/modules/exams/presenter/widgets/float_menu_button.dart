import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:base_dependencies/dependencies.dart';

import '../../../../core/constants/strings.dart';
import '../../../../core/extensions/translate_extension.dart';

class FloatMenuBUtton extends StatelessWidget {
  final GestureTapCallback download;
  final GestureTapCallback share;
  final GestureTapCallback printOut;
  const FloatMenuBUtton({
    required this.download,
    required this.share,
    required this.printOut,
    key,
  }) : super(key: key);

  Widget _circularButton({
    required String title,
    required IconData icon,
    required GestureTapCallback action,
    bool enableRadiusLeft = false,
    bool enableRadiusRight = false,
  }) =>
      kIsWeb
          ? ElevatedButton.icon(
              icon: Icon(
                icon,
              ),
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(
                        enableRadiusRight ? 4.0 : 0,
                      ),
                      bottomRight: Radius.circular(
                        enableRadiusRight ? 4.0 : 0.0,
                      ),
                      topLeft: Radius.circular(
                        enableRadiusLeft ? 4.0 : 0.0,
                      ),
                      bottomLeft: Radius.circular(
                        enableRadiusLeft ? 4.0 : 0.0,
                      ),
                    ),
                  ),
                ),
                alignment: Alignment.center,
                minimumSize: MaterialStateProperty.all<Size>(
                  const Size(
                    130,
                    56,
                  ),
                ),
                backgroundColor: MaterialStateProperty.all(
                  ZeraColors.neutralDark.withOpacity(0.85),
                ),
              ),
              onPressed: action,
              label: ZeraText(
                title,
                color: ZeraColors.white,
                theme: const ZeraTextTheme(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            )
          : InkWell(
              onTap: action,
              child: Column(
                children: [
                  Container(
                    height: 66,
                    width: 66,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: ZeraColors.neutralLight03,
                      ),
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(100),
                      ),
                    ),
                    child: Icon(
                      icon,
                      color: ZeraColors.neutralDark,
                      size: 25,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  ZeraText(
                    title,
                    color: ZeraColors.neutralDark01,
                    theme: const ZeraTextTheme(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            );

  Widget _menuButtonForDevice() => Container(
        height: 145,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 10,
              offset: const Offset(3, 5),
            ),
          ],
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 16,
                bottom: 22,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: ZeraColors.neutralLight02,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(16),
                  ),
                ),
                height: 5,
                width: 80,
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _circularButton(
                  title: DOWNLOADS.translate(),
                  icon: ZeraIcons.move_down_1,
                  action: download,
                ),
                _circularButton(
                  title: PRINT_OUT.translate(),
                  icon: ZeraIcons.print_text,
                  action: printOut,
                ),
                _circularButton(
                  title: SHARE.translate(),
                  icon: ZeraIcons.share_1,
                  action: share,
                ),
              ],
            ),
          ],
        ),
      );

  Widget _menuButtonForWeb() => Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _circularButton(
              title: DOWNLOADS.translate(),
              icon: ZeraIcons.move_down_1,
              action: download,
              enableRadiusLeft: true,
              enableRadiusRight: false,
            ),
            _circularButton(
              title: PRINT_OUT.translate(),
              icon: ZeraIcons.print_text,
              action: printOut,
              enableRadiusLeft: false,
              enableRadiusRight: false,
            ),
            // _circularButton(
            //   title: SHARE.translate(),
            //   icon: ZeraIcons.share_1,
            //   action: download,
            //   enableRadiusLeft: false,
            //   enableRadiusRight: true,
            // ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) =>
      kIsWeb ? _menuButtonForWeb() : _menuButtonForDevice();
  // _menuButtonForDevice();
}
