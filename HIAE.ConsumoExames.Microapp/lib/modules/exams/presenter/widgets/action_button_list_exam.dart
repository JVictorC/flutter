import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:base_dependencies/dependencies.dart';

import '../../../../core/constants/assets_constants.dart';
import '../../../../core/constants/strings.dart';
import '../../../../core/di/initInjector.dart';
import '../../../../core/entities/user_auth_info.dart';
import '../../../../core/extensions/translate_extension.dart';

class ActionButtonListExam extends StatelessWidget {
  final Function download;
  final Function share;
  final Function remove;
  final Function printOut;
  final Function? multipleShareExams;
  final bool visibleRemoveExternalExam;
  const ActionButtonListExam({
    required this.download,
    required this.share,
    required this.remove,
    required this.visibleRemoveExternalExam,
    required this.multipleShareExams,
    required this.printOut,
    Key? key,
  }) : super(key: key);

  Widget _menuIconButton() => SizedBox(
        width: 40,
        child: Padding(
          padding: const EdgeInsets.only(right: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 6.5,
                width: 6.25,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: ZeraColors.primaryMedium,
                    width: 1.5,
                  ),
                ),
              ),
              const SizedBox(
                height: 2.0,
              ),
              Container(
                height: 6.5,
                width: 6.25,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: ZeraColors.primaryMedium,
                    width: 1.5,
                  ),
                ),
              ),
              const SizedBox(
                height: 2.0,
              ),
              Container(
                height: 6.5,
                width: 6.25,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: ZeraColors.primaryMedium,
                    width: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _popMenuButton(BuildContext context) => PopupMenuButton(
        icon: _menuIconButton(),
        onSelected: (value) async => <String, Function>{
          'download': () async => await download(),
          'print': () async => await printOut(),
          'share': () async => await share(),
          'multiShare': () => multipleShareExams!(),
          'delete': () async => await showAlertDialog(context).then(
                (value) async {
                  if (value ?? false) {
                    await remove();
                  }
                },
              ),
        }[value]
          ?..call(),
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 'download',
            child: ListTile(
              leading: Icon(
                ZeraIcons.move_down_1,
                size: 16,
                color: ZeraColors.neutralDark,
              ),
              title: ZeraText(
                DOWNLOADS.translate(),
                color: ZeraColors.neutralDark01,
                theme: const ZeraTextTheme(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          PopupMenuItem(
            value: 'print',
            child: ListTile(
              leading: Icon(
                ZeraIcons.print_text,
                size: 16,
                color: ZeraColors.neutralDark,
              ),
              title: ZeraText(
                PRINT_OUT.translate(),
                color: ZeraColors.neutralDark01,
                theme: const ZeraTextTheme(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          // PopupMenuItem(
          //   value: 'share',
          //   child: ListTile(
          //     leading: Icon(
          //       ZeraIcons.share_1,
          //       size: 16,
          //       color: ZeraColors.neutralDark,
          //     ),
          //     title: ZeraText(
          //       SHARE.translate(),
          //       color: ZeraColors.neutralDark02,
          //       theme: const ZeraTextTheme(
          //         fontSize: 16,
          //         fontWeight: FontWeight.w400,
          //       ),
          //     ),
          //   ),
          // ),
          PopupMenuItem(
            value: 'multiShare',
            child: ListTile(
              leading: Icon(
                Icons.copy_rounded,
                size: 16,
                color: ZeraColors.neutralDark,
              ),
              title: ZeraText(
                SELECT_MULTIPLES_EXAMS.translate(),
                color: ZeraColors.neutralDark01,
                theme: const ZeraTextTheme(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              subtitle: ZeraText(
                EXAM_DOWNLOAD_PRINT_AND_SHARE.translate(),
                color: ZeraColors.neutralDark02,
                theme: const ZeraTextTheme(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          if (visibleRemoveExternalExam &&
              I.getDependency<UserAuthInfoEntity>().userType == 'Patient')
            PopupMenuItem(
              value: 'delete',
              child: ListTile(
                leading: Image.asset(
                  TRASH_ICON,
                  width: 14,
                  height: 14,
                  color: ZeraColors.criticalColorMedium,
                  package: MICRO_APP_PACKAGE_NAME,
                ),
                title: ZeraText(
                  DELETE.translate(),
                  color: ZeraColors.neutralDark02,
                  theme: const ZeraTextTheme(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
        ],
      );

  Widget _menuDevice(BuildContext context) => InkWell(
        child: _menuIconButton(),
        onTap: () {
          Navigator.of(context).push<void>(
            ZeraBottomSheet<void>(
              color: Colors.white,
              child: Column(
                children: [
                  //Download
                  GestureDetector(
                    onTap: () async {
                      await download();
                      Navigator.of(context).pop();
                    },
                    child: ListTile(
                      leading: Icon(
                        ZeraIcons.move_down_1,
                        size: 16,
                        color: ZeraColors.neutralDark,
                      ),
                      title: ZeraText(
                        DOWNLOADS.translate(),
                        color: ZeraColors.neutralDark01,
                        theme: const ZeraTextTheme(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  ZeraDivider(),
                  //Print
                  GestureDetector(
                    onTap: () async {
                      await printOut();
                      Navigator.of(context).pop();
                    },
                    child: ListTile(
                      leading: Icon(
                        ZeraIcons.print_text,
                        size: 16,
                        color: ZeraColors.neutralDark,
                      ),
                      title: ZeraText(
                        PRINT_OUT.translate(),
                        color: ZeraColors.neutralDark01,
                        theme: const ZeraTextTheme(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  ZeraDivider(),

                  //Share
                  GestureDetector(
                    onTap: () async {
                      await share();
                      Navigator.of(context).pop();
                    },
                    child: ListTile(
                      leading: Icon(
                        ZeraIcons.share_1,
                        size: 16,
                        color: ZeraColors.neutralDark,
                      ),
                      title: ZeraText(
                        SHARE.translate(),
                        color: ZeraColors.neutralDark02,
                        theme: const ZeraTextTheme(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  ZeraDivider(),
                  //SELECT MULTIPLES EXAMS
                  GestureDetector(
                    onTap: () {
                      multipleShareExams!();
                      Navigator.of(context).pop();
                    },
                    child: ListTile(
                      leading: Icon(
                        Icons.copy_rounded,
                        size: 16,
                        color: ZeraColors.neutralDark,
                      ),
                      title: ZeraText(
                        SELECT_MULTIPLES_EXAMS.translate(),
                        color: ZeraColors.neutralDark01,
                        theme: const ZeraTextTheme(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      subtitle: ZeraText(
                        EXAM_DOWNLOAD_PRINT_AND_SHARE.translate(),
                        color: ZeraColors.neutralDark02,
                        theme: const ZeraTextTheme(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),

                  //Delete
                  Visibility(
                    visible: visibleRemoveExternalExam &&
                        I.getDependency<UserAuthInfoEntity>().userType ==
                            'Patient',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ZeraDivider(),
                        GestureDetector(
                          onTap: () async {
                            final value = await showAlertDialog(context);

                            if (value ?? false) {
                              await remove();
                            }
                          },
                          child: ListTile(
                            leading: Image.asset(
                              TRASH_ICON,
                              width: 14,
                              height: 14,
                              color: ZeraColors.criticalColorMedium,
                              package: MICRO_APP_PACKAGE_NAME,
                            ),
                            title: ZeraText(
                              DELETE.translate(),
                              color: ZeraColors.neutralDark02,
                              theme: const ZeraTextTheme(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
              tittle: ZeraText(
                WHAT_DO_YOU_WANT_TO_DO.translate(),
                type: ZeraTextType.BOLD_MEDIUM_16_DARK_01,
              ),
            ),
          );
        },
      );

  Future<bool?> showAlertDialog(BuildContext context) async =>
      await showDialog<bool>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text(WARNING.translate()),
          content: Text(
            ARE_YOU_SURE_YOU_WANT_TO_DELETE.translate(),
          ),
          actions: [
            TextButton(
              child: Text(NO.translate()),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: Text(YES.translate()),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) =>
      kIsWeb ? _popMenuButton(context) : _menuDevice(context);
}
