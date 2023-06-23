import 'package:pokedex_incie/src/main.dart';

abstract class IGetAllPokemonTypeRepository {
  Future<Result<GetPokemonTypeError, List<PokemonTypeEntity>>> call();
}
