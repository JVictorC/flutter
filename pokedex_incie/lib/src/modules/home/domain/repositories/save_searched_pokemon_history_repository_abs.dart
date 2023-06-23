import 'package:pokedex_incie/src/main.dart';

abstract class ISaveSearchedPokemonHistoryRepository {
  Future<Result<SavePokemonError,bool>> call(PokemonEntity pokemon);
}