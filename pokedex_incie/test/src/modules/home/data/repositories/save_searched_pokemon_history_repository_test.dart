import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex_incie/src/main.dart';

import '../../../../../mock/shared_preferences_mock.dart';

class PokemonModelFake extends Fake implements PokemonModel {}

void main() {
  setUpAll(
    () {
      registerFallbackValue(PokemonModelFake());
    },
  );
  const mockPokemon = PokemonModel(
    imagePokemon: "imagePokemon",
    name: "name",
    id: "id",
    type: "type",
    healthPoints: "healthPoints",
    strengthPoints: "strengthPoints",
    defensePoints: "defensePoints",
  );

  final saveSearchedPokemonHistoryRepository =
      SaveSearchedPokemonHistoryRepository(
    sharedPreferenceMock,
  );

  final mockJson = {
    "data": [
      jsonEncode(
        {
          "imagePokemon":
              "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/25.png",
          "name": "pikachu",
          "id": "25",
          "type": "electric",
          "healthPoints": "35",
          "strengthPoints": "55",
          "defensePoints": "40",
        },
      ),
    ],
  };

  group(
    'SaveSearchedPokemonHistoryRepository =>',
    () {
      group(
        'Success Cases =>',
        () {
          group(
            'Set ups',
            () {
              setUpAll(
                () {
                  when(
                    () => sharedPreferenceMock.getMap(
                      PokedexConstants.pokemonHistoryKey,
                    ),
                  ).thenAnswer(
                    (invocation) async => mockJson,
                  );

                  when(
                    () => sharedPreferenceMock.saveMap(
                      PokedexConstants.pokemonHistoryKey,
                      any(),
                    ),
                  ).thenAnswer(
                    (invocation) async => true,
                  );
                },
              );
            },
          );

          test(
            'Should return a Result',
            () async {
              final result =
                  await saveSearchedPokemonHistoryRepository(mockPokemon);

              expect(result, isA<Result>());
            },
          );

          test(
            'Should return a bool when sharedPreference returns a Success result',
            () async {
              final result =
                  await saveSearchedPokemonHistoryRepository(mockPokemon);

              expect(result.isError, isFalse);
              expect(result.isSuccess, isTrue);

              final valueSuccess = result.value;

              expect(valueSuccess, isA<bool>());

              expect(valueSuccess, isTrue);
            },
          );

          test(
            'Should create a new map in memory when not exist data in memory',
            () async {
              when(
                () => sharedPreferenceMock.getMap(
                  PokedexConstants.pokemonHistoryKey,
                ),
              ).thenAnswer(
                (invocation) async => {},
              );
              final result =
                  await saveSearchedPokemonHistoryRepository(mockPokemon);

              verify(
                () => sharedPreferenceMock.saveMap(
                  PokedexConstants.pokemonHistoryKey,
                  {
                    "data": [
                      mockPokemon.toJson(),
                    ]
                  },
                ),
              );

              expect(result.isError, isFalse);
              expect(result.isSuccess, isTrue);

              final valueSuccess = result.value;

              expect(valueSuccess, isA<bool>());

              expect(valueSuccess, isTrue);
            },
          );

        },
      );

      group(
        'Error Cases =>',
        () {
          group(
            'Set ups',
            () {
              setUpAll(
                () {
                  when(
                    () => sharedPreferenceMock.getMap(
                      PokedexConstants.pokemonHistoryKey,
                    ),
                  ).thenThrow(
                    0 / 10,
                  );
                },
              );
            },
          );

          test(
            'Should return a Result',
            () async {
              final result =
                  await saveSearchedPokemonHistoryRepository(mockPokemon);

              expect(result, isA<Result>());
            },
          );

          test(
            'Should return a SavePokemonError when sharedPreference throw a Error result',
            () async {
              final result =
                  await saveSearchedPokemonHistoryRepository(mockPokemon);

              expect(result.isError, isTrue);
              expect(result.isSuccess, isFalse);

              final valueError = result.error;

              expect(valueError, isA<SavePokemonError>());
            },
          );
        },
      );
    },
  );
}
