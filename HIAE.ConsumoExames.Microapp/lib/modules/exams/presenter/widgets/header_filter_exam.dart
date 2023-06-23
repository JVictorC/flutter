import 'package:flutter/material.dart';

import 'package:base_dependencies/dependencies.dart';

import '../../../../core/extensions/mobile_size_extension.dart';

class HeaderFilterExam extends StatelessWidget {
  final String title;

  const HeaderFilterExam({required this.title, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Visibility(
            visible: context.isDevice(),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Container(
                  width: 100,
                  height: 5,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(16),
                    ),
                    color: ZeraColors.neutralLight02,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 28,
          ),
          Center(
            child: ZeraText(
              title,
              theme: ZeraTextTheme(
                fontSize: 16,
                textColor: ZeraColors.neutralDark,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ZeraDivider(),
        ],
      );
}
