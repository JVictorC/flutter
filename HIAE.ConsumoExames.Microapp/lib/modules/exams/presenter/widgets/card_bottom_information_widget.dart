import 'package:flutter/material.dart';

import 'package:base_dependencies/dependencies.dart';

import '../../../../core/constants/assets_constants.dart';

class CardBottomInformationWidget extends StatelessWidget {
  final String description;
  final void Function()? onTap;
  const CardBottomInformationWidget({
    Key? key,
    required this.description,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Flexible(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Ink(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              top: 24,
              bottom: 24,
            ),
            decoration: BoxDecoration(
              color: ZeraColors.neutralLight,
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 4,
                  color: Color.fromRGBO(27, 28, 29, 0.15),
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: ZeraColors.neutralDark02,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Image.asset(
                    COMMON_FILE_TEXT_IMG,
                    package: MICRO_APP_PACKAGE_NAME,
                    color: ZeraColors.neutralLight,
                  ),
                ),
                const SizedBox(width: 16),
                Flexible(
                  child: ZeraText(
                    description,
                    color: ZeraColors.neutralDark,
                    theme: const ZeraTextTheme(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      lineHeight: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
