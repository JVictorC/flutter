import 'package:base_dependencies/dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:micro_app_consumo_exame/core/constants/routes.dart';
import 'package:micro_app_consumo_exame/micro_app_exam_consumption.dart';
import 'package:micro_app_consumo_exame/modules/exams/presenter/pages/list_exams_page.dart';

import 'views/wrapper_home_page.dart';

final Map<String, WidgetBuilder> privateRoutes = {
  '/': (BuildContext context) => const WrapperHomePage(), //ExamHomePage(),
  //Routes.home: (BuildContext context) => const V2ExamHomePage(),
  Routes.listExamsPage: (BuildContext context) => const ListExamsPage(),
};

class BaseApp {
  final Map<String, MicroApp> microApps = {
    'micro_app_exam_consumption': MicroExamConsumption(),
  };

  /// Map para registration de SubApps
  late Map<String, MicroAppRegistration> registrationMap;

  Map<String, Cubit> globalBlocs = {};

  /// Rotas públicas
  late Map<String, WidgetBuilder> publicRoutes;

  /// Key que será utilizada para navegação entre telas para toda a aplicação
  GlobalKey<NavigatorState> mainNavigatorKey = GlobalKey<NavigatorState>();

  /// Local Storage Instance
  static LocalStorage storage = LocalStorage();

  /// Http Instance
  static ZeraHttp http = ZeraHttp();

  static ApplicationServices globalTagger = ApplicationTagger();

  /// Registro dos SubApps
  Map<String, MicroAppRegistration> _registerSubApps() {
    return microApps.map((name, app) => MapEntry(name, app.register()));
  }

  /// Carregar as rotas, passando por cada SubApp e adicionando as rotas dos mesmos
  Map<String, WidgetBuilder> _loadPublicRoutes() {
    Map<String, WidgetBuilder> routes = {};

    // public routes
    registrationMap.forEach(
      (name, registration) => routes.addAll(registration.publicRoutes),
    );

    // private routes
    routes.addAll(privateRoutes);

    return routes;
  }

  Future<void> initializeInstances() async {}

  Future<void> initializeSubApps() async {
    late MicroAppInitializationParameters parameters =
        MicroAppInitializationParameters(
      mainNavigatorKey,
      globalBlocs,
      http,
      globalTagger,
      BaseApp.storage,
      microApps,
    );

    microApps.forEach((name, app) => app.initialize(parameters));
  }

  /// Função para chamar os métodos de registro de SubApp e carregamento de rotas
  BaseApp() {
    registrationMap = _registerSubApps();
    publicRoutes = _loadPublicRoutes();
  }
}

/// Widget "pai" onde será inicializada a aplicação com as rotas e a navegação
class BaseAppPAge extends StatelessWidget {
  final Map<String, MicroApp> microAppsMap;
  final Map<String, WidgetBuilder> publicRoutes;
  final GlobalKey<NavigatorState> mainNavigatorKey;

  const BaseAppPAge({
    Key? key,
    required this.microAppsMap,
    required this.publicRoutes,
    required this.mainNavigatorKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: publicRoutes,
        navigatorKey: mainNavigatorKey,
        initialRoute: '/',
      );
}
