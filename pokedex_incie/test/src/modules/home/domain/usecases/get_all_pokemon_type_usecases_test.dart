import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex_incie/src/main.dart';

class GetAllPokemonTypeRepositoryMock extends Mock implements IGetAllPokemonTypeRepository {}

void main() {
  final getAllPokemonTypeRepositoryMock = GetAllPokemonTypeRepositoryMock();
  final getAllPokemonTypeUsecase = GetAllPokemonTypeUsecase(
    repository: getAllPokemonTypeRepositoryMock,
  );

  const mockPokemons = [
    PokemonTypeModel(
      name: "name",
      url: "url",
    ),
  ];

  group(
    'GetAllPokemonTypeUsecase =>',
    () {
      group(
        'Success Cases =>',
        () {
          group(
            'Set ups',
            () {
              setUpAll(() {
                when(() => getAllPokemonTypeRepositoryMock()).thenAnswer(
                  (invocation) async => const Result.success(
                    mockPokemons,
                  ),
                );
              });
            },
          );

          test(
            'Should return a Result',
            () async {
              final result = await getAllPokemonTypeUsecase();

              expect(result, isA<Result>());
            },
          );

          test(
            'Should return a List<PokemonTypeEntity> when repository returns a Success result',
            () async {
              final result = await getAllPokemonTypeUsecase();

              expect(result.isError, isFalse);
              expect(result.isSuccess, isTrue);

              final valueSuccess = result.value;

              expect(valueSuccess, isA<List<PokemonTypeEntity>>());

              expect(valueSuccess, mockPokemons);
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
                when(() => getAllPokemonTypeRepositoryMock()).thenAnswer(
                  (invocation) async => Result.failure(
                    GetPokemonTypeError("Erro para teste"),
                  ),
                );
              });
            },
          );

          test(
            'Should return a Result',
            () async {
              final result = await getAllPokemonTypeUsecase();

              expect(result, isA<Result>());
            },
          );

          test(
            'Should return a GetPokemonTypeError when repository returns a Error result',
            () async {
              final result = await getAllPokemonTypeUsecase();

              expect(result.isError, isTrue);
              expect(result.isSuccess, isFalse);

              final valueError = result.error;

              expect(valueError, isA<GetPokemonTypeError>());

              expect(valueError?.message, "Erro para teste");
            },
          );
        },
      );
    },
  );
}
