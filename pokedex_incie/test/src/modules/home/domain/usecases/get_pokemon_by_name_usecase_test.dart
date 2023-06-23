import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex_incie/src/main.dart';

class GetPokemonByNameRepositoryMock extends Mock implements IGetPokemonByNameRepository {}

void main() {
  final getPokemonByNameRepositoryMock = GetPokemonByNameRepositoryMock();
  final getPokemonByNameUsecase = GetPokemonByNameUsecase(
    repository: getPokemonByNameRepositoryMock,
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

  group(
    'GetPokemonByNameUsecase =>',
    () {
      group(
        'Success Cases =>',
        () {
          group(
            'Set ups',
            () {
              setUpAll(() {
                when(() => getPokemonByNameRepositoryMock(any())).thenAnswer(
                  (invocation) async => const Result.success(
                    mockPokemon,
                  ),
                );
              });
            },
          );

          test(
            'Should return a Result',
            () async {
              final result = await getPokemonByNameUsecase(namePokemon: "Pokemon teste");

              expect(result, isA<Result>());
            },
          );

          test(
            'Should return a PokemonEntity when repository returns a Success result',
            () async {
              final result = await getPokemonByNameUsecase(namePokemon: "Pokemon teste");

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
              setUpAll(() {
                when(() => getPokemonByNameRepositoryMock(any())).thenAnswer(
                  (invocation) async => Result.failure(
                    GetPokemonByNameError("Erro para teste"),
                  ),
                );
              });
            },
          );

          test(
            'Should return a Result',
            () async {
              final result = await getPokemonByNameUsecase(namePokemon: "Pokemon teste");

              expect(result, isA<Result>());
            },
          );

          test(
            'Should return a GetPokemonByNameError when repository returns a Error result',
            () async {
              final result = await getPokemonByNameUsecase(namePokemon: "Pokemon teste");

              expect(result.isError, isTrue);
              expect(result.isSuccess, isFalse);

              final valueError = result.error;

              expect(valueError, isA<GetPokemonByNameError>());

              expect(valueError?.message, "Erro para teste");
            },
          );
        },
      );
    },
  );
}
