import 'package:flutter/material.dart';

import 'package:base_dependencies/dependencies.dart';

import '../../../../core/constants/assets_constants.dart';

class RadiologyInformationWidget extends StatelessWidget {
  final String? title;
  final String? description;
  final bool hasInformation;
  const RadiologyInformationWidget({
    Key? key,
    this.title,
    this.description,
    this.hasInformation = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          top: 24,
          bottom: 24,
        ),
        width: double.infinity,
        decoration: BoxDecoration(
          color: hasInformation
              ? ZeraColors.neutralLight
              : ZeraColors.neutralLight01,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: hasInformation
                ? ZeraColors.neutralLight02
                : ZeraColors.neutralLight03,
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: hasInformation
                    ? ZeraColors.primaryDark
                    : ZeraColors.neutralDark02,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Image.asset(
                hasInformation ? RADIOLOGY_SCAN : FOLDER_EMPTY_IMG,
                package: MICRO_APP_PACKAGE_NAME,
              ),
            ),
            const SizedBox(width: 16),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (hasInformation)
                    ZeraText(
                      title,
                      color: ZeraColors.neutralDark,
                      theme: const ZeraTextTheme(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        lineHeight: 1.5,
                      ),
                    ),
                  if (hasInformation) const SizedBox(height: 8),
                  ZeraText(
                    hasInformation
                        ? description
                        : 'Não existem informações a serem exibidas.',
                    color: ZeraColors.neutralDark,
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
      );
}
