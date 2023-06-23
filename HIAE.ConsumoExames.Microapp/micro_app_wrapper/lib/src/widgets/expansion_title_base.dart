import 'package:base_dependencies/dependencies.dart';
import 'package:flutter/material.dart';
import 'package:micro_app_consumo_exame/core/constants/routes.dart';
import 'package:micro_app_consumo_exame/core/utils/primitive_wrapper.dart';

class ExpansionTitleBase extends StatefulWidget {
  final String title;
  final String label;
  final bool? enableButton;
  final Function? actionButton;
  final TextEditingController controller;
  final TextEditingController controllerToken;
  final TextEditingController controllerPatientDoctor;
  final TextEditingController controllerNamePatientDoctor;
  final Function({required String user, required String password}) onTapToken;
  final bool initialExpanded;
  final PrimitiveWrapper<String> selectedScreen;
  const ExpansionTitleBase({
    Key? key,
    required this.title,
    required this.label,
    required this.controller,
    required this.controllerToken,
    required this.onTapToken,
    required this.initialExpanded,
    required this.controllerPatientDoctor,
    required this.controllerNamePatientDoctor,
    required this.enableButton,
    required this.selectedScreen,
    this.actionButton,
  }) : super(key: key);

  @override
  State<ExpansionTitleBase> createState() => _ExpansionTitleBaseState();
}

class _ExpansionTitleBaseState extends State<ExpansionTitleBase>
    with TickerProviderStateMixin {
  late final AnimationController _animateController;
  late final TextEditingController _controllerLogin;
  late final TextEditingController _controllerPassword;
  late final FocusNode _focusPassword;
  String valueDropDown = Routes.listExamsDoctorPage;

  @override
  void initState() {
    _animateController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _controllerLogin = TextEditingController();
    _controllerPassword = TextEditingController();
    _focusPassword = FocusNode();
    widget.selectedScreen.value = Routes.listExamsDoctorPage;
    super.initState();
  }

  @override
  void dispose() {
    _animateController.dispose();
    _controllerLogin.dispose();
    _controllerPassword.dispose();
    _focusPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      initiallyExpanded: widget.initialExpanded,
      collapsedBackgroundColor: ZeraColors.neutralLight01,
      backgroundColor: ZeraColors.neutralLight01,
      trailing: RotationTransition(
        turns: Tween(begin: 0.0, end: 0.5).animate(_animateController),
        child: Icon(
          ZeraIcons.arrow_up_1,
          color: ZeraColors.primaryMedium,
        ),
      ),
      onExpansionChanged: (isOpen) {
        if (_animateController.status == AnimationStatus.completed) {
          _animateController.reverse();
        } else {
          _animateController.forward();
        }
      },
      title: ZeraText(
        widget.title,
        color: ZeraColors.primaryDark,
        type: ZeraTextType.BOLD_16_DARK_01,
      ),
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 15.0, left: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: ZeraTextField(
                        readOnly: true,
                        style: ZeraTextFieldStyle.DISABLED,
                        controller: widget.controllerToken,
                        label: 'Token',
                        suffixIcon: IconButton(
                          padding: EdgeInsets.zero,
                          tooltip: 'Fazer Login para Token',
                          onPressed: () {
                            _controllerLogin.clear();
                            _controllerPassword.clear();

                            if (widget.title == 'Médico') {
                              _controllerLogin.text = 'CRM999123';
                              _controllerPassword.text =
                                  'Med!cos@Aplicativo2.0';
                            } else {
                              _controllerLogin.text = '46327239838';
                              _controllerPassword.text = 'Teste@123';
                            }

                            showDialog(
                              context: context,
                              builder: (BuildContext context) => Center(
                                child: AlertDialog(
                                  content: Container(
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(60),
                                      ),
                                    ),
                                    width: 300.0,
                                    height: 300,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: IconButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                            icon: const Icon(
                                              Icons.close,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20.0,
                                        ),
                                        SizedBox(
                                          height: 50.0,
                                          child: TextField(
                                            onSubmitted: (_) {
                                              _focusPassword.requestFocus();
                                            },
                                            controller: _controllerLogin,
                                            keyboardType: TextInputType.text,
                                            autofocus: true,
                                            decoration: InputDecoration(
                                              labelText: 'User',
                                              counterText: '',
                                              enabledBorder:
                                                  const OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  width: 1,
                                                  color: Colors.black,
                                                ), //<-- SEE HERE
                                              ),
                                              errorStyle: const TextStyle(
                                                height: kZero,
                                              ),
                                              prefixIcon: Icon(
                                                Icons.person,
                                                color: ZeraColors.primaryDark,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 15.0,
                                        ),
                                        SizedBox(
                                          height: 50.0,
                                          child: TextField(
                                            obscureText: true,
                                            focusNode: _focusPassword,
                                            controller: _controllerPassword,
                                            keyboardType:
                                                TextInputType.visiblePassword,
                                            decoration: InputDecoration(
                                              labelText: 'Password',
                                              counterText: '',
                                              enabledBorder:
                                                  const OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  width: 1,
                                                  color: Colors.black,
                                                ), //<-- SEE HERE
                                              ),
                                              errorStyle: const TextStyle(
                                                height: kZero,
                                              ),
                                              prefixIcon: Icon(
                                                Icons.vpn_key_sharp,
                                                color: ZeraColors.primaryDark,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 30.0,
                                        ),
                                        ZeraButton(
                                          text: 'Login',
                                          onPressed: () async {
                                            widget.controllerToken.clear();
                                            Navigator.of(context).pop();

                                            await widget.onTapToken(
                                              user:
                                                  _controllerLogin.text.trim(),
                                              password: _controllerPassword.text
                                                  .trim(),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.vpn_key_sharp,
                            color: ZeraColors.primaryDark,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 5.0,
              ),
              const SizedBox(
                height: 10.0,
              ),
              ZeraTextField(
                label: widget.label,
                controller: widget.controller,
              ),
              const SizedBox(
                height: 15.0,
              ),
              const Divider(),
              Visibility(
                visible: widget.title == 'Médico',
                child: Column(
                  children: [
                    DropdownButton<String>(
                      isExpanded: true,
                      value: valueDropDown,
                      items: [
                        DropdownMenuItem<String>(
                          child: const Text('Listagem de Exames'),
                          value: Routes.listExamsDoctorPage,
                        ),
                        DropdownMenuItem<String>(
                          child: const Text('Laudo Evolutivo'),
                          value: Routes.evolutionaryReportHome,
                        ),
                        DropdownMenuItem<String>(
                          child:
                              const Text('Histórico de exposição e radiação'),
                          value: Routes.doctorRadiationExposureHistoryPage,
                        ),
                      ],
                      onChanged: (String? value) {
                        valueDropDown = value ?? Routes.listExamsDoctorPage;
                        widget.selectedScreen.value = valueDropDown;
                        setState(() {});
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 20),
                      child: ZeraTextField(
                        controller: widget.controllerNamePatientDoctor,
                        label: 'Nome do Paciente',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 20),
                      child: ZeraTextField(
                        controller: widget.controllerPatientDoctor,
                        label: 'Prontuario',
                      ),
                    ),
                  ],
                ),
              ),
              ZeraButton(
                enabled: widget.enableButton ?? true,
                text: 'Avançar',
                onPressed: widget.actionButton,
              ),
              const SizedBox(
                height: 15.0,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
