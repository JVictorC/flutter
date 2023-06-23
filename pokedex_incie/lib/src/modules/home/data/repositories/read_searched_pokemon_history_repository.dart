import 'package:pokedex_incie/src/main.dart';

class ReadSearchedPokemonHistoryRepository
    implements IReadSearchedPokemonHistoryRepository {
  final ISharedPreference _client;

  ReadSearchedPokemonHistoryRepository(this._client);

  @override
  Future<Result<ReadPokemonHistoryError, List<PokemonEntity>>> call() async {
    try {
      final result = await _client.getMap(
        PokedexConstants.pokemonHistoryKey,
      );
      
      if (result.isEmpty) {
        return const Result.success([]);
      }

      final allPokemonsInHistory = result["data"] as List;

      final pokemonList = allPokemonsInHistory
          .map(
            (e) => PokemonModel.fromHistory(e),
          )
          .toList();

      return Result.success(pokemonList);
    } catch (e) {
      return Result.failure(
        ReadPokemonHistoryError(
          "Algo Inesperado Aconteceu",
        ),
      );
    }
  }
}
