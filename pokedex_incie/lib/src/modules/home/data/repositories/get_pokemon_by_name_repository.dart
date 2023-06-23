import 'package:pokedex_incie/src/main.dart';

class GetPokemonByNameRepository implements IGetPokemonByNameRepository {
  final IHttpClient _client;

  GetPokemonByNameRepository(this._client);

  @override
  Future<Result<GetPokemonByNameError, PokemonEntity>> call(
      String namePokemon) async {
    try {
      if (namePokemon.isEmpty) {
        throw GetPokemonByNameError("O nome não pode ser Vazio");
      }
      final data = await _client.get(
        'https://pokeapi.co/api/v2/pokemon/${namePokemon.toLowerCase()}',
      );

      final pokemon = PokemonModel.fromMap(data.body);

      return Result.success(pokemon);
    } on GetPokemonByNameError catch (e) {
      return Result.failure(e);
    } catch (e) {
      if (e.toString().contains("Not Found")) {
        return Result.failure(GetPokemonByNameError("Pokemon Não Encontrado"));
      }
      return Result.failure(GetPokemonByNameError("Algo Inesperado Aconteceu"));
    }
  }
}
