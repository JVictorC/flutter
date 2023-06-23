import 'package:flutter/material.dart';

import 'package:base_dependencies/dependencies.dart';

import '../constants/assets_constants.dart';
import '../constants/strings.dart';
import '../extensions/mobile_size_extension.dart';
import '../extensions/translate_extension.dart';

class FailedPage extends StatelessWidget {
  const FailedPage({Key? key}) : super(key: key);

  double getPadding(BuildContext context) {
    double value;
    if (context.isMobile()) {
      value = 16;
    } else {
      final widthScreen = MediaQuery.of(context).size.width;
      double digitCalc = widthScreen <= 800
          ? 4
          : widthScreen >= 1800
              ? 2.6
              : 3.0;

      value = MediaQuery.of(context).size.width / digitCalc;

      if (value <= 50) {
        value = 200;
      }
    }

    return value;
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as String;

    return ZeraScaffold(
      bottomNavigationBar: GestureDetector(
        onTap: () => Navigator.pop(context, false),
        child: Padding(
          padding: EdgeInsets.only(
            left: getPadding(context),
            right: getPadding(context),
            bottom: 30,
          ),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Container(
              decoration: BoxDecoration(
                color: ZeraColors.primaryDark,
                borderRadius: BorderRadius.circular(
                  286,
                ),
              ),
              alignment: Alignment.center,
              height: 52,
              child: ZeraText(
                COME_BACK.translate(),
                color: ZeraColors.white,
                theme: const ZeraTextTheme(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Padding(
              padding: const EdgeInsets.only(left: 21.31, right: 21.31),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16.75, bottom: 16.75),
                    child: InkWell(
                      onTap: () => Navigator.pop(context, true),
                      child: Icon(
                        ZeraIcons.arrow_left_1,
                        color: ZeraColors.primaryMedium,
                      ),
                    ),
                  ),
                  ZeraText(
                    args,
                    color: ZeraColors.neutralDark,
                    theme: const ZeraTextTheme(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Image.asset(
                            ERROR_PAGE,
                            package: MICRO_APP_PACKAGE_NAME,
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          SizedBox(
                            child: ZeraText(
                              SORRY_SOMETHING_WENT_WRONG.translate(),
                              color: ZeraColors.neutralDark01,
                              theme: const ZeraTextTheme(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          SizedBox(
                            width: 368,
                            child: ZeraText(
                              INTERNAL_ERROR_MESSAGE.translate(),
                              color: ZeraColors.neutralDark01,
                              theme: const ZeraTextTheme(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
