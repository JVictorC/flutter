import 'package:pokedex_incie/src/main.dart';

abstract class IReadSearchedPokemonHistoryRepository {
  Future<Result<ReadPokemonHistoryError, List<PokemonEntity>>> call();
}