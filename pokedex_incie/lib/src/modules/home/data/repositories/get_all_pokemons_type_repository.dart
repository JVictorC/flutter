import 'package:pokedex_incie/src/main.dart';

class GetAllPokemonTypeRepository implements IGetAllPokemonTypeRepository {
  final IHttpClient _client;

  GetAllPokemonTypeRepository(this._client);

  @override
  Future<Result<GetPokemonTypeError, List<PokemonTypeEntity>>> call() async {
    try {
      final data = await _client.get(
        'https://pokeapi.co/api/v2/type/',
      );

      final pokemonTypeList = (data.body["results"] as List)
          .map((e) => PokemonTypeModel.fromMap(e))
          .toList();

      return Result.success(pokemonTypeList);
    } catch (e) {
      return Result.failure(GetPokemonTypeError("Algo Inesperado Aconteceu"));
    }
  }
}
