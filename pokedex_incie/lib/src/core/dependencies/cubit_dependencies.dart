import 'package:pokedex_incie/src/main.dart';

initCubitDependencies() {
  I.registesDependency<HomePageCubit>(
    HomePageCubit(
      getPokemonByNameUsecase: I.get<IGetPokemonByNameUsecase>(),
      getAllPokemonTypeUsecase: I.get<IGetAllPokemonTypeUsecase>(),
      readSearchedPokemonHistoryUseCase: I.get<IReadSearchedPokemonHistoryUseCase>(),
      saveSearchedPokemonHistoryUseCase: I.get<ISaveSearchedPokemonHistoryUseCase>(),
    ),
  );
}
