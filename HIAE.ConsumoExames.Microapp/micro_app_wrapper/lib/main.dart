import 'package:base_dependencies/dependencies.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'src/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HiaeFlavors.initializeFlavors(
    configs: {
      Environment.DEV: {
        'baseUrl':
            'https://consumoexames-backend-dev.apps.ocp-rosa-hml.einstein.br',
        'apiKey': 'fdca5be9-6d4c-421a-a991-befcac13e405',
        'environment': Environment.DEV,
      },
      Environment.QAS: {
        'baseUrl':
            'https://consumoexames-backend-qas.apps.ocp-rosa-hml.einstein.br',
        'apiKey': 'f32fdf49-1528-4ae4-bcbd-296c27441297',
        'environment': Environment.QAS,
      },
      Environment.STG: {
        'baseUrl':
            'https://consumoexames-backend-stg.apps.ocp-rosa-hml.einstein.br',
        'apiKey': '2957b022-5a52-4247-b48c-516c9c3ee748',
        'environment': Environment.STG,
      },
      Environment.PRD: {
        'baseUrl':
            'https://consumoexames-backend-prd.apps.ocp-rosa-hml.einstein.br',
        'apiKey': '20d0953f-b7ad-4df5-b4ac-e32c63da8a6d',
        'environment': Environment.PRD,
      },
    },
    defaultConfig: {
      'baseUrl':
          'https://consumoexames-backend-dev.apps.ocp-rosa-hml.einstein.br',
      'apiKey': '20d0953f-b7ad-4df5-b4ac-e32c63da8a6d',
      'environment': Environment.DEV,
    },
  );

  final mainApp = BaseApp();
  await mainApp.initializeInstances();
  await mainApp.initializeSubApps();

  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        Provider<ZeraTheme>(create: (context) => defaultZeraTheme),
      ],
      child: BaseAppPAge(
        mainNavigatorKey: mainApp.mainNavigatorKey,
        microAppsMap: mainApp.microApps,
        publicRoutes: mainApp.publicRoutes,
      ),
    ),
  );
}
