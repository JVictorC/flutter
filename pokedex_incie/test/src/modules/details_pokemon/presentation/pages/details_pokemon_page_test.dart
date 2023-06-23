import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex_incie/src/main.dart';

void main() {
  defaultApp() => MaterialApp(
        home: Navigator(
          onGenerateRoute: (_) {
            return MaterialPageRoute(
              builder: (_) => const DetailsPokemonPage(),
              settings: const RouteSettings(
                arguments: {
                  "pokemon": PokemonModel(
                    imagePokemon:
                        "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/25.png",
                    name: "pikachu",
                    id: "25",
                    type: "electric",
                    healthPoints: "30",
                    strengthPoints: "50",
                    defensePoints: "70",
                  ),
                },
              ),
            );
          },
        ),
      );
  group(
    'DetailsPokemonPage =>',
    () {
      testWidgets(
        'Should BUild WIthout explode',
        (test) async {
          await test.pumpWidget(defaultApp());
          final detailsPokemon = find.byType(DetailsPokemonPage);
          expect(detailsPokemon, findsOneWidget);
        },
      );

      testWidgets(
        'Expect find some widgets',
        (test) async {
          await test.pumpWidget(defaultApp());

          final image = find.byKey(
            const Key("DetailsPageImage"),
          );
          final status = find.byKey(
            const Key("DetailsPageStatus"),
          );
          final details = find.byKey(
            const Key("DetailsPageDetails"),
          );

          expect(image, findsOneWidget);
          expect(status, findsOneWidget);
          expect(details, findsOneWidget);
        },
      );
    },
  );
}
