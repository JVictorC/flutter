import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex_incie/src/main.dart';

import '../../../../../mock/http_client_mock.dart';

void main() {
  final getPokemonByNameRepository = GetPokemonByNameRepository(
    httpClientMock,
  );

  final mockJson = {
    "stats": [
      {
        "base_stat": 35,
        "effort": 0,
        "stat": {"name": "hp", "url": "https://pokeapi.co/api/v2/stat/1/"}
      },
      {
        "base_stat": 55,
        "effort": 0,
        "stat": {"name": "attack", "url": "https://pokeapi.co/api/v2/stat/2/"}
      },
      {
        "base_stat": 40,
        "effort": 0,
        "stat": {"name": "defense", "url": "https://pokeapi.co/api/v2/stat/3/"}
      },
    ],
    "types": [
      {
        "slot": 1,
        "type": {
          "name": "electric",
          "url": "https://pokeapi.co/api/v2/type/13/"
        }
      }
    ],
    "name": "pikachu",
    "id": 25,
    "sprites": {
      "other": {
        "official-artwork": {
          "front_default":
              "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/25.png"
        },
      },
    },
  };

  final mockPokemon = PokemonModel.fromMap(mockJson);

  group(
    'GetPokemonByNameRepository =>',
    () {
      group(
        'Success Cases =>',
        () {
          group(
            'Set ups',
            () {
              setUpAll(
                () {
                  when(() => httpClientMock.get(any())).thenAnswer(
                    (invocation) async => ClientResponse(
                      body: mockJson,
                      statusCode: 200,
                    ),
                  );
                },
              );
            },
          );

          test(
            'Should return a Result',
            () async {
              final result = await getPokemonByNameRepository(
                "nome Pokemon Teste",
              );

              expect(result, isA<Result>());
            },
          );

          test(
            'Should return a PokemonEntity when httpClient returns a Success result',
            () async {
              final result = await getPokemonByNameRepository(
                "nome Pokemon Teste",
              );

              expect(result.isError, isFalse);
              expect(result.isSuccess, isTrue);

              final valueSuccess = result.value;

              expect(valueSuccess, isA<PokemonEntity>());

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
                  when(() => httpClientMock.get(any())).thenThrow(
                    0 / 10,
                  );
                },
              );
            },
          );

          test(
            'Should return a Result',
            () async {
              final result = await getPokemonByNameRepository(
                "nome Pokemon Teste",
              );

              expect(result, isA<Result>());
            },
          );

          test(
            'Should return a GetPokemonByNameError with message "O nome não pode ser Vazio", when passed a namePokemon empty',
            () async {
              final result = await getPokemonByNameRepository(
                "",
              );

              expect(result.isError, isTrue);
              expect(result.isSuccess, isFalse);

              final valueError = result.error;

              expect(valueError, isA<GetPokemonByNameError>());
              expect(valueError?.message, "O nome não pode ser Vazio");

            },
          );

          test(
            'Should return a GetPokemonByNameError when httpClient throw a Error result',
            () async {
              final result = await getPokemonByNameRepository(
                "nome Pokemon Teste",
              );

              expect(result.isError, isTrue);
              expect(result.isSuccess, isFalse);

              final valueError = result.error;

              expect(valueError, isA<GetPokemonByNameError>());
            },
          );
        },
      );
    },
  );
}
