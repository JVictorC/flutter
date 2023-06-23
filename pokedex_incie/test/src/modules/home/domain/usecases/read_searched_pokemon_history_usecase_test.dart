import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex_incie/src/main.dart';

class ReadSearchedPokemonHistoryRepositoryMock extends Mock implements IReadSearchedPokemonHistoryRepository {}

void main() {
  final readSearchedPokemonHistoryRepositoryMock =ReadSearchedPokemonHistoryRepositoryMock();
  final readSearchedPokemonHistoryUseCase = ReadSearchedPokemonHistoryUseCase(
    repository: readSearchedPokemonHistoryRepositoryMock,
  );

  const mockPokemon = [
    PokemonModel(
      imagePokemon: "imagePokemon",
      name: "name",
      id: "id",
      type: "type",
      healthPoints: "healthPoints",
      strengthPoints: "strengthPoints",
      defensePoints: "defensePoints",
    ),
  ];

  group(
    'ReadSearchedPokemonHistoryUseCase =>',
    () {
      group(
        'Success Cases =>',
        () {
          group(
            'Set ups',
            () {
              setUpAll(() {
                when(() => readSearchedPokemonHistoryRepositoryMock())
                    .thenAnswer(
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
              final result = await readSearchedPokemonHistoryUseCase();

              expect(result, isA<Result>());
            },
          );

          test(
            'Should return a List<PokemonEntity> when repository returns a Success result',
            () async {
              final result = await readSearchedPokemonHistoryUseCase();

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
              setUpAll(() {
                when(() => readSearchedPokemonHistoryRepositoryMock())
                    .thenAnswer(
                  (invocation) async => Result.failure(
                    ReadPokemonHistoryError("Erro para teste"),
                  ),
                );
              });
            },
          );

          test(
            'Should return a Result',
            () async {
              final result = await readSearchedPokemonHistoryUseCase();

              expect(result, isA<Result>());
            },
          );

          test(
            'Should return a ReadPokemonHistoryError when repository returns a Error result',
            () async {
              final result = await readSearchedPokemonHistoryUseCase();

              expect(result.isError, isTrue);
              expect(result.isSuccess, isFalse);

              final valueError = result.error;

              expect(valueError, isA<ReadPokemonHistoryError>());

              expect(valueError?.message, "Erro para teste");
            },
          );
        },
      );
    },
  );
}
