import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex_incie/src/main.dart';

import '../../../../../mock/http_client_mock.dart';

void main() {
  final getAllPokemonTypeRepository = GetAllPokemonTypeRepository(
    httpClientMock,
  );

  final mockJson = {
    "results": [
      {"name": "normal", "url": "https://pokeapi.co/api/v2/type/1/"},
      {"name": "fighting", "url": "https://pokeapi.co/api/v2/type/2/"},
      {"name": "flying", "url": "https://pokeapi.co/api/v2/type/3/"},
      {"name": "poison", "url": "https://pokeapi.co/api/v2/type/4/"},
      {"name": "ground", "url": "https://pokeapi.co/api/v2/type/5/"},
      {"name": "rock", "url": "https://pokeapi.co/api/v2/type/6/"},
      {"name": "bug", "url": "https://pokeapi.co/api/v2/type/7/"},
      {"name": "ghost", "url": "https://pokeapi.co/api/v2/type/8/"},
      {"name": "steel", "url": "https://pokeapi.co/api/v2/type/9/"},
    ],
  };

  final mockPokemon = mockJson["results"]
      ?.map(
        (e) => PokemonTypeModel.fromMap(e),
      )
      .toList();

  group(
    'GetAllPokemonTypeRepository =>',
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
              final result = await getAllPokemonTypeRepository();

              expect(result, isA<Result>());
            },
          );

          test(
            'Should return a List<PokemonTypeEntity> when httpClient returns a Success result',
            () async {
              final result = await getAllPokemonTypeRepository();

              expect(result.isError, isFalse);
              expect(result.isSuccess, isTrue);

              final valueSuccess = result.value;

              expect(valueSuccess, isA<List<PokemonTypeEntity>>());

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
              final result = await getAllPokemonTypeRepository();

              expect(result, isA<Result>());
            },
          );

          test(
            'Should return a GetPokemonTypeError when httpClient throw a Error result',
            () async {
              final result = await getAllPokemonTypeRepository();

              expect(result.isError, isTrue);
              expect(result.isSuccess, isFalse);

              final valueError = result.error;

              expect(valueError, isA<GetPokemonTypeError>());
            },
          );
        },
      );
    },
  );
}
