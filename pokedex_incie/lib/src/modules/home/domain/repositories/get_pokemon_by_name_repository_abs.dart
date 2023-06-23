import 'package:pokedex_incie/src/main.dart';

abstract class IGetPokemonByNameRepository {
  Future<Result<GetPokemonByNameError, PokemonEntity>> call(
    String namePokemon,
  );
}
