import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex_incie/src/main.dart';

void main() {
  defaultTestableWidget() => WidgetTestable.of(
        const OnboardingPage(),
      ).makeMockRoutes(
        r: {
          PokedexRoutes.homePage: (_) => const Center(
                child: Text("Estou na Home"),
              ),
        },
      ).build();
  group(
    'OnboardingPage =>',
    () {
      testWidgets(
        'Should build without explode',
        (test) async {
          await test.pumpWidget(defaultTestableWidget());

          final operatorsAddPage = find.byType(OnboardingPage);

          expect(operatorsAddPage, findsOneWidget);
        },
      );

      testWidgets(
        'Should find somethings widgets in screen',
        (test) async {
          await test.pumpWidget(defaultTestableWidget());

          final backGroundImage = find.byKey(
            const Key("OnboardingPageBackGroundImage"),
          );

          final backGroundImageWidget = test.widget(
            backGroundImage,
          );

          expect(backGroundImageWidget, isA<Image>());
          expect(
            ((backGroundImageWidget as Image).image as AssetImage).assetName,
            "assets/images/IMG_BACKGROUND_ONBOARDING.png",
          );
          expect(backGroundImage, findsOneWidget);

          final logoImage = find.byKey(
            const Key("OnboardingPageLogoImage"),
          );

          final logoImageWidget = test.widget(
            logoImage,
          );

          expect(logoImageWidget, isA<Image>());
          expect(
            ((logoImageWidget as Image).image as AssetImage).assetName,
            "assets/images/IMG_LOGO_INICIE.png",
          );
          expect(backGroundImage, findsOneWidget);

          expect(logoImage, findsOneWidget);

          final title = find.byKey(
            const Key("OnboardingPageTitle"),
          );

          expect(title, findsOneWidget);

          final subTitle = find.byKey(
            const Key("OnboardingPageSubTitle"),
          );

          expect(subTitle, findsOneWidget);

          final buttonStart = find.byKey(
            const Key("OnboardingPageButtonStart"),
          );

          expect(buttonStart, findsOneWidget);
        },
      );

      testWidgets(
        'Should navigator for home when click in "Começar"',
        (test) async {
          await test.pumpWidget(defaultTestableWidget());

          final buttonStart = find.byKey(
            const Key("OnboardingPageButtonStart"),
          );

          expect(buttonStart, findsOneWidget);

          await test.ensureVisible(buttonStart);
          await test.pumpAndSettle();

          await test.tap(buttonStart);

          await test.pumpAndSettle();

          final mockHome = find.text("Estou na Home");

          expect(mockHome, findsOneWidget);
        },
      );
    },
  );
}
