// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';

import 'package:base_dependencies/dependencies.dart';

import 'check_radio_widget.dart';

class ListTileCheckWidget extends StatelessWidget {
  final String title;
  final String? subTitle;
  final dynamic value;
  final dynamic targetValue;
  final void Function()? onTap;
  const ListTileCheckWidget({
    Key? key,
    required this.title,
    this.subTitle,
    required this.value,
    required this.targetValue,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => InkWell(
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              CheckRadioWidget(
                targetValue: targetValue,
                value: value,
                onTap: onTap,
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ZeraText(
                      title,
                      type: ZeraTextType.REGULAR_MEDIUM_16_DARK_01,
                      maxLines: null,
                      theme: const ZeraTextTheme(
                        lineHeight: 1,
                      ),
                    ),
                    if (subTitle != null) const SizedBox(height: 4),
                    if (subTitle != null)
                      ZeraText(
                        subTitle,
                        color: ZeraColors.neutralDark01,
                        maxLines: null,
                        theme: const ZeraTextTheme(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          lineHeight: 1.5,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
