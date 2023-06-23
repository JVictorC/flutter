import 'package:pokedex_incie/src/main.dart';

initUseCasesDependencies() {
  I.registesDependency<IGetPokemonByNameUsecase>(
    GetPokemonByNameUsecase(
      repository: I.get<IGetPokemonByNameRepository>(),
    ),
  );

  I.registesDependency<IGetAllPokemonTypeUsecase>(
    GetAllPokemonTypeUsecase(
      repository: I.get<IGetAllPokemonTypeRepository>(),
    ),
  );

  I.registesDependency<ISaveSearchedPokemonHistoryUseCase>(
    SaveSearchedPokemonHistoryUseCase(
      repository: I.get<ISaveSearchedPokemonHistoryRepository>(),
    ),
  );

  I.registesDependency<IReadSearchedPokemonHistoryUseCase>(
    ReadSearchedPokemonHistoryUseCase(
      repository: I.get<IReadSearchedPokemonHistoryRepository>(),
    ),
  );
}
