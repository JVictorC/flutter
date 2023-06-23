import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:base_dependencies/dependencies.dart';

import '../../modules/exams/presenter/widgets/new_external_exam_tag.dart';
import '../constants/assets_constants.dart';
import '../constants/parameters_constants.dart';
import '../constants/strings.dart';
import '../extensions/mobile_size_extension.dart';
import '../extensions/translate_extension.dart';

class CardDetailExam extends StatelessWidget {
  final String title;
  final String localExam;
  final String imgIcon;
  final List<Widget> body;
  final Color colorCard;
  final GestureTapCallback? onTap;
  final double? paddingLeftBody;
  final Widget? actionIcon;
  final int? statusResult;
  final bool? visibleTargetNew;
  final bool checkedCard;
  const CardDetailExam({
    Key? key,
    required this.title,
    required this.localExam,
    required this.body,
    required this.onTap,
    required this.imgIcon,
    required this.colorCard,
    this.statusResult,
    this.actionIcon,
    this.paddingLeftBody,
    this.checkedCard = false,
    this.visibleTargetNew = false,
  }) : super(key: key);

  double _getPadding(BuildContext context) {
    double value = 0;
    if (kIsWeb) {
      value = visibleTargetNew ?? false ? 222 : 180;
    } else if (context.isMobile()) {
      value = visibleTargetNew ?? false ? 180 : 150;
    } else {
      value = visibleTargetNew ?? false ? 222 : 184;
    }

    return value;
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: ZeraCard(
          color: checkedCard ? ZeraColors.neutralLight01 : ZeraColors.white,
          margin: const EdgeInsets.all(0),
          padding: EdgeInsets.only(
            bottom: 15.0,
            left: context.isDevice() ? 13.0 : 0,
            right: context.isDevice() ? 13.0 : 0,
          ),
          elevation: 3.0,
          child: LayoutBuilder(
            builder: (context, constraint) => IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IntrinsicWidth(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 16.0,
                            bottom: 5.0,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 10,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Container(
                                    color: colorCard,
                                    height: 40,
                                    width: 40,
                                    child: FittedBox(
                                      fit: BoxFit.none,
                                      child: Image.asset(
                                        imgIcon,
                                        width: 20,
                                        height: 20,
                                        package: MICRO_APP_PACKAGE_NAME,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 5,
                                  top: 8,
                                  bottom: 8,
                                ),
                                child: SizedBox(
                                  width: constraint.minWidth -
                                      _getPadding(context),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 16.0,
                                      top: 15.0,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              10,
                                          child: ZeraText(
                                            localExam,
                                            softWrap: true,
                                            type: ZeraTextType
                                                .SEMIBOLD_TIGHT_12_DARK_01,
                                            theme: ZeraTextTheme(
                                              textAlign: TextAlign.start,
                                              fontSize: 12.0,
                                              fontFamily: fontFamilyName,
                                              fontWeight: FontWeight.w500,
                                              textColor:
                                                  ZeraColors.neutralDark02,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 7.0,
                                        ),
                                        SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: ZeraText(
                                            title,
                                            softWrap: true,
                                            type: ZeraTextType
                                                .SEMIBOLD_TIGHT_12_DARK_01,
                                            theme: const ZeraTextTheme(
                                              textAlign: TextAlign.start,
                                              fontSize: 14.0,
                                              fontFamily: fontFamilyName,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 7.0,
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              (context.isMobile() ? 165 : 212),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              ...body,
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: statusResult == 2,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 16.0,
                              right: 10.0,
                              bottom: 15.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Divider(
                                  color: ZeraColors.neutralLight03,
                                  thickness: 1,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      ZeraIcons.alert_circle,
                                      size: 16.0,
                                      color: ZeraColors.criticalColorDark,
                                    ),
                                    const SizedBox(
                                      width: 10.0,
                                    ),
                                    ZeraText(
                                      OUT_OF_REFERENCE_VALUE.translate(),
                                      theme: const ZeraTextTheme(
                                        fontSize: 12.0,
                                      ),
                                      type: ZeraTextType.BOLD_12_CRITICAL_DARK,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: statusResult == 1,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 16.0,
                              right: 10.0,
                              bottom: 15.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Divider(
                                  color: ZeraColors.neutralLight03,
                                  thickness: 1,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 10,
                                    bottom: 20.0,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        ZeraIcons.check_circle_1,
                                        size: 16.0,
                                        color: ZeraColors.successColorDarkest,
                                      ),
                                      const SizedBox(
                                        width: 10.0,
                                      ),
                                      ZeraText(
                                        WITHIN_THE_REFERENCE_VALUE.translate(),
                                        theme: const ZeraTextTheme(
                                          fontSize: 12.0,
                                        ),
                                        type: ZeraTextType.BOLD_12_SUCCESS_DARK,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: actionIcon != null,
                    child: Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Visibility(
                            visible: visibleTargetNew ?? false,
                            child: const Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  top: 16,
                                ),
                                child: NewExamExternalExamTag(),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 15.0,
                              bottom: 15.0,
                              left: 0,
                            ),
                            child: VerticalDivider(
                              color: ZeraColors.neutralLight03,
                              thickness: 1,
                            ),
                          ),
                          actionIcon ?? Container(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
