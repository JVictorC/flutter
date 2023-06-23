// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';

import 'package:base_dependencies/dependencies.dart';

import '../constants/assets_constants.dart';

class MedicalCardDetailsWidget extends StatelessWidget {
  final String title;
  final String description;
  final void Function()? onTap;
  const MedicalCardDetailsWidget({
    Key? key,
    required this.title,
    required this.description,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        child: Container(
          height: 68,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: ZeraColors.neutralLight,
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                offset: Offset(0, 4),
                blurRadius: 8,
                color: Color.fromRGBO(27, 28, 29, 0.15),
              ),
            ],
          ),
          child: Row(
            children: [
              Image.asset(
                MEDICAL_CONDITION_IMG,
                package: MICRO_APP_PACKAGE_NAME,
                height: 24,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ZeraText(
                      title,
                      color: ZeraColors.neutralDark01,
                      theme: const ZeraTextTheme(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    ZeraText(
                      description,
                      color: ZeraColors.neutralDark02,
                      theme: const ZeraTextTheme(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Icon(
                ZeraIcons.arrow_right_1,
                size: 16,
                color: ZeraColors.primaryMedium,
              ),
            ],
          ),
        ),
      );
}
