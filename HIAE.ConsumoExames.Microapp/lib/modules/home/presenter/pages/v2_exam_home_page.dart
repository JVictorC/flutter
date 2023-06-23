import 'package:base_dependencies/dependencies.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/assets_constants.dart';
import '../../../../core/constants/routes.dart';
import '../../../../core/constants/strings.dart';
import '../../../../core/di/initInjector.dart';
import '../../../../core/entities/user_auth_info.dart';
import '../../../../core/exceptions/exceptions.dart';
import '../../../../core/extensions/translate_extension.dart';
import '../../../../core/utils/camera_file_picker.dart';
import '../../../../core/utils/handler_files_picker.dart';
import '../../../../core/utils/local_storage_utils.dart';
import '../../../../core/utils/snackbar_manager.dart';
import '../../../../core/widgets/responsive_app_bar.dart';
import '../../../exams/domain/entities/exam_entity.dart';
import '../../../exams/domain/entities/external_exam_entity.dart';
import '../../../exams/domain/entities/patient_target_entity.dart';
import '../../../exams/presenter/cubits/exam_cubit.dart';
import '../../../exams/presenter/widgets/error_upload_bottom_sheet.dart';
import '../../../exams/presenter/widgets/exam_upload_mobile_bottom_sheet.dart';
import '../cubits/validate_cubit.dart';
import '../cubits/validate_cubit_state.dart';
import '../widgets/v2_home_card_widget.dart';

class V2ExamHomePage extends StatefulWidget {
  const V2ExamHomePage({Key? key}) : super(key: key);

  @override
  State<V2ExamHomePage> createState() => _V2ExamHomePageState();
}

class _V2ExamHomePageState extends State<V2ExamHomePage> {
  late final ValidateCubit _cubit;

  @override
  void initState() {
    _cubit = I.getDependency<ValidateCubit>();
    _cubit.openScreen();
    super.initState();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () async {
          await SystemChannels.platform.invokeMethod<void>(
            'SystemNavigator.pop',
            true,
          );
          return false;
        },
        child: Container(
          color: Colors.white,
          child: SafeArea(
            child: BlocConsumer<ValidateCubit, ValidateState>(
              bloc: _cubit,
              listenWhen: (context, state) =>
                  state is ValidateSuccessState ||
                  state is InvalidState ||
                  state is ValidateFailureState,
              listener: (context, state) async {
                if (state is ValidateFailureState) {
                  if (state.failure is NoInternetConnectionFailure) {
                    final refresh = await Navigator.of(context).pushNamed(
                      Routes.failedConnectionPage,
                      arguments: MY_EXAMS.translate(),
                    ) as bool?;

                    if (refresh == true) {
                      await _cubit.openScreen();
                    } else {
                      Navigator.of(context, rootNavigator: true).pop();
                    }
                  } else {
                    await showDialog<bool>(
                      useSafeArea: false,
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: Text(WARNING.translate()),
                        content: Text(
                          INVALID_ACCESS.translate(),
                        ),
                        actions: [
                          TextButton(
                            child: const Text('OK'),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                    );
                    Navigator.of(context, rootNavigator: true).pop();
                  }
                } else {
                  final data = (state as ValidateSuccessState);
                  I.unregister<UserAuthInfoEntity>();
                  UserAuthInfoEntity userInfo =
                      data.user.accessType.toUpperCase().trim() == 'PATIENT'
                          ? UserAuthInfoEntity(
                              accessType: data.user.accessType,
                              id: data.user.id,
                              userType: 'Patient',
                              identifier: data.user.identifier,
                              localization: data.localization,
                              token: data.token,
                              patientTarget: null,
                            )
                          : UserAuthInfoEntity(
                              accessType: data.user.accessType,
                              id: data.user.id,
                              userType: 'Doctor',
                              identifier: data.user.identifier,
                              localization: data.localization,
                              token: data.token,
                              patientTarget: PatientTargetEntity(
                                name: data.patientName!,
                                id: data.medicalRecord!,
                              ),
                            );

                  I.registerLazySingleton<UserAuthInfoEntity>(
                    userInfo,
                  );
                  await setUserOnStorage(userInfo);

                  if (data.user.accessType.toUpperCase().trim() != 'PATIENT') {
                    Navigator.of(context)
                        .pushReplacementNamed(Routes.listExamsDoctorPage);
                  }
                }
              },
              builder: (context, state) => state is ValidateLoadingState
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : state is ValidateSuccessState
                      ? ZeraScaffold(
                          extendBodyBehindAppBar: true,
                          backgroundColor: ZeraColors.primaryMedium,
                          appBar: PreferredSize(
                            preferredSize: const Size.fromHeight(210),
                            child: Center(
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                constraints:
                                    const BoxConstraints(maxWidth: 1200),
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (kIsWeb) const SizedBox(height: 56),
                                    ResponsiveAppBar(
                                      backgroundColor: Colors.transparent,
                                      iconColor: Colors.white,
                                      rootNavigator: true,
                                      onTap: () async {
                                        await SystemChannels.platform
                                            .invokeMethod<void>(
                                          'SystemNavigator.pop',
                                          true,
                                        );
                                      },
                                      leading: InkWell(
                                        onTap: () => Navigator.of(
                                          context,
                                          rootNavigator: true,
                                        ).pop(context),
                                        child: const Icon(
                                          ZeraIcons.arrow_left_1,
                                          size: 24,
                                          color: Colors.white,
                                        ),
                                      ),
                                      bottomChild: [
                                        const SizedBox(height: 16),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                      .size
                                                      .width >
                                                  540
                                              ? null
                                              : 235,
                                          child: ZeraText(
                                            EXAM_RESULTS.translate(),
                                            maxLines: 2,
                                            theme: ZeraTextTheme(
                                              fontSize: 32,
                                              fontWeight: FontWeight.w700,
                                              textColor:
                                                  ZeraColors.neutralLight,
                                              lineHeight: 1.31,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          body: Container(
                            color: ZeraColors.primaryMedium,
                            child: Column(
                              children: [
                                Expanded(
                                  child: Stack(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.width >
                                                    540
                                                ? 460
                                                : 320,
                                        margin: EdgeInsets.only(
                                          right: MediaQuery.of(context)
                                                      .size
                                                      .width >
                                                  850
                                              ? 56
                                              : 0,
                                        ),
                                        alignment: Alignment.topCenter,
                                        decoration: const BoxDecoration(
                                          image: DecorationImage(
                                            fit: BoxFit.fitWidth,
                                            image: AssetImage(
                                              ILLUSTRATION_IMG,
                                              package: MICRO_APP_PACKAGE_NAME,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Container(
                                          margin: EdgeInsets.only(
                                            // top: MediaQuery.of(context).size.width > 540
                                            top: MediaQuery.of(context)
                                                        .size
                                                        .width >
                                                    670
                                                ? 188
                                                : 220,
                                          ),
                                          padding: const EdgeInsets.only(
                                            left: 16,
                                            right: 16,
                                            top: 47,
                                          ),
                                          height: double.infinity,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(16),
                                              topRight: Radius.circular(16),
                                            ),
                                          ),
                                          child: SingleChildScrollView(
                                            child: Center(
                                              child: Container(
                                                constraints:
                                                    const BoxConstraints(
                                                  maxWidth: 1200,
                                                ),
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      MediaQuery.of(
                                                                context,
                                                              ).size.width <
                                                              554
                                                          ? CrossAxisAlignment
                                                              .center
                                                          : CrossAxisAlignment
                                                              .start,
                                                  children: [
                                                    Container(
                                                      constraints:
                                                          const BoxConstraints(
                                                        maxWidth:
                                                            (164 * 2) + 16,
                                                      ),
                                                      width: double.infinity,
                                                      child: ZeraText(
                                                        OUR_SERVICES
                                                            .translate(),
                                                        maxLines: 2,
                                                        theme: ZeraTextTheme(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          textColor: ZeraColors
                                                              .neutralDark,
                                                          lineHeight: 1.31,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 16),
                                                    Wrap(
                                                      clipBehavior: Clip.none,
                                                      crossAxisAlignment:
                                                          WrapCrossAlignment
                                                              .center,
                                                      spacing: 15,
                                                      runSpacing: 16,
                                                      children: [
                                                        V2HomeCardWidget(
                                                          icon: Image.asset(
                                                            EXAMS_OTHERS_LABORATORIES_IMG,
                                                            package:
                                                                MICRO_APP_PACKAGE_NAME,
                                                            color: Colors.white,
                                                          ),
                                                          onTap: () {
                                                            Navigator.of(
                                                              context,
                                                            ).pushNamed(
                                                              Routes
                                                                  .listExamsPage,
                                                            );
                                                          },
                                                          text: MY_EXAMS
                                                              .translate(),
                                                        ),
                                                        // const SizedBox(width: 15),
                                                        V2HomeCardWidget(
                                                          icon: Image.asset(
                                                            GRAPH_STATS_IMG,
                                                            package:
                                                                MICRO_APP_PACKAGE_NAME,
                                                          ),
                                                          onTap: () {
                                                            final ExamCubit
                                                                cubit =
                                                                I.getDependency<
                                                                    ExamCubit>();

                                                            final bool
                                                                firstOpenEvolutionaryReport =
                                                                cubit
                                                                    .getFirstEvolutionaryRepository();

                                                            if (!firstOpenEvolutionaryReport) {
                                                              Navigator.of(
                                                                context,
                                                              ).pushNamed(
                                                                Routes
                                                                    .evolutionaryReportHome,
                                                              );
                                                            } else {
                                                              Navigator.of(
                                                                context,
                                                              ).pushNamed(
                                                                Routes
                                                                    .evolutionaryReportGroupsExams,
                                                              );
                                                            }
                                                          },
                                                          text:
                                                              EVOLUTIONARY_REPORT
                                                                  .translate(),
                                                        ),
                                                        // const SizedBox(width: 15),
                                                        V2HomeCardWidget(
                                                          text:
                                                              IMPORT_OTHER_LABS
                                                                  .translate(),
                                                          icon: Image.asset(
                                                            MOVE_UP_IMG,
                                                            package:
                                                                MICRO_APP_PACKAGE_NAME,
                                                          ),
                                                          onTap: () async {
                                                            if (await getTermsCheckedFromLocalStorage()) {
                                                              FileEntity?
                                                                  fileResult;

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
                                                                  pdfFun:
                                                                      () async {
                                                                    fileResult =
                                                                        await LibraryDocumentUtil()
                                                                            .getFile();
                                                                  },
                                                                  cameraFun:
                                                                      () async {
                                                                    fileResult =
                                                                        await CameraUtil()
                                                                            .getFile();
                                                                  },
                                                                );
                                                              }

                                                              if (fileResult !=
                                                                  null) {
                                                                fileResult =
                                                                    fileResult!
                                                                        .copyWith(
                                                                  showMyExamsStep:
                                                                      false,
                                                                );
                                                                final uploadResult =
                                                                    await Navigator
                                                                        .of(
                                                                  context,
                                                                ).pushNamed(
                                                                  Routes
                                                                      .uploadStepsPage,
                                                                  arguments:
                                                                      fileResult,
                                                                );
                                                                if (uploadResult
                                                                    is ExternalExamEntity) {
                                                                  Navigator.of(
                                                                    context,
                                                                  ).pushNamed(
                                                                    Routes
                                                                        .listExamsPage,
                                                                  );

                                                                  final ExamEntity
                                                                      examEntity =
                                                                      ExamEntity(
                                                                    fileId: uploadResult
                                                                        .fileId,
                                                                    path: uploadResult
                                                                        .path,
                                                                    examType:
                                                                        uploadResult
                                                                            .examType,
                                                                    executionDate:
                                                                        uploadResult
                                                                            .executionDate,
                                                                    executionDate2:
                                                                        uploadResult
                                                                            .executionDate,
                                                                    uploadDate:
                                                                        uploadResult
                                                                            .uploadDate,
                                                                    labName:
                                                                        uploadResult
                                                                            .labName,
                                                                    examId:
                                                                        uploadResult
                                                                            .id,
                                                                    examName:
                                                                        uploadResult
                                                                            .examName,
                                                                    laudoFile:
                                                                        uploadResult
                                                                            .path,
                                                                    url1:
                                                                        uploadResult
                                                                            .url,
                                                                    idMedicalRecords:
                                                                        uploadResult
                                                                            .medicalRecords,
                                                                    position: 0,
                                                                    passType:
                                                                        null,
                                                                    statusResult:
                                                                        0,
                                                                    available:
                                                                        true,
                                                                    security:
                                                                        true,
                                                                    laudo:
                                                                        false,
                                                                    passageId:
                                                                        null,
                                                                    examCode:
                                                                        null,
                                                                    labCode:
                                                                        null,
                                                                    doctorName:
                                                                        null,
                                                                    doctorIdentity:
                                                                        null,
                                                                    place: null,
                                                                    url2: null,
                                                                    accessNumber:
                                                                        null,
                                                                    result:
                                                                        null,
                                                                    linesQuantity:
                                                                        null,
                                                                    itemCategory:
                                                                        null,
                                                                  );

                                                                  ScaffoldMessenger
                                                                      .of(
                                                                    context,
                                                                  ).showSnackBar(
                                                                    SnackBar(
                                                                      padding:
                                                                          const EdgeInsets
                                                                              .only(
                                                                        left:
                                                                            20,
                                                                        right:
                                                                            20,
                                                                        bottom:
                                                                            10.0,
                                                                      ),
                                                                      behavior:
                                                                          SnackBarBehavior
                                                                              .fixed,
                                                                      backgroundColor:
                                                                          Colors
                                                                              .white,
                                                                      content:
                                                                          Container(
                                                                        padding:
                                                                            const EdgeInsets.only(
                                                                          left:
                                                                              16,
                                                                        ),
                                                                        color:
                                                                            const Color(
                                                                          0xFFe7f5ee,
                                                                        ),
                                                                        height:
                                                                            73,
                                                                        child:
                                                                            Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          children: [
                                                                            Row(
                                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                ZeraText(
                                                                                  EXAM_IMPORTED_SUCCESSFULLY,
                                                                                  color: const Color(
                                                                                    0xFF0e6038,
                                                                                  ),
                                                                                  theme: const ZeraTextTheme(
                                                                                    fontSize: 16.0,
                                                                                    fontWeight: FontWeight.w700,
                                                                                  ),
                                                                                ),
                                                                                IconButton(
                                                                                  splashRadius: 20,
                                                                                  padding: EdgeInsets.zero,
                                                                                  onPressed: () {
                                                                                    ScaffoldMessenger.of(
                                                                                      context,
                                                                                    ).hideCurrentSnackBar();
                                                                                  },
                                                                                  icon: const Icon(
                                                                                    Icons.close,
                                                                                    color: Color(
                                                                                      0xFF0e6038,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            GestureDetector(
                                                                              onTap: () {
                                                                                Navigator.of(
                                                                                  context,
                                                                                ).pushNamed(
                                                                                  Routes.examResultPage,
                                                                                  arguments: examEntity,
                                                                                );
                                                                              },
                                                                              child: MouseRegion(
                                                                                cursor: SystemMouseCursors.click,
                                                                                child: ZeraText(
                                                                                  SEE_EXAM.translate(),
                                                                                  color: const Color(
                                                                                    0xFF0e6038,
                                                                                  ),
                                                                                  theme: const ZeraTextTheme(
                                                                                    fontSize: 14.0,
                                                                                    fontWeight: FontWeight.w600,
                                                                                    decoration: TextDecoration.underline,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  );
                                                                }
                                                              }
                                                            } else {
                                                              bool
                                                                  _showMyExamsStep =
                                                                  false;
                                                              final uploadResult =
                                                                  await Navigator
                                                                      .of(
                                                                context,
                                                              ).pushNamed(
                                                                Routes
                                                                    .uploadExamsPage,
                                                                arguments:
                                                                    _showMyExamsStep,
                                                              );

                                                              if (uploadResult
                                                                      is bool &&
                                                                  uploadResult) {
                                                                Navigator.of(
                                                                  context,
                                                                ).pushNamed(
                                                                  Routes
                                                                      .listExamsPage,
                                                                );
                                                                SnackbarManager(
                                                                  context,
                                                                ).showSuccess(
                                                                  message:
                                                                      'Exame importado com sucesso',
                                                                );
                                                              }
                                                            }
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.topCenter,
                                        child: Container(
                                          constraints: const BoxConstraints(
                                            maxWidth: 1200,
                                          ),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0,
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                    top: MediaQuery.of(context)
                                                                .size
                                                                .width >
                                                            850
                                                        ? 115.0
                                                        : 60,
                                                  ),
                                                  child: Image.asset(
                                                    DOCTOR_IMG,
                                                    package:
                                                        MICRO_APP_PACKAGE_NAME,
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
                              ],
                            ),
                          ),
                        )
                      : Container(
                          color: Colors.white,
                        ),
            ),
          ),
        ),
      );
}
