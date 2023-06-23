

import 'package:pokedex_incie/src/main.dart';

initRepositoriesDependencies() {
 I.registesDependency<IGetPokemonByNameRepository>(
    GetPokemonByNameRepository(
      I.get<IHttpClient>()
    ),
  );

   I.registesDependency<IGetAllPokemonTypeRepository>(
    GetAllPokemonTypeRepository(
      I.get<IHttpClient>()
    ),
  );

  I.registesDependency<ISaveSearchedPokemonHistoryRepository>(
    SaveSearchedPokemonHistoryRepository(
      I.get<ISharedPreference>()
    ),
  );

    I.registesDependency<IReadSearchedPokemonHistoryRepository>(
    ReadSearchedPokemonHistoryRepository(
      I.get<ISharedPreference>()
    ),
  );
}
