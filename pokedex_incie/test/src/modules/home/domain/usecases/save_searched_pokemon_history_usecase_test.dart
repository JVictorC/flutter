import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex_incie/src/main.dart';

class SaveSearchedPokemonHistoryRepositoryMock extends Mock implements ISaveSearchedPokemonHistoryRepository {}

class PokemonModelFake extends Fake implements PokemonModel {}

void main() {
  setUpAll(
    () {
      registerFallbackValue(PokemonModelFake());
    },
  );
  final saveSearchedPokemonHistoryRepositoryMock = SaveSearchedPokemonHistoryRepositoryMock();
  final saveSearchedPokemonHistoryUseCase = SaveSearchedPokemonHistoryUseCase(
    repository: saveSearchedPokemonHistoryRepositoryMock,
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
    'SaveSearchedPokemonHistoryUseCase =>',
    () {
      group(
        'Success Cases =>',
        () {
          group(
            'Set ups',
            () {
              setUpAll(() {
                when(
                  () => saveSearchedPokemonHistoryRepositoryMock(
                    any(),
                  ),
                ).thenAnswer(
                  (invocation) async => const Result.success(
                    true,
                  ),
                );
              });
            },
          );

          test(
            'Should return a Result',
            () async {
              final result = await saveSearchedPokemonHistoryUseCase(
                mockPokemon,
              );

              expect(result, isA<Result>());
            },
          );

          test(
            'Should return a bool when repository returns a Success result',
            () async {
              final result = await saveSearchedPokemonHistoryUseCase(
                mockPokemon,
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
              setUpAll(() {
                when(() => saveSearchedPokemonHistoryRepositoryMock(any()))
                    .thenAnswer(
                  (invocation) async => Result.failure(
                    SavePokemonError("Erro para teste"),
                  ),
                );
              });
            },
          );

          test(
            'Should return a Result',
            () async {
              final result = await saveSearchedPokemonHistoryUseCase(
                mockPokemon,
              );

              expect(result, isA<Result>());
            },
          );

          test(
            'Should return a SavePokemonError when repository returns a Error result',
            () async {
              final result = await saveSearchedPokemonHistoryUseCase(
                mockPokemon,
              );

              expect(result.isError, isTrue);
              expect(result.isSuccess, isFalse);

              final valueError = result.error;

              expect(valueError, isA<SavePokemonError>());

              expect(valueError?.message, "Erro para teste");
            },
          );
        },
      );
    },
  );
}
