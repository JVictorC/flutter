import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/routes.dart';
import '../../../../core/constants/strings.dart';
import '../../../../core/di/initInjector.dart';
import '../../../../core/entities/user_auth_info.dart';
import '../../../../core/exceptions/exceptions.dart';
import '../../../../core/extensions/translate_extension.dart';
import '../../../../core/utils/local_storage_utils.dart';
import '../../../exams/domain/entities/patient_target_entity.dart';
import '../cubits/validate_cubit.dart';
import '../cubits/validate_cubit_state.dart';

class MicroAppHomePage extends StatefulWidget {
  const MicroAppHomePage({Key? key}) : super(key: key);

  @override
  State<MicroAppHomePage> createState() => _MicroAppHomePageState();
}

class _MicroAppHomePageState extends State<MicroAppHomePage> {
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
          if (kIsWeb) {
            Navigator.pop(context);
          } else {
            final rootNavigator = await getDataLoginParams();

            if (rootNavigator['rootNavigator'] == 'S') {
              await SystemChannels.platform.invokeMethod<void>(
                'SystemNavigator.pop',
                true,
              );
            } else {
              Navigator.pop(context);
            }
          }

          return false;
        },
        child: Scaffold(
          body: SafeArea(
            child: BlocConsumer<ValidateCubit, ValidateState>(
              bloc: _cubit,
              listenWhen: (context, state) => state is ValidateSuccessState || state is InvalidState || state is ValidateFailureState,
              listener: (context, state) async {
                if (state is ValidateFailureState) {
                  if (state.failure is NoInternetConnectionFailure) {
                    final refresh = await Navigator.of(context).pushReplacementNamed(
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

                  final resultParams = await getDataLoginParams()
                    ..['rootNavigator'];

                  UserAuthInfoEntity userInfo = data.user.accessType.toUpperCase().trim() == 'PATIENT'
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
                  final route = data.user.accessType.toUpperCase().trim() == 'PATIENT' ? Routes.listExamsPage : data.route ?? Routes.listExamsDoctorPage;

                  Navigator.of(context).pushReplacementNamed(route);
                }
              },
              builder: (context, state) => const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ),
      );
}
