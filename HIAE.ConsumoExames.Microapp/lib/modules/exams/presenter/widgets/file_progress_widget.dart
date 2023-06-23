// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';

import 'package:base_dependencies/dependencies.dart';

import '../../../../core/constants/assets_constants.dart';
import '../../../../core/utils/handler_files_picker.dart';
import '../../../../core/utils/step_upload_file_provider.dart';

class FileProgressWidget extends StatefulWidget {
  const FileProgressWidget({
    Key? key,
    required this.fileEntity,
    required this.service,
  }) : super(key: key);

  final FileEntity fileEntity;
  final StepUploadFileProvider service;

  @override
  State<FileProgressWidget> createState() => _FileProgressWidgetState();
}

class _FileProgressWidgetState extends State<FileProgressWidget> {
  double _progress = 0.0;
  @override
  void initState() {
    super.initState();
    widget.service.addListener(updateUserDetails);
  }

  void updateUserDetails() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _progress = (widget.service.sent ?? 0) / (widget.service.total ?? 100);

    return Container(
      height: 75,
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          width: 1,
          color: ZeraColors.neutralLight02,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          // ICONE
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              color: ZeraColors.neutralLight01,
            ),
            alignment: Alignment.center,
            child: Image.asset(
              COMMON_FILE_TEXT_IMG,
              package: MICRO_APP_PACKAGE_NAME,
            ),
          ),
          const SizedBox(width: 10),
          // name file and progress bar
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Flexible(
                            child: ZeraText(
                              widget.fileEntity.fileName?.replaceAll(
                                widget.fileEntity.fileName?.split('.').last ??
                                    '',
                                '',
                              ),
                              color: ZeraColors.neutralDark01,
                              textWidthBasis: TextWidthBasis.longestLine,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              theme: const ZeraTextTheme(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                fontFamily: 'Montserrat',
                                lineHeight: 1.5,
                              ),
                            ),
                          ),
                          ZeraText(
                            (widget.fileEntity.fileName?.split('.').last ?? ''),
                            color: ZeraColors.neutralDark01,
                            textWidthBasis: TextWidthBasis.longestLine,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            theme: const ZeraTextTheme(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              fontFamily: 'Montserrat',
                              lineHeight: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ZeraText(
                      '${(_progress * 100).toInt()}%',
                      color: ZeraColors.neutralDark01,
                      theme: const ZeraTextTheme(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        fontFamily: 'Montserrat',
                        lineHeight: 1.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LayoutBuilder(
                  builder: (context, constraints) {
                    constraints.maxWidth;
                    return Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        Container(
                          height: 8,
                          width: constraints.maxWidth,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: ZeraColors.neutralLight03,
                          ),
                        ),
                        Container(
                          height: 8,
                          width: constraints.maxWidth * _progress,
                          // width: constraints.maxWidth * 0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: _progress == 1
                                ? ZeraColors.successColorMedium
                                : ZeraColors.primaryMedium,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            height: 24,
            width: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              // borderRadius: BorderRadius.circular(24),
              color: _progress == 1
                  ? ZeraColors.successColorMedium
                  : ZeraColors.informationColorLightest,
            ),
            child: _progress == 1
                ? Image.asset(
                    CHECK_1_IMG,
                    package: MICRO_APP_PACKAGE_NAME,
                  )
                : Image.asset(
                    XMARK_IMG,
                    package: MICRO_APP_PACKAGE_NAME,
                  ),
            // : Icon(
            //     ZeraIcons.close,
            //     color: ZeraColors.primaryDark,
            //     size: 24,
            //   ),
          ),
        ],
      ),
    );
  }
}
