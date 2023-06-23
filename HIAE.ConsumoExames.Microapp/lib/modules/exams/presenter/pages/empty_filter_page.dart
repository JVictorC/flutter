import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:base_dependencies/dependencies.dart';

import '../../../../core/constants/assets_constants.dart';
import '../../../../core/constants/strings.dart';
import '../../../../core/extensions/mobile_size_extension.dart';
import '../../../../core/extensions/translate_extension.dart';

class EmptyFilterPage extends StatelessWidget {
  const EmptyFilterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ZeraScaffold(
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Padding(
                padding: const EdgeInsets.only(left: 21.31, right: 21.31),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 16.75, bottom: 16.75),
                      child: InkWell(
                        onTap: () => Navigator.of(context).pop(),
                        child: Icon(
                          ZeraIcons.arrow_left_1,
                          color: ZeraColors.primaryMedium,
                        ),
                      ),
                    ),
                    ZeraText(
                      MY_EXAMS.translate(),
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
                          children: [
                            Image.asset(
                              EMPTY_PAGE,
                              package: MICRO_APP_PACKAGE_NAME,
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            SizedBox(
                              child: ZeraText(
                                EMPTY_PAGE_MSG.translate(),
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
                              width: 340,
                              child: ZeraText(
                                RETRY_AGAIN_SEARCH.translate(),
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
                    Padding(
                      padding: EdgeInsets.only(
                        left: context.isMobile() ? 0 : 400,
                        right: context.isMobile() ? 0 : 400,
                        bottom: 42.0,
                      ),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: ZeraButton(
                          text: COME_BACK.translate(),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
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
