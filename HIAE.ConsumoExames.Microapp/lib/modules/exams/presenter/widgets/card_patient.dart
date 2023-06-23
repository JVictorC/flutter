import 'package:flutter/material.dart';

import 'package:base_dependencies/dependencies.dart';

import '../../../../core/constants/assets_constants.dart';
import '../../../../core/di/initInjector.dart';
import '../../../../core/entities/user_auth_info.dart';

class CardPatient extends StatelessWidget {
  final String? patientId;
  final String? name;

  final double? paddingTop;
  final GestureTapCallback? onTap;

  const CardPatient({
    this.name,
    this.patientId,
    this.onTap,
    this.paddingTop,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Visibility(
          visible: I.getDependency<UserAuthInfoEntity>().userType == 'Doctor',
          child: GestureDetector(
            onTap: onTap ?? () => Navigator.of(context).pop(),
            child: Padding(
              padding: EdgeInsets.only(top: paddingTop ?? 0),
              child: Card(
                elevation: 5,
                shadowColor: ZeraColors.neutralLight03,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  leading: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Image.asset(
                      MEDICAL_CONDITIONS,
                      alignment: Alignment.center,
                      height: 30,
                      fit: BoxFit.fill,
                      package: MICRO_APP_PACKAGE_NAME,
                    ),
                  ),
                  title: ZeraText(
                    name ??
                        I
                            .getDependency<UserAuthInfoEntity>()
                            .patientTarget
                            ?.name ??
                        '',
                    color: ZeraColors.neutralDark01,
                    theme: const ZeraTextTheme(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  subtitle: ZeraText(
                    patientId ??
                        I
                            .getDependency<UserAuthInfoEntity>()
                            .patientTarget
                            ?.id ??
                        '',
                    color: ZeraColors.neutralDark02,
                    theme: const ZeraTextTheme(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: Icon(
                    ZeraIcons.arrow_right_1,
                    color: ZeraColors.primaryMedium,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
