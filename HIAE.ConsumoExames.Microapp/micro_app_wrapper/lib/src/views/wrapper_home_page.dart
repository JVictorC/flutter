import 'package:base_dependencies/dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:micro_app_consumo_exame/core/utils/primitive_wrapper.dart';
import 'package:micro_app_consumo_exame/core/utils/show_loading_dialog.dart';
import 'package:micro_app_consumo_exame/micro_app_exam_consumption.dart';

import '../cubit/authentication_cubit.dart';
import '../cubit/authentication_state.dart';
import '../entities/user_token.dart';
import '../utils/alert_dialog.dart';
import '../widgets/expansion_title_base.dart';
import '../widgets/expansion_title_default.dart';
import '../widgets/radio_button_i18n.dart';

class WrapperHomePage extends StatefulWidget {
  const WrapperHomePage({Key? key}) : super(key: key);

  @override
  State<WrapperHomePage> createState() => _WrapperHomePageState();
}

class _WrapperHomePageState extends State<WrapperHomePage> {
  final TextEditingController _controllerDoctor = TextEditingController();
  final TextEditingController _controllerPatient = TextEditingController();
  final TextEditingController _controllerTokenPatient = TextEditingController();
  final TextEditingController _controllerTokenDoctor = TextEditingController();
  final TextEditingController _controllerPatientDoctor =
      TextEditingController();
  final TextEditingController _controllerNamePatientDoctor =
      TextEditingController();
  final AuthenticationCubit _cubit = AuthenticationCubit();
  final PrimitiveWrapper<String> selectedScreen = PrimitiveWrapper<String>();
  bool initialExpandedDoctor = false;
  bool initialExpandedPatient = false;
  int val = 1;
  String selectedLanguage = 'pt_BR';
  bool actionDoctor = false;

  @override
  void initState() {
    _controllerPatient.text = '2231869';
    _controllerPatientDoctor.text = '2231869';
    _controllerNamePatientDoctor.text = 'JoãoZinho da silva';
    _controllerDoctor.text = 'CRM999123';

    // _controllerPatient.text = '4004657';

    super.initState();
  }

  @override
  void dispose() {
    _cubit.close();
    _controllerPatientDoctor.dispose();
    _controllerNamePatientDoctor.dispose();
    _controllerDoctor.dispose();
    _controllerPatient.dispose();
    _controllerTokenPatient.dispose();
    _controllerTokenDoctor.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () async => Future.value(false),
        child: Material(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: ZeraText(
                    'AppBase',
                    type: ZeraTextType.BOLD_24_DARK_BASE,
                    color: ZeraColors.primaryDark,
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                BlocConsumer<AuthenticationCubit, AuthenticationState>(
                  bloc: _cubit,
                  listenWhen: (context, state) =>
                      state is! AuthenticationInitialState &&
                      state is! AuthenticationLoadState &&
                      state is! AuthenticationLoadTokenState,
                  listener: (context, state) async {
                    if (state is AuthenticationValidateTokenState) {
                      if (initialExpandedDoctor) {
                        _controllerTokenDoctor.text = state.token;
                        _controllerTokenPatient.clear();
                      } else {
                        _controllerTokenPatient.text = state.token;
                        _controllerTokenDoctor.clear();
                      }
                    } else if (state is AuthenticationSuccessState) {
                      if (actionDoctor) {
                        if (_controllerDoctor.text.trim().isNotEmpty) {
                          if (_controllerTokenDoctor.text.trim().isEmpty) {
                            await showAlertDialog(
                              context: context,
                              msg: 'Informe um token',
                            );
                          } else {
                            final Map<String, String> data = {
                              'transactionId': state.id,
                              'localization': selectedLanguage,
                              'token': initialExpandedDoctor
                                  ? _controllerTokenDoctor.text
                                  : _controllerTokenPatient.text,
                              'route': selectedScreen.value!,
                              'patientName':
                                  _controllerNamePatientDoctor.text.trim(),
                              'medicalRecord':
                                  _controllerPatientDoctor.text.trim(),
                              'rootNavigator': 'N',
                            };
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                settings: RouteSettings(
                                  arguments: data,
                                ),
                                builder: (BuildContext context) =>
                                    const MicroExamConsumptionPage(),
                              ),
                            );
                          }
                        }
                      } else if (_controllerPatient.text.isNotEmpty) {
                        if (_controllerTokenPatient.text.trim().isEmpty) {
                          await showAlertDialog(
                            context: context,
                            msg: 'Informe um token',
                          );
                        } else {
                          final Map<String, String> data = {
                            'rootNavigator': 'N',
                            'transactionId': state.id,
                            'localization': selectedLanguage,
                            'token': initialExpandedDoctor
                                ? _controllerTokenDoctor.text
                                : _controllerTokenPatient.text,
                          };

                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              settings: RouteSettings(
                                arguments: data,
                              ),
                              builder: (BuildContext context) =>
                                  const MicroExamConsumptionPage(),
                            ),
                          );
                        }
                      }
                    } else if (state is AuthenticationFailureState) {
                      await showAlertDialog(
                        context: context,
                        msg: state.failure.message,
                      );
                    }
                  },
                  builder: (context, state) => state is AuthenticationLoadState
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : Padding(
                          padding:
                              const EdgeInsets.only(left: 30.0, right: 30.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ExpansionTitleDefault(
                                title: 'Localization',
                                body: Wrap(
                                  spacing: 10,
                                  runSpacing: 10,
                                  direction: Axis.horizontal,
                                  alignment: WrapAlignment.start,
                                  children: [
                                    RadioButtonI18n(
                                      flag: 'flagbrasil',
                                      text: 'pt_BR',
                                      value: 'pt_BR',
                                      groupValue: selectedLanguage,
                                      onTap: (value) {
                                        setState(() {
                                          selectedLanguage = value!;
                                        });
                                      },
                                    ),
                                    RadioButtonI18n(
                                      flag: 'flagespanha',
                                      value: 'es_ES',
                                      text: 'es_ES',
                                      groupValue: selectedLanguage,
                                      onTap: (value) {
                                        setState(() {
                                          selectedLanguage = value!;
                                        });
                                      },
                                    ),
                                    RadioButtonI18n(
                                      flag: 'flageua',
                                      value: 'en_US',
                                      text: 'en_US',
                                      groupValue: selectedLanguage,
                                      onTap: (value) {
                                        setState(() {
                                          selectedLanguage = value!;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              ExpansionTitleBase(
                                selectedScreen: selectedScreen,
                                initialExpanded: initialExpandedDoctor,
                                controllerNamePatientDoctor:
                                    _controllerNamePatientDoctor,
                                controllerPatientDoctor:
                                    _controllerPatientDoctor,
                                onTapToken: ({
                                  required String user,
                                  required String password,
                                }) async {
                                  initialExpandedDoctor = true;
                                  initialExpandedPatient = false;

                                  await showLoadingDialog(
                                    context: context,
                                    action: () async {
                                      await _cubit.validateToken(
                                        userToken: UserToken(
                                          clientId:
                                              typeLogin.HIAIEinsteinMedico,
                                          user: user,
                                          password: password,
                                        ),
                                      );
                                    },
                                  );
                                },
                                title: 'Médico',
                                label: 'CRM',
                                controller: _controllerDoctor,
                                controllerToken: _controllerTokenDoctor,
                                enableButton: true,
                                actionButton: () async {
                                  actionDoctor = true;
                                  await _cubit.authentication(
                                    accessType: 'Doctor',
                                    identifier: _controllerDoctor.text.trim(),
                                  );
                                },
                              ),
                              ExpansionTitleBase(
                                selectedScreen: selectedScreen,
                                controllerNamePatientDoctor:
                                    _controllerNamePatientDoctor,
                                controllerPatientDoctor:
                                    _controllerPatientDoctor,
                                initialExpanded: initialExpandedPatient,
                                onTapToken: ({
                                  required String user,
                                  required String password,
                                }) async {
                                  initialExpandedDoctor = false;
                                  initialExpandedPatient = true;

                                  await showLoadingDialog(
                                    context: context,
                                    action: () async {
                                      final userLoad = UserToken(
                                        clientId: typeLogin.password_v4,
                                        user: user,
                                        password: password,
                                      );

                                      await _cubit.validateToken(
                                        userToken: userLoad,
                                      );
                                    },
                                  );
                                },
                                title: 'Paciente',
                                label: 'Prontuário',
                                controller: _controllerPatient,
                                controllerToken: _controllerTokenPatient,
                                enableButton:
                                    true, //_controllerPatient.text.isNotEmpty,
                                actionButton: () async {
                                  actionDoctor = false;
                                  await _cubit.authentication(
                                    accessType: 'Patient',
                                    identifier: _controllerPatient.text.trim(),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      );
}
