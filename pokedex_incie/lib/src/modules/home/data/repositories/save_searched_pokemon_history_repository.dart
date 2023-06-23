import 'package:pokedex_incie/src/main.dart';


class SaveSearchedPokemonHistoryRepository
    implements ISaveSearchedPokemonHistoryRepository {
  final ISharedPreference _client;

  SaveSearchedPokemonHistoryRepository(this._client);

  @override
  Future<Result<SavePokemonError, bool>> call(PokemonEntity pokemon) async {
    try {
      final newPokemon = PokemonModel.fromEntity(pokemon).toJson();
      final dataInHistory = await _client.getMap(
        PokedexConstants.pokemonHistoryKey,
      );

      if (dataInHistory.isEmpty) {
        await _client.saveMap(
          PokedexConstants.pokemonHistoryKey,
          {
            "data": [
              newPokemon,
            ]
          },
        );
        return const Result.success(true);
      }

      final allPokemonsInHistory = dataInHistory["data"] as List;

      allPokemonsInHistory.removeWhere(
        (element) => element.toString().contains(pokemon.name),
      );

      allPokemonsInHistory.add(newPokemon);


      await _client.saveMap(
        PokedexConstants.pokemonHistoryKey,
        {
          "data": allPokemonsInHistory,
        },
      );

      return const Result.success(true);
    } catch (e) {
      return Result.failure(SavePokemonError("Algo Inesperado Aconteceu"));
    }
  }
}
