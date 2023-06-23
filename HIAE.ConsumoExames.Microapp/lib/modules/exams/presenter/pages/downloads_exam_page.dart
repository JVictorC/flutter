import 'package:flutter/material.dart';

import 'package:base_dependencies/dependencies.dart';

import '../../../../core/constants/assets_constants.dart';
import '../../../../core/constants/strings.dart';

class DownloadsExamPage extends StatefulWidget {
  const DownloadsExamPage({Key? key}) : super(key: key);

  @override
  State<DownloadsExamPage> createState() => _DownloadsExamPageState();
}

class _DownloadsExamPageState extends State<DownloadsExamPage> {
  @override
  Widget build(BuildContext context) => SafeArea(
        child: WillPopScope(
          onWillPop: () async => await Future<bool>.value(false),
          child: Material(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () =>
                            Navigator.of(context, rootNavigator: false).pop(),
                        icon: Icon(
                          ZeraIcons.close,
                          color: ZeraColors.primaryMedium,
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      ZeraText(
                        PREPARED_FILE_PDF,
                        type: ZeraTextType.BOLD_24_DARK_BASE,
                        color: ZeraColors.primaryDark,
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      ZeraText(
                        KEEP_THE_APP_OPEN,
                        type: ZeraTextType.MEDIUM_16_NEUTRAL_DARK_01,
                        color: ZeraColors.primaryDark,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Image.asset(
                    DOWNLOADS_PAGE,
                    package: MICRO_APP_PACKAGE_NAME,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
