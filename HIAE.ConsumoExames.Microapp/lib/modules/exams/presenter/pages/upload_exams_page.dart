import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:base_dependencies/dependencies.dart';

import '../../../../core/constants/assets_constants.dart';
import '../../../../core/constants/parameters_constants.dart';
import '../../../../core/constants/routes.dart';
import '../../../../core/constants/strings.dart';
import '../../../../core/extensions/translate_extension.dart';
import '../../../../core/utils/camera_file_picker.dart';
import '../../../../core/utils/handler_files_picker.dart';
import '../../../../core/utils/local_storage_utils.dart';
import '../../../../core/widgets/bread_crumbs.dart';
import '../../../../core/widgets/responsive_app_bar.dart';
import '../widgets/check_radio_widget.dart';
import '../widgets/error_upload_bottom_sheet.dart';
import '../widgets/exam_upload_mobile_bottom_sheet.dart';

class UploadExamsPage extends StatefulWidget {
  const UploadExamsPage({Key? key}) : super(key: key);

  @override
  State<UploadExamsPage> createState() => _UploadExamsPageState();
}

class _UploadExamsPageState extends State<UploadExamsPage> {
  final _isPrivacyChecked = ValueNotifier<bool>(false);
  bool _showMyExamsStep = true;
  bool _loadedData = false;
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (!_loadedData) {
      _showMyExamsStep = ModalRoute.of(context)?.settings.arguments != false;
      _loadedData = true;
    }
  }

  @override
  Widget build(BuildContext context) => ZeraScaffold(
        body: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverFillRemaining(
                hasScrollBody:
                    MediaQuery.of(context).size.height > 700 ? true : false,
                fillOverscroll:
                    MediaQuery.of(context).size.height > 700 ? true : false,
                child: Center(
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: 1200,
                      maxHeight: MediaQuery.of(context).size.height > 700
                          ? MediaQuery.of(context).size.height
                          : 700,
                    ),
                    width: double.infinity,
                    height: double.infinity,
                    padding: const EdgeInsets.only(
                      bottom: 24,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          constraints: const BoxConstraints(maxWidth: 1200),
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: ResponsiveAppBar(
                            breadCrumbs: kIsWeb
                                ? BreadCrumbs(
                                    listBreadCrumbs: _showMyExamsStep
                                        ? [
                                            EXAM_RESULTS.translate(),
                                            EXAMS_EINSTEIN.translate(),
                                            IMPORT_EXAMS.translate(),
                                          ]
                                        : [
                                            EXAM_RESULTS.translate(),
                                            IMPORT_EXAMS.translate(),
                                          ],
                                  )
                                : null,
                            iconColor: ZeraColors.primaryMedium,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.only(
                                  left: 16,
                                  right: 16,
                                ),
                                child: ZeraText(
                                  IMPORT_EXAMS_OTHERS_LABS.translate(),
                                  type: ZeraTextType.MEDIUM_20_NEUTRAL_DARK,
                                  theme: const ZeraTextTheme(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20.0,
                                    fontStyle: FontStyle.normal,
                                    fontFamily: 'Montserrat',
                                    lineHeight: 1.5,
                                  ),
                                ),
                              ),
                              Column(
                                children: [
                                  Image.asset(
                                    UPLOAD_DOCUMENT_1_IMG,
                                    package: MICRO_APP_PACKAGE_NAME,
                                  ),
                                  const SizedBox(height: 40),
                                  Container(
                                    constraints: const BoxConstraints(
                                      maxWidth: 320,
                                    ),
                                    child: ZeraText(
                                      NOW_EINSTEIN_HELPS_ORGANIZE.translate(),
                                      color: ZeraColors.neutralDark01,
                                      textAlign: TextAlign.center,
                                      theme: const ZeraTextTheme(
                                        fontSize: 16,
                                        lineHeight: 1.5,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    constraints: const BoxConstraints(
                                      maxWidth: 343,
                                    ),
                                    child: ZeraText(
                                      EASILY_ACCESS_SHARE_ALL_EXAMS_APP
                                          .translate(),
                                      textAlign: TextAlign.center,
                                      color: ZeraColors.neutralDark01,
                                      theme: const ZeraTextTheme(
                                        fontSize: 14,
                                        lineHeight: 1.5,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              AnimatedBuilder(
                                animation: _isPrivacyChecked,
                                builder: (context, child) => Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      height: 1,
                                      child: OverflowBox(
                                        maxWidth:
                                            MediaQuery.of(context).size.width,
                                        minHeight: 1,
                                        child: ZeraDivider(),
                                      ),
                                    ),
                                    const SizedBox(height: 18),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.width >
                                                  570
                                              ? 56
                                              : 80,
                                      width: MediaQuery.of(context).size.width,
                                      child: OverflowBox(
                                        maxWidth:
                                            MediaQuery.of(context).size.width,
                                        maxHeight:
                                            MediaQuery.of(context).size.width >
                                                    570
                                                ? 56
                                                : 80,
                                        alignment: Alignment.center,
                                        child: Container(
                                          alignment: Alignment.center,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 24,
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              CheckRadioWidget(
                                                marin: const EdgeInsets.only(
                                                  right: 10,
                                                  // top: 5,
                                                ),
                                                targetValue: true,
                                                value: _isPrivacyChecked.value,
                                                onTap: () {
                                                  _isPrivacyChecked.value =
                                                      !_isPrivacyChecked.value;
                                                },
                                              ),
                                              Flexible(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.of(context)
                                                        .pushNamed(
                                                      Routes.uploadTermsPage,
                                                      arguments:
                                                          _showMyExamsStep,
                                                    );
                                                  },
                                                  child: RichText(
                                                    text: TextSpan(
                                                      text:
                                                          '${AFFIRM_YOU_HAVE_READ.translate()} ',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: ZeraColors
                                                            .neutralDark01,
                                                        fontFamily:
                                                            fontFamilyName,
                                                        height: MediaQuery.of(
                                                                  context,
                                                                ).size.width >
                                                                570
                                                            ? 1.5
                                                            : 1.333,
                                                      ),
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                          text:
                                                              '${TERMS_USE.translate()} ',
                                                          style: TextStyle(
                                                            color: ZeraColors
                                                                .primaryMedium,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            decoration:
                                                                TextDecoration
                                                                    .underline,
                                                          ),
                                                        ),
                                                        TextSpan(
                                                          text:
                                                              FROM_HOSPITAL_ALBERT_EINSTEIN
                                                                  .translate(),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 18),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      height: 1,
                                      child: OverflowBox(
                                        maxWidth:
                                            MediaQuery.of(context).size.width,
                                        minHeight: 1,
                                        child: ZeraDivider(),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Container(
                                      constraints: const BoxConstraints(
                                        maxWidth: 458,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                      ),
                                      child: ZeraButton(
                                        onPressed: !_isPrivacyChecked.value
                                            ? null
                                            : () async {
                                                FileEntity? fileResult;
                                                setTermsCheckedOnStorage(true);
                                                if (kIsWeb) {
                                                  try {
                                                    fileResult =
                                                        await LibraryDocumentUtil()
                                                            .getFile();
                                                  } on FileSizeException catch (err) {
                                                    return erroUploadBottomSheet(
                                                      context,
                                                      err.error,
                                                    );
                                                  } on FileExtensionException catch (err) {
                                                    return erroUploadBottomSheet(
                                                      context,
                                                      err.error,
                                                    );
                                                  }
                                                } else {
                                                  await getMobileBottomPicker(
                                                    pdfFun: () async {
                                                      fileResult =
                                                          await LibraryDocumentUtil()
                                                              .getFile();
                                                    },
                                                    cameraFun: () async {
                                                      fileResult =
                                                          await CameraUtil()
                                                              .getFile();
                                                    },
                                                  );
                                                }
                                                if (fileResult != null) {
                                                  fileResult =
                                                      fileResult!.copyWith(
                                                    showMyExamsStep:
                                                        _showMyExamsStep,
                                                  );
                                                  final uploadResult =
                                                      await Navigator.of(
                                                    context,
                                                  ).pushNamed(
                                                    Routes.uploadStepsPage,
                                                    arguments: fileResult,
                                                  );

                                                  Navigator.of(context)
                                                      .pop(uploadResult);
                                                }
                                              },
                                        text: START.translate(),
                                        style: _isPrivacyChecked.value
                                            ? ZeraButtonStyle.PRIMARY_DARK
                                            : ZeraButtonStyle.PRIMARY_DISABLE,
                                        theme: ZeraButtonTheme(fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
      );
}
