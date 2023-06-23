import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex_incie/src/main.dart';

import '../../../../../mock/shared_preferences_mock.dart';

void main() {
  final readSearchedPokemonHistoryRepository =
      ReadSearchedPokemonHistoryRepository(
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

  final mockPokemon = mockJson["data"]
      ?.map(
        (e) => PokemonModel.fromHistory(e),
      )
      .toList();

  group(
    'readSearchedPokemonHistoryRepository =>',
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
                },
              );
            },
          );

          test(
            'Should return a Result',
            () async {
              final result = await readSearchedPokemonHistoryRepository();

              expect(result, isA<Result>());
            },
          );

          test(
            'Should return a List<PokemonEntity> when sharedPreference returns a Success result',
            () async {
              final result = await readSearchedPokemonHistoryRepository();

              expect(result.isError, isFalse);
              expect(result.isSuccess, isTrue);

              final valueSuccess = result.value;

              expect(valueSuccess, isA<List<PokemonEntity>>());

              expect(valueSuccess, mockPokemon);
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
              final result = await readSearchedPokemonHistoryRepository();

              expect(result, isA<Result>());
            },
          );

          test(
            'Should return a ReadPokemonHistoryError when sharedPreference throw a Error result',
            () async {
              final result = await readSearchedPokemonHistoryRepository();

              expect(result.isError, isTrue);
              expect(result.isSuccess, isFalse);

              final valueError = result.error;

              expect(valueError, isA<ReadPokemonHistoryError>());
            },
          );
        },
      );
    },
  );
}
