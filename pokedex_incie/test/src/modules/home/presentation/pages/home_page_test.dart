import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex_incie/src/main.dart';

class GetPokemonByNameUsecaseMock extends Mock implements IGetPokemonByNameUsecase {}
class GetAllPokemonTypeUsecaseMock extends Mock implements IGetAllPokemonTypeUsecase {}
class SaveSearchedPokemonHistoryUseCaseMock extends Mock implements ISaveSearchedPokemonHistoryUseCase {}

class ReadSearchedPokemonHistoryUseCaseMock extends Mock implements IReadSearchedPokemonHistoryUseCase {}

void main() {
  final getPokemonByNameUsecaseMock = GetPokemonByNameUsecaseMock();
  final getAllPokemonTypeUsecaseMock = GetAllPokemonTypeUsecaseMock();
  final saveSearchedPokemonHistoryUseCaseMock =SaveSearchedPokemonHistoryUseCaseMock();
  final readSearchedPokemonHistoryUseCaseMock =ReadSearchedPokemonHistoryUseCaseMock();

  const mockPokemon = PokemonModel(
    imagePokemon: "imagePokemon",
    name: "Pikachu",
    id: "id",
    type: "type",
    healthPoints: "healthPoints",
    strengthPoints: "strengthPoints",
    defensePoints: "defensePoints",
  );

  cubit() => HomePageCubit(
        getPokemonByNameUsecase: getPokemonByNameUsecaseMock,
        getAllPokemonTypeUsecase: getAllPokemonTypeUsecaseMock,
        saveSearchedPokemonHistoryUseCase: saveSearchedPokemonHistoryUseCaseMock,
        readSearchedPokemonHistoryUseCase: readSearchedPokemonHistoryUseCaseMock,
      );

  defaultTestableWidget() => BlocProvider(
        create: (_) => cubit(),
        child: WidgetTestable.of(
          const HomePage(),
        ).build(),
      );

  group(
    'HomePage =>',
    () {
      setUpAll(
        () async {
          I.registesDependency<HomePageCubit>(
            cubit(),
          );

          I.registesDependency<IGetPokemonByNameUsecase>(
            getPokemonByNameUsecaseMock,
          );
          I.registesDependency<IGetAllPokemonTypeUsecase>(
            getAllPokemonTypeUsecaseMock,
          );
          I.registesDependency<ISaveSearchedPokemonHistoryUseCase>(
            saveSearchedPokemonHistoryUseCaseMock,
          );
          I.registesDependency<IReadSearchedPokemonHistoryUseCase>(
            readSearchedPokemonHistoryUseCaseMock,
          );

          when(
            () => getPokemonByNameUsecaseMock(
              namePokemon: "Pikachu",
            ),
          ).thenAnswer(
            (invocation) async => const Result.success(
              mockPokemon,
            ),
          );

          when(
            () => saveSearchedPokemonHistoryUseCaseMock(
              mockPokemon,
            ),
          ).thenAnswer(
            (invocation) async => const Result.success(
              true,
            ),
          );

          when(
            () => getAllPokemonTypeUsecaseMock(),
          ).thenAnswer(
            (invocation) async => const Result.success(
              [
                PokemonTypeModel(
                  name: "name",
                  url: "url",
                ),
              ],
            ),
          );

          when(() => readSearchedPokemonHistoryUseCaseMock()).thenAnswer(
            (invocation) async => const Result.success([
              mockPokemon,
            ]),
          );
        },
      );
      testWidgets(
        'Should build without explode',
        (test) async {
          await test.pumpWidget(
            BlocProvider(
              create: (_) => cubit(),
              child: defaultTestableWidget(),
            ),
          );

          final operatorsAddPage = find.byType(HomePage);

          expect(operatorsAddPage, findsOneWidget);
        },
      );

      testWidgets(
        'Should search a Pokemon and Redirect to details',
        (test) async {
          await test.pumpWidget(
            defaultTestableWidget(),
          );

          final textField = find.byKey(
            const Key("HomePageTextField"),
          );

          final buttonConfirmTextFormField = find.byKey(
            const Key(
              "HomePageButtonConfirmTextFormField",
            ),
          );

          expect(textField, findsOneWidget);
          expect(
            buttonConfirmTextFormField,
            findsOneWidget,
          );

          await test.ensureVisible(
            textField,
          );
          await test.pumpAndSettle();

          await test.enterText(textField, "Pikachu");

          final textWidget = test.widget(textField);

          expect(textWidget, isA<TextField>());
          expect(
            (textWidget as TextField).controller?.text,
            "Pikachu",
          );

          await test.ensureVisible(
            buttonConfirmTextFormField,
          );
          await test.pumpAndSettle();

          await test.tap(buttonConfirmTextFormField);

          verify(
            () => getPokemonByNameUsecaseMock(
              namePokemon: "Pikachu",
            ),
          ).called(1);

          verify(
            () => saveSearchedPokemonHistoryUseCaseMock(
              mockPokemon,
            ),
          ).called(1);
        },
      );
    },
  );
}
